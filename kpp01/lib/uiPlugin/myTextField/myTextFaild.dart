import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyTextField extends StatelessWidget{
  const MyTextField({
    Key key,
    this.lengthLimiting: 20,
    this.filterPattern,///RegExp("[a-zA-Z0-9!,.?\\s]")
    this.textEditingController,
    this.keyboardType: TextInputType.text,
    this.inputDecoration: const InputDecoration(border: UnderlineInputBorder()),
    this.cursorColor,
    this.maxLines: 1,
    this.textFieldName: "1",
}):super(key: key);

  final TextEditingController textEditingController;
  final int lengthLimiting ;
  final Pattern filterPattern;
  final TextInputType keyboardType;
  final InputDecoration inputDecoration;
  final Color cursorColor;
  final int maxLines;
  final String textFieldName;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(filterPattern),
        LengthLimitingTextInputFormatter(lengthLimiting),
      ],
      controller: textEditingController,
      cursorColor: cursorColor,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: inputDecoration,
      onChanged: (text){
        print("textEditingController $textFieldName: $text");
      },
    );
  }

}