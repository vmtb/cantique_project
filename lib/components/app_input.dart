import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final ValidationBuilder validationBuilder;
  final double height;
  final TextInputType inputType;
  final TextAlign textAlign;
  final bool isObscure;
  final bool isEnable;
  final IconData suffixIcon;
  final String prefixIndicatif ;
  final String initialValue ;
  final int minLength;
  final int minLines;
  final int maxlength;

  const AppInput({
    Key? key,
    this.label = "",
    required this.controller,
    required this.validationBuilder,
    this.height = 55,
    this.inputType = TextInputType.text,
    this.isObscure = false,
    this.suffixIcon = Icons.edit,
    this.prefixIndicatif="",
    this.isEnable = true,
    this.minLength = 1,
    this.minLines = 1,
    this.maxlength = 200,
    this.initialValue="",
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        decoration: InputDecoration(
          enabled: isEnable,
          labelText: label,
          prefixText: prefixIndicatif,
          /*floatingLabelBehavior: FloatingLabelBehavior.never,*/
          suffixIcon: Icon(suffixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        obscureText: isObscure,
        keyboardType: inputType,
        controller: controller,
        minLines: minLines,
        maxLines: 50,
        validator: validationBuilder.build(),
        textAlign: textAlign,
        style:   GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }
}
