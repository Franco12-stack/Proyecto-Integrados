require('dotenv').config();
const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const apiRoutes = require('./routes/api');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => res.send('Armador App backend OK'));

app.use('/auth', authRoutes);
app.use('/api', apiRoutes);

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Armador App backend escuchando en :${port}`));
