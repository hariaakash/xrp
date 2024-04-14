const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

// Dummy data - stocks and user portfolios
let stocks = [
    { id: 1, name: "AAPL", price: 150.50 },
    { id: 2, name: "GOOGL", price: 2700.30 },
    { id: 3, name: "MSFT", price: 300.20 }
];

let portfolios = {
    user1: [
        { id: 1, stockId: 1, quantity: 10 },
        { id: 2, stockId: 3, quantity: 5 }
    ],
    user2: [
        { id: 3, stockId: 2, quantity: 8 }
    ]
};

app.use(bodyParser.json());

// API to list all available stocks
app.get('/list', (req, res) => {
    res.json(stocks);
});

// API to get portfolio of a user
app.get('/getPortfolio/:user', (req, res) => {
    const user = req.params.user;
    if (portfolios[user]) {
        const userPortfolio = portfolios[user].map(item => {
            const stock = stocks.find(s => s.id === item.stockId);
            return { ...stock, quantity: item.quantity };
        });
        res.json(userPortfolio);
    } else {
        res.status(404).json({ message: "User portfolio not found" });
    }
});

// API to buy stocks
app.post('/buy', (req, res) => {
    const { user, stockId, quantity } = req.body;
    const stock = stocks.find(s => s.id === parseInt(stockId));
    if (!stock) {
        return res.status(404).json({ message: "Stock not found" });
    }
    if (!portfolios[user]) {
        portfolios[user] = [];
    }
    portfolios[user].push({ id: portfolios[user].length + 1, stockId: parseInt(stockId), quantity });
    res.json({ message: "Stock bought successfully" });
});

// API to sell stocks
app.post('/sell', (req, res) => {
    const { user, stockId, quantity } = req.body;
    const stockIndex = portfolios[user].findIndex(item => item.stockId === parseInt(stockId));
    if (stockIndex === -1) {
        return res.status(404).json({ message: "Stock not found in user's portfolio" });
    }
    const userStock = portfolios[user][stockIndex];
    if (userStock.quantity < quantity) {
        return res.status(400).json({ message: "Insufficient quantity to sell" });
    }
    if (userStock.quantity === quantity) {
        portfolios[user].splice(stockIndex, 1);
    } else {
        userStock.quantity -= quantity;
    }
    res.json({ message: "Stock sold successfully" });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
