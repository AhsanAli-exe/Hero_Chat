import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final String label;
  final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;
  const CustomFormField({super.key,required this.hintText,required this.label,required this.validationRegEx,required this.onSaved,this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved : onSaved,
      obscureText: obscureText,
      validator: (value){
        if (value!=null && validationRegEx.hasMatch(value)){
          return null;
        }
        return "Enter a valid ${hintText.toLowerCase()}";
      },
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
          labelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13
          ),
        hintText: hintText,
        contentPadding: const  EdgeInsets.only(left: 2),
      )

    );
  }
}
