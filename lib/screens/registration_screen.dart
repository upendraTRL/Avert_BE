// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/provider/auth_provider.dart';
import 'package:test_1/widgets/custome_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );

    //Phone number length verification
    Container phoneLength = Container(
      height: 30,
      width: 30,
      margin: const EdgeInsets.all(10.0),
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      child: const Icon(
        Icons.done,
        color: Colors.white,
        size: 20,
      ),
    );

    //Phone input field decoration
    InputDecoration phoneDecoration = InputDecoration(
      hintText: 'Enter phone number',
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      prefixIcon: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: const Text(
          '+91',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      suffixIcon: phoneController.text.length > 9 ? phoneLength : null,
    );

    //Send phone number for OTP
    void sendPhoneNumber() {
      // print("Calledddddddddddddddd");
      final ap = Provider.of<AuthProvider>(context, listen: false);
      String phoneNumber = phoneController.text.trim();
      // MongoDatabase(enteredPhone: phoneNumber);
      ap.signInWithPhone(context, "+91$phoneNumber");
    }

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade50,
                ),
                child: Image.asset('assets/image2.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Register',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter phone number for verification',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: Colors.purple,
                controller: phoneController,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  setState(() {
                    phoneController.text = value;
                  });
                },
                decoration: phoneDecoration,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                    text: 'Send OTP',
                    onPressed: () async {
                      sendPhoneNumber();
                    }),
              )
            ],
          ),
        ),
      )),
    );
  }
}
