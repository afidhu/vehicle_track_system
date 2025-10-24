import type { Server, Socket } from "socket.io";
import { addLocation } from "../controller/locationController.ts";



export const socketHandlers=(io:Server, socket:Socket)=> {
  console.log("User connected:", socket.id);
  socket.emit("me", socket.id);

  // socket.on("join_room", (room: any) => {
  //   socket.join(room.group.toString());
  // });

  socket.on("send_location", async (data: any) => {
    console.log('received_location:',data)
    const addedData =await addLocation(data)
    io.emit('received_location', addedData)
    console.log('reseived data are :', addedData)
  });

  socket.on('get_deviceLocation',(data)=>{
    console.log('deviceLocation:',data);
    io.emit('send_deviceLocation',data)
  })



  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });
}

