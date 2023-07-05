import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.width})
      : super(key: key);
  final String text;
  final Function() onPressed;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width * .8,
        child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade300,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          onPressed: onPressed,
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
