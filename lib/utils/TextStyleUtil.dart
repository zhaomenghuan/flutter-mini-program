import 'package:flutter/material.dart';

class TextStyleUtil {
  /**
   * color
   * fontSize
   * fontWeight
   * fontStyle
   * letterSpacing
   * wordSpacing
   * textBaseline
   * height
   * locale
   * foreground
   * background
   * shadows
   * decoration
   * decorationColor
   * decorationStyle
   * debugLabel
   * fontFamily
   */
  static TextStyle parseStyle(BuildContext context, String tag, Map attrs) {
    RegExp _style = new RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
    RegExp _color = new RegExp(r'^#([a-fA-F0-9]{6})$');
    Iterable<Match> matches;
    String style = attrs['style'];
    String param;
    String value;

    TextStyle defaultTextStyle = DefaultTextStyle.of(context).style;
    double fontSize = defaultTextStyle.fontSize;
    Color color = defaultTextStyle.color;
    FontWeight fontWeight = defaultTextStyle.fontWeight;
    FontStyle fontStyle = defaultTextStyle.fontStyle;
    TextDecoration textDecoration = defaultTextStyle.decoration;

    switch (tag) {
      case 'h1':
        fontSize = 32.0;
        break;
      case 'h2':
        fontSize = 24.0;
        break;
      case 'h3':
        fontSize = 20.8;
        break;
      case 'h4':
        fontSize = 16.0;
        break;
      case 'h5':
        fontSize = 12.8;
        break;
      case 'h6':
        fontSize = 11.2;
        break;
      case 'a':
        textDecoration = TextDecoration.underline;
        color = new Color(int.parse('0xFF1965B5'));
        break;
      case 'b':
      case 'strong':
        fontWeight = FontWeight.bold;
        break;
      case 'i':
      case 'em':
        fontStyle = FontStyle.italic;
        break;
      case 'u':
        textDecoration = TextDecoration.underline;
        break;
    }

    if (style != null) {
      matches = _style.allMatches(style);
      for (Match match in matches) {
        param = match[1].trim();
        value = match[2].trim();

        switch (param) {
          case 'color':
            if (_color.hasMatch(value)) {
              value = value.replaceAll('#', '').trim();
              color = new Color(int.parse('0xFF' + value));
            }
            break;
          case 'font-weight':
            fontWeight =
            (value == 'bold') ? FontWeight.bold : FontWeight.normal;
            break;
          case 'font-style':
            fontStyle =
            (value == 'italic') ? FontStyle.italic : FontStyle.normal;
            break;
          case 'font-size':
            value = value.replaceAll('px', '').trim();
            fontSize = double.parse(value);
            break;
          case 'text-decoration':
            textDecoration = (value == 'underline')
                ? TextDecoration.underline
                : TextDecoration.none;
            break;
        }
      }
    }

    TextStyle textStyle;

    if (fontSize != 0.0) {
      textStyle = new TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontSize: fontSize);
    } else {
      textStyle = new TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
      );
    }

    return textStyle;
  }
}