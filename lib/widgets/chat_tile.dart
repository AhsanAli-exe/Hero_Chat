import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hero_chat/models/user_profile.dart';
class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;

  const ChatTile({super.key,required this.userProfile,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 15,left: 10,bottom: 15),
      onTap:() {
        onTap();
      },
      dense: false,
      title: Text(
          userProfile.name!,
        style: GoogleFonts.bonaNova(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      leading: CircleAvatar(
        radius: 30,
       backgroundImage: NetworkImage(
         userProfile.pfpURL!
       ),
      ),
    );
  }
}
