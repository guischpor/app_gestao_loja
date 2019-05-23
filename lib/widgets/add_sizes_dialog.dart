import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final Color colorPink600 = Colors.pink[600];

  final Color colorGrey850 = Colors.grey[850];

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  'Add',
                  style: TextStyle(color: colorPink600),
                ),
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
