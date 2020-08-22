import 'package:flutter/material.dart';
import '../constants.dart';

class StepperButton extends StatelessWidget {
  const StepperButton({
    Key key,
    @required VoidCallback onPressed,
    @required IconData icon
  }) : _onTap = onPressed, _icon = icon, super(key: key);

  final IconData _icon;
  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
      return Material(
      color: darkBlue,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: _onTap,
        splashColor: lightBlue,
        highlightColor: lightBlue,
        focusColor: lightBlue,
        child: Container(
          height: STEPPER_BUTTON_DIMENSION,
          width: STEPPER_BUTTON_DIMENSION,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Icon(_icon, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}