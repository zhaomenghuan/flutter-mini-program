import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;

/// Creates a line break from a template <checkbox> tag.
class InputTag extends StatefulWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  InputTag({this.page, this.element, this.style});

  @override
  State<InputTag> createState() => InputTagState();
}

class InputTagState extends State<InputTag> {
  bool focus = false;
  String placeholder;
  TextInputType type;
  String onInput;

  onChange(bool isChecked) {
    setState(() {});
  }

  @override
  void initState() {
    var attributes = widget.element.attributes;
    type = parseTextInputType(attributes['type']);
    placeholder = attributes['placeholder'];
    focus = attributes.containsKey('focus')
        ? ConvertUtil.parseValue(attributes['focus'])
        : false;
    onInput = attributes['oninput'];
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.element.localName == 'input');
    return new TextField(
        keyboardType: type,
        autofocus: focus,
        decoration: InputDecoration(hintText: placeholder),
        onChanged: (String value) {
          widget.page.invoke(onInput);
        });
  }

  TextInputType parseTextInputType(String type) {
    switch (type) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      case 'url':
        return TextInputType.url;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
