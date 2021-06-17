import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String? msg;
  final Function? onPressed;

  const WideButton({Key? key, this.msg, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onPressed as void Function()?,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black26,
          ),
          width: MediaQuery.of(context).size.width * 0.85,
          height: 50.0,
          child: Center(
            child: Text(
              msg!,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2,wordSpacing: 3),
            ),
          ),
        ),
      ),
    );
  }
}
