var express = require('express'),
    app = express(),
    http = require('http').createServer(app),
    // io = require('socket.io')(http),
    WebSocketServer = require("ws"),
    wss = new WebSocketServer.Server({ port: 3000 });
    http.listen(3003);

app.get('/', (req,res) => res.json("123"));
// io.on('connection', (socket) => {
//     console.log("CONN Flutter");
//     socket.emit('open', "NODEJS - OPEN");
// });

wss.on('connection', (ws) => {
    console.log("WS CONNECT ?!");
    ws.on('message', (message) => {
        console.log('received: %s', message);
    });
    ws.on('ms', (message) => {
        console.log('received222: %s', message);
    });
    ws.emit('ms', "ASDASDASD");
    ws.emit('event', "ASDASDASD");

    ws.send('something');
});
wss.emit('event', "ASDASDASD");

