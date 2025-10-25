import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/formValidation.dart';
import '../location/devicelocation.dart';
import '../utils/reuseColors.dart';

class RegisterLocation extends StatefulWidget {
  const RegisterLocation({super.key});

  @override
  State<RegisterLocation> createState() => _RegisterLocationState();
}

class _RegisterLocationState extends State<RegisterLocation> {
  MyFormValidateController myFormValidateController =
  Get.put(MyFormValidateController());

  // DeviceLocationController deviceLocationController = Get.put(DeviceLocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.bodyColor,
      appBar: AppBar(
        title: const Text(
          'Register Location!!',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: AllColors.appBarColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
        elevation: 6,
        shadowColor: Colors.black45,
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: Get.height*0.07),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📍 Please fill all fields',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // ===== Form =====
              Form(
                key: myFormValidateController.formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller:
                      myFormValidateController.controllerPlace,
                      keyboardType: TextInputType.multiline,
                      validator: (val) {
                        return myFormValidateController.ValidatePlace(val!);
                      },
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.place_outlined, color: Colors.blue),
                        labelText: 'Place',
                        hintText: 'Enter your Place',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: AllColors.appBarColor, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    TextFormField(
                      controller:
                      myFormValidateController.controllerLatitude,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return myFormValidateController.ValidateLatitude(val!);
                      },
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.location_on, color: Colors.blue),
                        labelText: 'Latitude',
                        hintText: 'Enter your latitude',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: AllColors.appBarColor, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.04),

                    TextFormField(
                      controller:
                      myFormValidateController.controllerLongitude,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return myFormValidateController.ValidateLongitude(val!);
                      },
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.map, color: Colors.green),
                        labelText: 'Longitude',
                        hintText: 'Enter your longitude',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: AllColors.appBarColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height * 0.04),

              // ===== Submit Button =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: myFormValidateController.handleValidateForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllColors.appBarColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black26,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
