const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const { GoogleGenAI } = require('@google/genai');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.status(200).send({
    ok: true,
    service: 'medbot-api',
    message: 'Server is running. Use /login, /register, /user/:email, /api/chats/*',
  });
});

app.get('/health', (req, res) => {
  res.status(200).send({ ok: true });
});

const UPLOADS_DIR = path.join(__dirname, 'uploads');
fs.mkdirSync(UPLOADS_DIR, { recursive: true });
app.use('/uploads', express.static(UPLOADS_DIR));

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, UPLOADS_DIR);
  },
  filename: (req, file, cb) => {
    const email = req.params.email.replace(/[^a-zA-Z0-9]/g, '_');
    const ext = path.extname(file.originalname);
    cb(null, `${email}${ext}`);
  }
});
const upload = multer({ storage: storage });

const mongouri = process.env.MONGODB_URI;
if (!mongouri) {
  throw new Error('MONGODB_URI is required (set it in server/.env or environment)');
}

mongoose.connect(mongouri)
  .then(() => console.log('mongodb подключен успешно'))
  .catch((err) => console.error('ошибка подключение к монгодб:', err));

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
if (!GEMINI_API_KEY) {
  throw new Error('GEMINI_API_KEY is required (set it in server/.env or environment)');
}
const ai = new GoogleGenAI({ apiKey: GEMINI_API_KEY });
const model = "gemini-2.5-flash";

const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  throw new Error('JWT_SECRET is required (set it in server/.env or environment)');
}

function createToken(user) {
  return jwt.sign(
    { sub: user._id.toString(), email: user.email },
    JWT_SECRET,
    { expiresIn: '30d' },
  );
}

function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization || '';
  const [type, token] = authHeader.split(' ');
  if (type !== 'Bearer' || !token) {
    return res.status(401).send({ message: 'Требуется авторизация' });
  }
  try {
    req.auth = jwt.verify(token, JWT_SECRET);
    return next();
  } catch (e) {
    return res.status(401).send({ message: 'Неверный токен' });
  }
}

function requireSelf(req, res, next) {
  if (!req.auth?.email) return res.status(401).send({ message: 'Требуется авторизация' });
  if (req.params.email && req.params.email !== req.auth.email) {
    return res.status(403).send({ message: 'Нет доступа' });
  }
  return next();
}

const UserSchema = new mongoose.Schema({
  fullName: String,
  email: { type: String, unique: true, required: true },
  dateOfBirth: String,
  age: Number,
  phoneNumber: String,
  password: { type: String, required: true },
  gender: String,
  bloodGroup: String,
  height: String,
  weight: String,
  avatarUrl: String,
  settings: {
    useMedicalDataInAI: { type: Boolean, default: true },
    storeChatHistory: { type: Boolean, default: true },
    shareAnalytics: { type: Boolean, default: false },
  },
  medicalCard: {
    personalInfo: {
      name: String,
      dateOfBirth: String,
      bloodType: String,
      height: String,
      weight: String,
    },
    chronicConditions: [String],
    allergies: [{ name: String, severity: String }],
    currentMedications: [{ name: String, dosage: String, frequency: String }],
    documents: [{ name: String, date: String }],
  },
});
const User = mongoose.model("User", UserSchema);

const SavedItemSchema = new mongoose.Schema({
  userEmail: { type: String, required: true, index: true },
  type: { type: String, required: true, enum: ["chat_message", "chat_summary", "note"] },
  title: { type: String, required: true },
  content: { type: String, required: true },
  chatId: { type: mongoose.Schema.Types.ObjectId, required: false },
  createdAt: { type: Date, default: Date.now },
});
const SavedItem = mongoose.model("SavedItem", SavedItemSchema);

const MessageSchema = new mongoose.Schema({
  sender: { type: String, required: true, enum: ["user", "bot"] },
  text: { type: String, required: true },
  timestamp: { type: Date, default: Date.now },
});

