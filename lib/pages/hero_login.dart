import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hero_chat/consts.dart';
import 'package:hero_chat/widgets/custom_form_field.dart';

import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

class HeroLogin extends StatefulWidget {
  const HeroLogin({super.key});

  @override
  State<HeroLogin> createState() => _HeroLoginState();
}

class _HeroLoginState extends State<HeroLogin> {
  Color myColor = Color(0xFF023047);
  bool _isChecked = false;
  final GetIt _getIt = GetIt.instance;
  String? email, password;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myColor,
      body: Stack(fit: StackFit.expand, children: [
        Image.asset('images/marvel.jpg', fit: BoxFit.cover),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 75),
                _welcome(),
                const SizedBox(height: 4),
                _loginForm(),
                const SizedBox(height: 2),
                const Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Text("Or login with social accounts",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                const SizedBox(height: 4),
                _socialAccounts(),
                const SizedBox(
                  height: 30,
                ),
                _createAccountLink()
              ],
            ),
            SizedBox(width: 4),
            _image()
          ],
        ),
      ]),
    );
  }

  Widget _image() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(15),
        color: Colors.lightBlue,
      ),
      height: 650,
      width: 185,
      child: const Image(
        image: AssetImage('images/wolverine.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _welcome() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(left: 10),
        height: 90,
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                "Welcome!",
                style: GoogleFonts.exo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3, left: 40),
              child: Text(
                "LOG INTO YOUR",
                style: GoogleFonts.exo(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 85),
              child: Text(
                "ACCOUNT",
                style: GoogleFonts.exo(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 10),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 350,
              width: 170,
              decoration: BoxDecoration(
                color: Colors.yellow.shade500,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        hintText: "example@gmail.com",
                        label: "Email",
                        obscureText: false,
                        validationRegEx: EMAIL_VALIDATION_REGEX,
                        onSaved: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomFormField(
                      label: "Password",
                      hintText: "************",
                      validationRegEx: PASSWORD_VALIDATION_REGEX,
                      obscureText: true,
                      onSaved: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: CheckboxListTile(
                      visualDensity: VisualDensity.compact,
                      checkColor: Colors.white,
                      dense: true,
                      activeColor: Colors.black,
                      title: Text(
                        "Remember Me",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w100),
                      ),
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 10),
      child: Container(
        margin: EdgeInsets.only(left: 10),
        width: 170,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                if (_loginFormKey.currentState?.validate() ?? false) {
                  _loginFormKey.currentState?.save();
                  bool result = await _authService.login(email!, password!);
                  if (result) {
                    _navigationService.pushReplacementNamed('/home');
                  } else {
                    _alertService.showToast(
                      text: "Failed to login, Please try again!",
                      icon: Icons.error,
                    );
                  }
                }
              },
              child: Text(
                "LOG IN",
                style: GoogleFonts.exo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialAccounts() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(left: 10),
              width: 85,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: const Border(
                      left: BorderSide(
                        color: Colors.white,
                        width: 0.3,
                      ),
                      right: BorderSide(
                        color: Colors.white,
                        width: 0.3,
                      ),
                      top: BorderSide(color: Colors.white, width: 0.3),
                      bottom: BorderSide(color: Colors.white, width: 0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      'images/google-symbol.png',
                    ),
                    height: 30,
                  ),
                  Text(
                    "Google",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            width: 85,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: const Border(
                    left: BorderSide(color: Colors.white, width: 0.3),
                    right: BorderSide(
                      color: Colors.white,
                      width: 0.3,
                    ),
                    top: BorderSide(
                      color: Colors.white,
                      width: 0.3,
                    ),
                    bottom: BorderSide(color: Colors.white, width: 0.3))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/facebook.png'),
                    radius: 18,
                  ),
                ),
                Text(
                  "Facebook",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLink() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Not an Avenger?",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                _navigationService.pushNamed('/register');
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
