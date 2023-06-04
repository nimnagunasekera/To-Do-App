import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:todo/service/auth_service.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Sign Up",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 24),
        ),
        centerTitle: true,
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              textField(),
              const SizedBox(
                height: 30,
              ),
              // ignore: sized_box_for_whitespace
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    Text(
                      "Enter 6 digit code",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              otpField(),
              const SizedBox(
                height: 40,
              ),
              RichText(
                  text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Resend code in ",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 153, 153, 0)),
                  ),
                  TextSpan(
                    text: "00:$start",
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 192, 49, 97)),
                  ),
                  const TextSpan(
                    text: " sec",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 153, 153, 0)),
                  ),
                ],
              )),
              const SizedBox(
                height: 150,
              ),
              InkWell(
                onTap: () {
                  authClass.signInwithPhoneNumber(
                      verificationIdFinal, smsCode, context);
                },
                child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 149, 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        "Verify & Proceed",
                        style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 75, 55, 13),
                            fontWeight: FontWeight.w700),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 50,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: const Color.fromARGB(255, 143, 143, 143),
        borderColor: Theme.of(context).colorScheme.secondary,
        focusBorderColor: Theme.of(context).colorScheme.secondary,
      ),
      style: TextStyle(
          fontSize: 17, color: Theme.of(context).colorScheme.secondary),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        // ignore: avoid_print
        print("Completed: $pin");
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 143, 143, 143),
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: phoneController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary, fontSize: 17),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your phone number",
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 17),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
            child: Text(
              " (+94) ",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 17),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait
                ? null
                : () async {
                    setState(() {
                      start = 30;
                      wait = true;
                      buttonName = "Resend";
                    });
                    await authClass.verifyPhoneNumber(
                        "+94${phoneController.text}", context, setData);
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                buttonName,
                style: TextStyle(
                    color: wait
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setData(verificationID) {
    setState(() {
      verificationIdFinal = verificationID;
    });
    startTimer();
  }
}
