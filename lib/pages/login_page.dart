import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:totodo/models/auth_model.dart';
import 'package:totodo/pages/home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String? verificationId;
  String? otpCode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 7.0,
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text('Login', style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value){
                  setState(() {
                    _phoneNumberController.text = value;
                  });
                },
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: 'Phone Number',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                              bottomSheetHeight: 550,
                            ),
                            onSelect: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: _phoneNumberController.text.length == 10
                      ? Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        elevation: 4.0,
                        backgroundColor: Colors.blue[700],
                      ),
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          AuthService.sentOtp(
                            phonecode: selectedCountry.phoneCode,
                            phone: _phoneNumberController.text,
                            errorStep: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
                            Text("Error in sending OTP",style:
                            TextStyle(color: Colors.white),),
                              backgroundColor: Colors.red,)),
                            nextStep: (){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("OTP Verification"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Enter 6 digit OTP"),
                                      const SizedBox(height: 12),
                                      Form(
                                        key: _formKey1,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _otpController,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                            labelText: "OTP",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(32),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length != 6) {
                                              return "Invalid OTP";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (_formKey1.currentState!.validate()) {
                                          AuthService.loginWithOtp(otp: _otpController.text)
                                              .then((value) async {
                                            if (value == "Success") {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => homepage(),
                                                ),
                                              );
                                            }
                                            else {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    value,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                      child: const Text("Submit"),
                                    ),
                                  ],
                                ),
                              );
                            },);
                        }
                      },
                      child: const Text("Get OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Colors.white,
                        ),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
