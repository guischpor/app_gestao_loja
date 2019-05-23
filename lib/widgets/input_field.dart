import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  InputField({
    this.hint,
    this.icon,
    this.obscure,
    this.stream,
    this.onChanged,
  });

  final Color colorPink600 = Colors.pink[600];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorPink600,
              fontSize: 15,
            ),
            icon: Icon(
              icon,
              color: colorPink600,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorPink600,
              ),
            ),
            contentPadding: EdgeInsets.only(
              left: 5,
              right: 30,
              bottom: 30,
              top: 30,
            ),
            errorText: snapshot.hasError ? snapshot.error : null,
          ),
          style: TextStyle(
            color: colorPink600,
          ),
          obscureText: obscure,
        );
      },
    );
  }
}
