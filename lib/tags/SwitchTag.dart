import 'package:flutter/cupertino.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_mini_program/components/ui.dart';

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
    var attributes = widget.element.attributes;
    var _color = attributes['color'];
    var _size = attributes['size'];
    var _disabled = attributes['disabled'];

    Color color = _color != null ? StyleParser.parseColor(_color) : Color(0xff1AAD19);
    double size = _size != null ? ConvertUtil.parseValue(_size) : 28.0;
    bool disabled =
        _disabled != null ? ConvertUtil.parseValue(_disabled) : false;

    return UISwitch(
        checked: _isChecked,
        color: color,
        size: size,
        disabled: disabled,
        onChange: onChange);
  }
}
