// src/index.ts
import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import 'dotenv/config';
import { socketHandlers } from './socketIo/socketIoController.ts';
import { PrismaClient } from '../generated/prisma/client.ts';



const PORT = process.env.PORT || 3000;

const app = express();
const server = createServer(app);



const io = new Server(server, {
    cors: {
        origin: "*", 
        methods: ["GET", "POST"]
    }
});
app.use(express.json())

export const prisma =new PrismaClient();


io.on("connection", (socket) => {
  socketHandlers(io, socket);
});


server.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});