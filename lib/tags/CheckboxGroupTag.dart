import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;

/// Creates a line break from a template <checkbox-group> tag.
class CheckboxGroupTag extends StatefulWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  CheckboxGroupTag({this.page, this.element, this.style});

  @override
  State<CheckboxGroupTag> createState() => CheckboxGroupTagState();
}

class CheckboxGroupTagState extends State<CheckboxGroupTag> {
  List<Widget> widgetList = [];
  List checkboxState = [];
  onCheckChange(bool isChecked) {
    setState(() {

    });
  }

  @override
  void initState() {
    var children = widget.element.children;
    children.forEach((label) {
      bool isChecked = ConvertUtil.parseValue(label.getElementsByTagName("checkbox").first.attributes['checked']);
      String text = label.getElementsByTagName("text").first.text;
      widgetList.add(Row(
          children: <Widget>[
            new Checkbox(value: isChecked, onChanged: onCheckChange),
            new Text(text)
          ]
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.element.localName == 'checkbox-group');
    return Wrap(
      children: widgetList
    );
  }
}