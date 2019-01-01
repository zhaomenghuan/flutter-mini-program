import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:html/dom.dart' as dom;

/// Creates a line break from a template <br/> tag.
// http://flutter.link/2018/03/26/Input%20and%20selection/
class CheckboxTag extends StatefulWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  CheckboxTag({this.page, this.element, this.style});

  @override
  State<CheckboxTag> createState() => CheckboxTagState();
}

class CheckboxTagState extends State<CheckboxTag> {
  var _isChecked = true;

  onCheckChange(bool isChecked) {
    setState(() {
      _isChecked = isChecked;
    });
  }

  @override
  void initState() {
    var attributes = widget.element.attributes;
    _isChecked = bool.fromEnvironment(attributes['value']);
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.element.localName == 'checkbox');
    return new Checkbox(value: _isChecked, onChanged: onCheckChange);
  }
}