const ChatSchema = new mongoose.Schema({
  userEmail: { type: String, required: true, index: true },
  title: { type: String, default: "Новый чат" },
  messages: [MessageSchema],
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

ChatSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

const Chat = mongoose.model('Chat', ChatSchema);

function buildMedicalContext(user) {
  const useMedicalData = user?.settings?.useMedicalDataInAI !== false;
  if (!useMedicalData) return null;

  const card = user?.medicalCard;
  if (!card) return null;

  const lines = [];
  const p = card.personalInfo || {};
  const push = (k, v) => {
    if (v === undefined || v === null) return;
    const s = String(v).trim();
    if (!s) return;
    lines.push(`${k}: ${s}`);
  };

  push("Name", p.name);
  push("Date of Birth", p.dateOfBirth);
  push("Blood Type", p.bloodType);
  push("Height", p.height);
  push("Weight", p.weight);

  if (Array.isArray(card.chronicConditions) && card.chronicConditions.length) {
    lines.push(`Chronic Conditions: ${card.chronicConditions.join(", ")}`);
  }
  if (Array.isArray(card.allergies) && card.allergies.length) {
    lines.push(
      `Allergies: ${card.allergies
        .filter(a => a?.name)
        .map(a => `${a.name}${a.severity ? ` (${a.severity})` : ""}`)
        .join(", ")}`
    );
  }
  if (Array.isArray(card.currentMedications) && card.currentMedications.length) {
    lines.push(
      `Current Medications: ${card.currentMedications
        .filter(m => m?.name)
        .map(m => `${m.name}${m.dosage ? ` ${m.dosage}` : ""}${m.frequency ? ` • ${m.frequency}` : ""}`)
        .join(", ")}`
    );
  }

  if (!lines.length) return null;
  return `You are a medical assistant. Use the following patient profile as context when answering, but do not reveal it verbatim unless asked.\n\n${lines.join("\n")}`;
}

async function getGeminiResponse(history, { medicalContext } = {}) {
  const geminiHistory = history.map(msg => ({
    role: msg.sender === 'user' ? 'user' : 'model',
    parts: [{ text: msg.text }],
  }));

  try {
    if (geminiHistory.length === 0) return "Начните чат с сообщения.";
    const historyWithContext = medicalContext
      ? [{ role: 'user', parts: [{ text: medicalContext }] }, ...geminiHistory]
      : geminiHistory;
    const chat = ai.chats.create({ model, history: historyWithContext });
    const userMessageText = geminiHistory[geminiHistory.length - 1].parts[0].text;
    const response = await chat.sendMessage({ message: userMessageText });
    return response.text.trim();
  } catch (error) {
    console.error("Gemini API Error:", error);
    return "Извините, произошла ошибка при обращении к AI.";
  }
}

app.post('/register', async (req, res) => {
  try {
    const { fullName, email, dateOfBirth, age, phoneNumber, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({
      fullName,
      email,
      dateOfBirth,
      age,
      phoneNumber,
      password: hashedPassword,
    });

    await newUser.save();
    const userResponse = newUser.toObject();
    delete userResponse.password;
    const token = createToken(newUser);
    res.status(201).send({ message: 'Регистрация успешно', user: userResponse, token });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(409).send({ message: 'С таким email уже есть аккаунт' });
    }
    res.status(400).send({ message: 'ошибка при регистрации', error });
  }
});

app.post('/login', async (req, res) => {
  try {
    const user = await User.findOne({ email: req.body.email });
    if (!user || !(await bcrypt.compare(req.body.password, user.password))) {
      return res.status(400).send({ message: 'неверный логин или пароль' });
    }
    const userResponse = user.toObject();
    delete userResponse.password;
    const token = createToken(user);
    res.status(200).send({ message: 'вход выполнен', user: userResponse, token });
  } catch (error) {
    res.status(500).send({ message: 'ошибка на сервере', error });
  }
});

app.get('/users', requireAuth, async (req, res) => {
  try {
    const users = await User.find().select('-password');
    res.status(200).send(users);
  } catch (error) {
    res.status(500).send({ message: 'ошибка при получении пользоввателей', error });
  }
});

app.get('/user/:email', requireAuth, requireSelf, async (req, res) => {
  try {
    const user = await User.findOne({ email: req.params.email }).select('-password');
    if (!user) {
      return res.status(404).send({ message: 'пользователь не найден' });
    }
    res.status(200).send(user);
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при поиске пользователя', error });
  }
});

app.get('/user/settings', requireAuth, async (req, res) => {
  try {
    const user = await User.findOne({ email: req.auth.email }).select('settings');
    if (!user) return res.status(404).send({ message: 'Пользователь не найден' });
    res.status(200).send({ settings: user.settings || {} });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при получении настроек', error: error.message });
  }
});

app.put('/user/settings', requireAuth, async (req, res) => {
  try {
    const patch = {};
    if (typeof req.body.useMedicalDataInAI === 'boolean') patch['settings.useMedicalDataInAI'] = req.body.useMedicalDataInAI;
    if (typeof req.body.storeChatHistory === 'boolean') patch['settings.storeChatHistory'] = req.body.storeChatHistory;
    if (typeof req.body.shareAnalytics === 'boolean') patch['settings.shareAnalytics'] = req.body.shareAnalytics;

    const user = await User.findOneAndUpdate(
      { email: req.auth.email },
      { $set: patch },
      { new: true }
    ).select('settings');
    if (!user) return res.status(404).send({ message: 'Пользователь не найден' });
    res.status(200).send({ message: 'Настройки обновлены', settings: user.settings || {} });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при обновлении настроек', error: error.message });
  }
});

app.get('/user/medical-card', requireAuth, async (req, res) => {
  try {
    const user = await User.findOne({ email: req.auth.email }).select('medicalCard');
    if (!user) return res.status(404).send({ message: 'Пользователь не найден' });
    res.status(200).send({ medicalCard: user.medicalCard || {} });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при получении medical card', error: error.message });
  }
});

app.put('/user/medical-card', requireAuth, async (req, res) => {
  try {
    const medicalCard = req.body.medicalCard;
    if (!medicalCard || typeof medicalCard !== 'object') {
      return res.status(400).send({ message: 'medicalCard is required' });
    }
    const user = await User.findOneAndUpdate(
      { email: req.auth.email },
      { $set: { medicalCard } },
      { new: true }
    ).select('medicalCard');
    if (!user) return res.status(404).send({ message: 'Пользователь не найден' });
    res.status(200).send({ message: 'Medical card updated', medicalCard: user.medicalCard || {} });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при обновлении medical card', error: error.message });
  }
});

app.put('/user/:email', requireAuth, requireSelf, async (req, res) => {
  try {
    const { fullName, dateOfBirth, age, phoneNumber, bloodGroup, height, weight, gender } = req.body;
    const updatedUser = await User.findOneAndUpdate(
      { email: req.params.email },
      { fullName, dateOfBirth, age, phoneNumber, bloodGroup, height, weight, gender },
      { new: true }
    ).select('-password');
    if (!updatedUser) {
      return res.status(404).send({ message: 'Пользователь не найден' });
    }
    res.status(200).send({ message: 'Профиль успешно обновлен', user: updatedUser });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при обновлении профиля', error });
  }
});

app.get('/api/saved', requireAuth, async (req, res) => {
  try {
    const items = await SavedItem.find({ userEmail: req.auth.email })
      .sort({ createdAt: -1 })
      .select('_id type title content chatId createdAt');
    res.status(200).send(items);
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при получении сохраненных элементов', error: error.message });
  }
});

app.post('/api/saved', requireAuth, async (req, res) => {
  const { type, title, content, chatId } = req.body;
  if (!type || !title || !content) {
    return res.status(400).send({ message: 'type, title, content are required' });
  }
  try {
    const item = new SavedItem({
      userEmail: req.auth.email,
      type,
      title: String(title).slice(0, 120),
      content: String(content).slice(0, 20000),
      chatId: chatId || undefined,
    });
    await item.save();
    res.status(201).send({ message: 'Saved', item });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при сохранении', error: error.message });
  }
});

app.delete('/api/saved/:id', requireAuth, async (req, res) => {
  try {
    const item = await SavedItem.findById(req.params.id);
    if (!item) return res.status(404).send({ message: 'Не найдено' });
    if (item.userEmail !== req.auth.email) return res.status(403).send({ message: 'Нет доступа' });
    await SavedItem.findByIdAndDelete(req.params.id);
    res.status(200).send({ message: 'Deleted' });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при удалении', error: error.message });
  }
});

app.post('/upload-avatar/:email', requireAuth, requireSelf, upload.single('avatar'), async (req, res) => {
  try {
    const email = req.params.email;
    if (!req.file) {
      return res.status(400).send({ message: 'Файл не предоставлен' });
    }

    const avatarUrl = `/uploads/${req.file.filename}`;
    const updatedUser = await User.findOneAndUpdate(
      { email: email },
      { avatarUrl: avatarUrl },
      { new: true }
    ).select('-password');

    if (!updatedUser) {
      return res.status(404).send({ message: 'Пользователь не найден' });
    }

    res.status(200).send({
      message: 'Аватар успешно загружен',
      avatarUrl: avatarUrl
    });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при загрузке аватара', error: error.message });
  }
});

app.get('/api/chats/:userEmail', requireAuth, async (req, res) => {
  if (req.params.userEmail !== req.auth.email) {
    return res.status(403).send({ message: 'Нет доступа' });
  }
  try {
    const chats = await Chat.find({ userEmail: req.params.userEmail })
      .select('_id title updatedAt messages')
      .sort({ updatedAt: -1 });
    res.status(200).send(chats);
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при получении чатов', error: error.message });
  }
});

app.post('/api/chats', requireAuth, async (req, res) => {
  const { userEmail, messageText } = req.body;
  if (!userEmail || !messageText) {
    return res.status(400).send({ message: 'Требуется email пользователя и текст сообщения' });
  }
  if (userEmail !== req.auth.email) {
    return res.status(403).send({ message: 'Нет доступа' });
  }
  try {
    const user = await User.findOne({ email: req.auth.email }).select('settings medicalCard');
    const userMessage = { sender: "user", text: messageText };
    const medicalContext = buildMedicalContext(user);
    const botResponseText = await getGeminiResponse([userMessage], { medicalContext });
    const botMessage = { sender: "bot", text: botResponseText };
    const newChat = new Chat({
      userEmail,
      title: messageText.substring(0, 50),
      messages: [userMessage, botMessage],
    });
    await newChat.save();
    res.status(201).send({ message: "Новый чат создан", chat: newChat });
  } catch (error) {
    res.status(500).send({ message: "Ошибка при создании чата", error: error.message });
  }
});

app.post('/api/chats/:chatId/messages', requireAuth, async (req, res) => {
  const { messageText } = req.body;
  const chatId = req.params.chatId;
  if (!messageText) {
    return res.status(400).send({ message: 'Требуется текст сообщения' });
  }
  try {
    const user = await User.findOne({ email: req.auth.email }).select('settings medicalCard');
    const chat = await Chat.findById(chatId);
    if (!chat) {
      return res.status(404).send({ message: 'Чат не найден' });
    }
    if (chat.userEmail !== req.auth.email) {
      return res.status(403).send({ message: 'Нет доступа' });
    }
    const userMessage = { sender: 'user', text: messageText };
    chat.messages.push(userMessage);
    const historyForGemini = chat.messages.map(msg => ({
      sender: msg.sender,
      text: msg.text,
    }));
    const medicalContext = buildMedicalContext(user);
    const botResponseText = await getGeminiResponse(historyForGemini, { medicalContext });
    const botMessage = { sender: 'bot', text: botResponseText };
    chat.messages.push(botMessage);
    chat.updatedAt = Date.now();
    await chat.save();
    res.status(200).send({ message: 'Чат обновлен', chat });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при отправке сообщения', error: error.message });
  }
});

app.delete('/api/chats/:chatId', requireAuth, async (req, res) => {
  try {
    const chat = await Chat.findById(req.params.chatId);
    if (!chat) {
      return res.status(404).send({ message: 'Чат не найден' });
    }
    if (chat.userEmail !== req.auth.email) {
      return res.status(403).send({ message: 'Нет доступа' });
    }
    const result = await Chat.findByIdAndDelete(req.params.chatId);
    if (!result) {
      return res.status(404).send({ message: 'Чат не найден' });
    }
    res.status(200).send({ message: 'Чат успешно удален' });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при удалении чата', error: error.message });
  }
});

app.post('/user/change-password', requireAuth, async (req, res) => {
  const { oldPassword, newPassword } = req.body;
  if (!oldPassword || !newPassword) {
    return res.status(400).send({ message: 'Требуется старый и новый пароль' });
  }
  try {
    const user = await User.findOne({ email: req.auth.email });
    if (!user) return res.status(404).send({ message: 'Пользователь не найден' });
    const ok = await bcrypt.compare(oldPassword, user.password);
    if (!ok) return res.status(400).send({ message: 'Неверный старый пароль' });
    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();
    return res.status(200).send({ message: 'Пароль обновлен' });
  } catch (error) {
    return res.status(500).send({ message: 'Ошибка при смене пароля', error: error.message });
  }
});

app.delete('/user/me', requireAuth, async (req, res) => {
  try {
    const email = req.auth.email;
    await Chat.deleteMany({ userEmail: email });
    await SavedItem.deleteMany({ userEmail: email });
    await User.deleteOne({ email });

    const safe = email.replace(/[^a-zA-Z0-9]/g, '_');
    const files = fs.readdirSync(UPLOADS_DIR);
    for (const f of files) {
      if (f.startsWith(safe)) {
        try {
          fs.unlinkSync(path.join(UPLOADS_DIR, f));
        } catch (_) {}
      }
    }

    res.status(200).send({ message: 'Account deleted' });
  } catch (error) {
    res.status(500).send({ message: 'Ошибка при удалении аккаунта', error: error.message });
  }
});

const PORT = Number(process.env.PORT) || 3001;
app.listen(PORT, () => {
  console.log(`сервер запущен и работает на порту ${PORT}`);
});
