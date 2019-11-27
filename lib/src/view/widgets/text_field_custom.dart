import 'package:flutter/material.dart';
import 'package:lab_archive/utils/size_config.dart';

class TextFieldCustom extends StatelessWidget {
  final String hintText;
  final Function(String) validator;
  final Function(String) onSave;
  final Function(String) onSubmit;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;

  TextFieldCustom(
      {@required this.hintText,
      this.validator,
      this.onSave,
      this.onSubmit,
      this.focusNode,
      this.textInputAction,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      t});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 5.10 * SizeConfig.textMultiplier),
      cursorColor: Color(0xFF299DAD),
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Colors.white,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 5.10 * SizeConfig.textMultiplier,
            color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 6.37 * SizeConfig.widthMultiplier,
            vertical: 1.68 * SizeConfig.heigthMultiplier),
      ),
      validator: validator,
      onSaved: onSave,
      onFieldSubmitted: onSubmit,
    );
  }
}
