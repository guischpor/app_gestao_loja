import 'package:flutter/material.dart';

import 'images_source.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List initialValue,
    bool autoValidade = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autoValidade,
            builder: (state) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 124,
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value.map<Widget>((i) {
                        return Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            child: i is String
                                ? Image.network(
                                    i,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    i,
                                    fit: BoxFit.cover,
                                  ),
                            //pressionar a imagem por um longo periodo para ser deletado
                            onLongPress: () {
                              state.didChange(state.value..remove(i));
                            },
                          ),
                        );
                      }).toList()
                        ..add(
                          GestureDetector(
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.white.withAlpha(50),
                              child: Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => ImageSourceSheet(
                                      onImageSelected: (image) {
                                        state
                                            .didChange(state.value..add(image));
                                      },
                                    ),
                              );
                            },
                          ),
                        ),
                    ),
                  ),
                  state.hasError
                      ? Text(state.errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ))
                      : Container()
                ],
              );
            });
}