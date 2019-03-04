import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:html/dom.dart' as dom;
import 'package:weui/weui.dart';

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
    WeButtonType theme = WeButtonType.acquiescent;
    WeButtonSize size = WeButtonSize.acquiescent;
    bool disabled = false;
    bool loading = false;
    bool plain = false;
    var onTap = attributes['ontap'];

    switch (attributes['type']) {
      case 'primary':
        theme = WeButtonType.primary;
        break;
      case 'warn':
        theme = WeButtonType.warn;
        break;
      default:
        theme = WeButtonType.acquiescent;
        break;
    }

    if (attributes['size'] == 'mini') {
      size = WeButtonSize.mini;
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

    return WeButton(text, theme: theme, disabled: disabled, loading: loading, hollow: plain, size: size, onClick: () {
      page.invoke(onTap);
    });
  }
}
