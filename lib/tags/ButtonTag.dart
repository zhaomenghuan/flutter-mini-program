import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_mini_program/components/ui.dart';

/// Builds a icon from a <button> tag.
class ButtonTag extends StatelessWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  ButtonTag({this.page, this.element, this.style});

  @override
  Widget build(BuildContext context) {
    assert(element.localName == 'button');

    String text = element.text;
    var attributes = element.attributes;
    UIButtonType theme = UIButtonType.acquiescent;
    UIButtonSize size = UIButtonSize.acquiescent;
    bool disabled = false;
    bool loading = false;
    bool plain = false;
    var onTap = attributes['ontap'];

    switch (attributes['type']) {
      case 'primary':
        theme = UIButtonType.primary;
        break;
      case 'warn':
        theme = UIButtonType.warn;
        break;
      default:
        theme = UIButtonType.acquiescent;
        break;
    }

    if (attributes['size'] == 'mini') {
      size = UIButtonSize.mini;
    }

    if (attributes['disabled'] == 'true') {
      disabled = true;
    }

    if(attributes['loading'] == 'true') {
      loading = true;
    }

    if(attributes['plain'] == 'true') {
      plain = true;
    }

    return UIButton(text, theme: theme, disabled: disabled, loading: loading, hollow: plain, size: size, onClick: () {
      page.invoke(onTap);
    });
  }
}
