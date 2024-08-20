import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hero_chat/consts.dart';
import 'package:hero_chat/models/user_profile.dart';
import 'package:hero_chat/services/alert_service.dart';
import 'package:hero_chat/services/auth_service.dart';
import 'package:hero_chat/services/database_service.dart';
import 'package:hero_chat/services/media_service.dart';
import 'package:hero_chat/services/navigation_service.dart';
import 'package:hero_chat/services/storage_service.dart';
import 'package:hero_chat/widgets/custom_form_field.dart';

class HeroRegister extends StatefulWidget {
  const HeroRegister({super.key});

  @override
  State<HeroRegister> createState() => _HeroRegisterState();
}

class _HeroRegisterState extends State<HeroRegister> {
  File? selectedImage;
  Color myColor = Color(0xFF023047);
  bool _isChecked = false;
  String? name, email, password;
  bool isLoading = false;
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late AuthService _authService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myColor,
      body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('images/marvel.jpg',fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(!isLoading) _image(),
                SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 75),
                    if(!isLoading) _welcome(),
                    const SizedBox(height: 4),
                    if(!isLoading) _registerForm(),
                    const SizedBox(height: 90),
                    if(!isLoading) _loginAccountLink(),
                    if(isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                  ],
                ),
              ],
            ),
          ]
      ),
    );
  }

  Widget _image(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.transparent,
            width: 0.1
        ),
        color: Colors.black,
      ),
      height: 650,
      width: 185,
      child: Image(
        image: AssetImage('images/deadpool2.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _welcome(){
    return Padding(
      padding: const EdgeInsets.only(left: 3,top:10,bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: 1
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.yellow.shade500,
        ),
        margin: EdgeInsets.only(left: 10),
        height: 90,
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,top: 5),
              child: Text("WELCOME!",style: GoogleFonts.exo(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3,left: 78),
              child: Text(
                "CREATE AN",
                style: GoogleFonts.exo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 90),
              child: Text(
                "ACCOUNT",
                style: GoogleFonts.exo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 10),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 350,
              width: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        hintText: "John Doe",
                        label: "Name",
                        validationRegEx: NAME_VALIDATION_REGEX,
                        onSaved: (value){
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomFormField(
                      hintText: "example@gmail.com",
                      label: "Email",
                      validationRegEx: EMAIL_VALIDATION_REGEX,
                      onSaved: (value){
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomFormField(
                      obscureText: true,
                      hintText: "************",
                      label: "Password",
                      validationRegEx: PASSWORD_VALIDATION_REGEX,
                      onSaved: (value){
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  Center(child: _pfpSelectionField()),
                  Spacer(),
                  Center(
                    child: CheckboxListTile(
                      visualDensity: VisualDensity.compact,
                      checkColor: Colors.white,
                      dense: true,
                      activeColor: Colors.black,
                      title: const Text(
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
            _registerButton(),
          ],
        ),
      ),
    );
  }


  Widget _registerButton(){
    return Padding(
      padding: const EdgeInsets.only(left: 3,bottom: 10),
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
              onPressed: ()async {
                setState(() {
                  isLoading = true;
                });
                try{
                  if((_registerFormKey.currentState?.validate() ?? false) && selectedImage != null ){
                    _registerFormKey.currentState?.save();
                    bool result = await _authService.signup(email!, password!);
                    if(result){
                      String? pfpURL = await _storageService.uploadUserPfp(file: selectedImage!, uid: _authService.user!.uid);
                      if(pfpURL!=null){
                        await _databaseService.createUserProfile(userProfile: UserProfile(uid: _authService.user!.uid, name: name, pfpURL: pfpURL));
                        _alertService.showToast(
                          text: "User registered Successfully!",
                          icon: Icons.check,
                        );
                        _navigationService.goBack();
                        _navigationService.pushReplacementNamed('/home');
                      }
                      else{
                        throw Exception("Unable to upload user profile picture");
                      }
                    }
                    else{
                      throw Exception("Unable to register user");
                    }
                  }
                }catch(e){
                  print(e);
                  _alertService.showToast(
                    text: "Failed to register,Please try again!",
                    icon: Icons.error,
                  );
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: Text(
                "SIGN UP",
                style: GoogleFonts.exo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _pfpSelectionField(){
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if(file!=null){
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: 45,
        backgroundImage: selectedImage != null ? FileImage(selectedImage!) : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Already an Avenger?",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                _navigationService.goBack();
              },
              child: const Text(
                'Login',
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




