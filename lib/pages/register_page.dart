import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hero_chat/consts.dart';
import 'package:hero_chat/models/user_profile.dart';
import 'package:hero_chat/services/alert_service.dart';
import 'package:hero_chat/services/auth_service.dart';
import 'package:hero_chat/services/database_service.dart';
import 'package:hero_chat/services/media_service.dart';
import 'package:hero_chat/services/navigation_service.dart';
import 'package:hero_chat/services/storage_service.dart';
import 'package:hero_chat/widgets/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? name, email, password;

  File? selectedImage;
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
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20.0
        ),
        child: Column(
          children: [
            _headerText(),
            if(!isLoading) _registerForm(),
            if(!isLoading) _loginAccountLink(),
            if(isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery
          .sizeOf(context)
          .width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lets, get going!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Register as an avenger and save the world",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _registerForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height*0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
              hintText: "John Doe",
              label: "Name",
              validationRegEx: NAME_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              hintText: "example@gmail.com",
              label: "Email",
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
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
            _registerButton()
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
        radius: MediaQuery.sizeOf(context).width*0.15,
        backgroundImage: selectedImage != null ? FileImage(selectedImage!) : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
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
        child: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

      ),
    );
  }

  Widget _loginAccountLink(){
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Already an Avenger?"),
          GestureDetector(
            onTap: (){
              _navigationService.goBack();
            },
            child: const Text(
              'Go Back',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
  }

}