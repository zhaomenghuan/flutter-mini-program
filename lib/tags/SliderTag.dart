import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;

/// Creates a Slider from a template <slider> tag.
class SliderTag extends StatefulWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  SliderTag({this.page, this.element, this.style});

  @override
  State<SliderTag> createState() => SliderTagState();
}

class SliderTagState extends State<SliderTag> {
  double _value = 0.0;
  String onChange;

  @override
  void initState() {
    var attributes = widget.element.attributes;
    onChange = attributes['onchange'];
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.element.localName == 'slider');
    // var color = widget.element.attributes['color'];
    // Color activeColor = color != null ? StyleParser.parseColor(color) : null;
    return new Slider(
        label: "进度",
        min: 0.0,
        max: 100.0,
        value: _value,
        onChanged: (double value) {
          setState(() {
            _value = value;
            widget.page.invoke("$onChange($value)");
          });
        });
  }
}
