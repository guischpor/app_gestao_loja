import 'package:flutter/material.dart';

class ProductSizes extends FormField<List> {
  final Color colorPink600 = Colors.pink[600];

  final Color colorGrey850 = Colors.grey[850];

  ProductSizes({
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator validator,
  }) : super(
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (state) {
            return SizedBox(
              height: 34,
              child: GridView(
                padding: EdgeInsets.symmetric(vertical: 4),
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
                children: state.value.map((s) {
                  return GestureDetector(
                    onLongPress: () {
                      state.didChange(state.value..remove(s));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        border: Border.all(
                          color: Colors.pink[600],
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        s,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList()
                  ..add(
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            color: Colors.pink[600],
                            width: 3,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            );
          },
        );
}
