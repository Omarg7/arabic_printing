import 'package:flutter/material.dart';


class CustomFormField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool obscureText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final Function(String?)? onChanged;
  final String title;
  final TextInputAction? textInputAction;
  final bool? autoFocus;
  final Function()? onEditComplete;
  final double? contentPadding;

  const CustomFormField({
    Key? key,
    this.maxLines = 1,
    this.contentPadding = 0,
     this.suffixIcon,
    required this.hintText,
    this.prefixIcon,
    this.autoFocus,
    this.validator,
    this.onEditComplete,
    this.onSaved,
    this.textInputAction,
    required this.obscureText,
    required this.textEditingController,
    required this.textInputType,
    this.onChanged, required this.title,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.maxLines! * 70,
        maxWidth: MediaQuery.of(context).size.width * .8,
      ),
      child: TextFormField(
        maxLines: widget.maxLines,
        onEditingComplete: widget.onEditComplete,
        autofocus: widget.autoFocus ?? false,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyle(
            color: Colors.black,
            fontSize: 18),
        cursorColor: Colors.blueGrey.shade200,
        keyboardType: widget.textInputType,
        onSaved: widget.onSaved,
        validator: widget.validator,
        obscureText: widget.obscureText,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        controller: widget.textEditingController,
        decoration: InputDecoration(
            label: Text(widget.title),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: widget.contentPadding ?? 0,horizontal: widget.contentPadding ?? 0),
            hintText: widget.hintText,
            prefixIcon: null,
            suffixIcon: widget.suffixIcon),
      ),
    );
  }
}
