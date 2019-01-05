import 'package:flutter/cupertino.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;

/// Creates a line break from a template <checkbox> tag.
class SwitchTag extends StatefulWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  SwitchTag({this.page, this.element, this.style});

  @override
  State<SwitchTag> createState() => SwitchTagState();
}

class SwitchTagState extends State<SwitchTag> {
  var _isChecked = true;

  onChange(bool isChecked) {
    setState(() {
      _isChecked = isChecked;
      var onChange = widget.element.attributes['onchange'];
      widget.page.invoke(onChange + "($_isChecked)");
    });
  }

  @override
  void initState() {
    var attributes = widget.element.attributes;
    _isChecked = ConvertUtil.parseValue(attributes['checked']);
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.element.localName == 'switch');
    var color = widget.element.attributes['color'];
    Color activeColor = color != null ? StyleParser.parseColor(color) : null;
    return CupertinoSwitch(
        value: _isChecked, onChanged: onChange, activeColor: activeColor);
  }
}
