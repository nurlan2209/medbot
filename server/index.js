const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const { GoogleGenAi } = require('@google/genei');

const app = express();
app.use(cors());
app.use(express.json());

const mongouri = 'mongodb+srv://nurlank1234554321'

mongoose.connect(mongouri)
    .then(() => console.log('mongodb подключен успешно'))
    .catch((err) => console.error('ошибка подключение к монгодб:', err));

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
const ai = new GoogleGenAI({ apiKey: GEMINI_API_KEY });
const model = "gemini-2.5-flash";

const UserSchema = new mongoose.Schema({
    fullName: String,
    email: { type: String, unique: true, required: true },
    dateOfBirth: String,
    phoneNumber: String,
    password: { type: String, required: true },
    gender: String,
    bloodGroup: String,
    height: String,
    weight: String,
});
const User = mongoose.model("User", UserSchema);

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

async function getGeminiResponse(history) {
    const geminiHistory = history.map(msg => ({
        role: msg.sender === 'user' ? 'user' : 'model',
        parts: [{ text: msg.text }],
    }));

    try {
        const chat = ai.chats.create({ model, history: geminiHistory });
        const response = await chat.sendMessage({
            message: geminiHistory[geminiHistory.length - 1].parts[0].text // Отправляем последнее сообщение пользователя
        });
        return response.text.trim();
    } catch (error) {
        console.error("Gemini API Error:", error);
        return "Извините, произошла ошибка при обращении к AI.";
    }
}

app.post('/register', async (req, res) => {
    try {
        const { fullName, email, dateOfBirth, phoneNumber, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10)
        const newUser = new User({
            fullName,
            email,
            dateOfBirth,
            phoneNumber,
            password: hashedPassword,
        });

        await newUser.save();
        const userResponse = newUser.toObject();
        delete userResponse.password;
        res.status(201).send({ message: 'Регистрация успешно', user: newUser });
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
        res.status(200).send({ message: 'вход выполнен', user: user });
    } catch (error) {
        res.status(500).send({ message: 'ошибка на сервере', error });
    }
});

app.get('/users', async (req, res) => {
    try {
        const users = await User.find().select('-password');
        res.status(200).send(users);
    } catch (error) {
        res.status(500).send({ message: 'ошибка при получении пользоввателей', error });
    }
});

app.get('/user/:email', async (req, res) => {
    try {
        const user = await User.findOne({ email: req.params.email });
        if (!user) {
            return res.status(404).send({ message: 'пользователь не найден' });
        }
        res.status(200).send(user);
    } catch (error) {
        res.status(500).send({ message: 'Ошибка при поиске пользователя', error });
    }
});

app.put('/user/:email', async (req, res) => {
    try {
        const { fullName, dateOfBirth, phoneNumber, bloodGroup, height, weight, gender } = req.body;
        const updatedUser = await User.findOneAndUpdate(
            { email: req.params.email },
            { fullName, dateOfBirth, phoneNumber, bloodGroup, height, weight, gender },
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

app.get('/api/chats/:userEmail', async (req, res) => {
    try {
        const chats = await Chat.find({ userEmail: req.params.userEmail })
            .select('_id title updatedAt messages')
            .sort({ updatedAt: -1 });
        res.status(200).send(chats);
    } catch (error) {
        res.status(500).send({ message: 'Ошибка при получении чатов', error: error.message });
    }
});

app.post('/api/chats', async (req, res) => {
    const { userEmail, messageText } = req.body;

    if (!userEmail || !messageText) {
        return res.status(400).send({ message: 'Требуется email пользователя и текст сообщения' });
    }

    try {
        const userMessage = { sender: "user", text: messageText };

        const botResponseText = await getGeminiResponse([userMessage]);
        const botMessage = { sender: "bot", text: botResponseText };

        const newChat = new Chat({
            userEmail,
            title: messageText.substring(0, 50),
            messages: [userMessage, botMessage],
        });

        await newChat.save();
        res.status(201).send({ message: "Новый чат создан", chat: newChat });
    } catch (error) {
        res
            .status(500)
            .send({ message: "Ошибка при создании чата", error: error.message });
    }
});

app.post('/api/chats/:chatId/messages', async (req, res) => {
    const { messageText } = req.body;
    const chatId = req.params.chatId;

    if (!messageText) {
        return res.status(400).send({ message: 'Требуется текст сообщения' });
    }
    try {
        const chat = await Chat.findById(chatId);
        if (!chat) {
            return res.status(404).send({ message: 'Чат не найден' });
        }

        const userMessage = { sender: 'user', text: messageText };
        chat.messages.push(userMessage);

        const historyForGemini = chat.messages.map(msg => ({
            sender: msg.sender,
            text: msg.text,
        }));
        
        const botResponseText = await getGeminiResponse(historyForGemini);
        const botMessage = { sender: 'bot', text: botResponseText };

        chat.messages.push(botMessage);
        chat.updatedAt = Date.now();
        await chat.save();

        res.status(200).send({ message: 'Чат обновлен', chat });
    } catch (error) {
        res.status(500).send({ message: 'Ошибка при отправке сообщения', error: error.message });
    }
});

const PORT = 3001;
app.listen(PORT, () => {
    console.log(`сервер запущен и работает на порту ${PORT}`);
});