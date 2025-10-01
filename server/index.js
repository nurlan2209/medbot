const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const { use } = require('react');

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect('mongodb://localhost:27017/medbot_db')
    .then(() => console.log('mongodb подключен успешно'))
    .catch((err) => console.error('ошибка подключение к монгодб:', err));

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

const User = mongoose.model('User', UserSchema);

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

        res.status(200).send({ message: 'вход выполнен', user: user });
    } catch (error) {
        res.status(500).send({ message: 'ошибка на сервере', error });
    }
});

app.get('/users', async (req, res) => {
    try {
        const users = await User.find();
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
        );
        if (!updatedUser) {
            return res.status(404).send({ message: 'Пользователь не найден' });
        }
        res.status(200).send({ message: 'Профиль успешно обновлен', user: updatedUser });
    } catch (error) {
        res.status(500).send({ message: 'Ошибка при обновлении профиля', error });
    }
});

const PORT = 3001;
app.listen(PORT, () => {
    console.log(`сервер запущен и работает на порту ${PORT}`);
});