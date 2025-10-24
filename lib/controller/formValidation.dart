
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../location/mapview.dart';

class MyFormValidateController extends GetxController{

  TextEditingController controllerLatitude = TextEditingController();
  TextEditingController controllerLongitude  = TextEditingController();
  TextEditingController controllerPlace  = TextEditingController();

  final formkey =GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    connectionToSocket();
  }

  var socketId = ''.obs;
  IO.Socket? socket;

  void connectionToSocket(){
    socket  = IO.io('http://192.168.1.133:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();
    socket?.onConnect((_){
      print('ok fine connected');
      socket!.on('me', (data){
        socketId.value=data;
        print('users : $data');
      });
    });

  }


  String? ValidatePlace(String val){

    if(val.length <=2){
      return 'place is too short';
    }
    return null;
  }  String? ValidateLatitude(String val){

    if(val.length <=6){
      return 'longitude is too short';
    }
    return null;
  }

  String? ValidateLongitude(String val){
    if(val.length <=6){
      return 'longitude is too short';
    }
    return null;
  }


  void handleValidateForm(){
    final isValid =formkey.currentState!.validate();
    if(!isValid){
      print('form is not valid');
      return ;
    }
    else{
      formkey.currentState!.save();
      sendData();
        print('form is valid');
    }
  }


  void sendData(){
    var payload = {
      'place': controllerPlace.text,
      'latitude': controllerLatitude.text,
      'longitude': controllerLongitude.text
    };
    socket!.emit('send_location',payload);

    print('data sent');
    recievedData();
  }

  void recievedData(){
    socket!.on('received_location', (data) {
      print("data from server are $data");
      if(data['latitude'] != null && data['longitude'] != null){
        Get.to(()=>MapViewLocations(), fullscreenDialog: true, transition: Transition.downToUp,arguments:data);
      }
      else{
        print('dataNotGetFromServer');
      }
    });

  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    controllerLatitude.dispose();
    controllerLongitude.dispose();
  }

}