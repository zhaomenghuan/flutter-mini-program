import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:html/dom.dart' as dom;

/// Builds a icon from a <list-view> tag.
class ListViewTag extends StatefulWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  ListViewTag({this.page, this.element, this.style});

  @override
  State<StatefulWidget> createState() => ListViewTagState();
}

class ListViewTagState extends State<ListViewTag> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List data = [];
    List<dom.Element> children = widget.element.children;
    children.forEach((dom.Element node) {
      assert(node.localName == 'list-item',
          'Expected <list-item>, instead found ${widget.element}');
      var attributes = node.attributes;
      data.add({
        "title": attributes['title'],
        "subtitle": attributes['subtitle'],
        "link": attributes['link'],
        "onTap": attributes['ontap'],
        "onLongTap": attributes['onlongtap']
      });
    });

    return new ListView.builder(
        physics: new NeverScrollableScrollPhysics(), // Disable scrolling events
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) => new ListTile(
              title: new Text('${data[index]["title"]}',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: new Text('${data[index]["subtitle"]}'),
              onTap: () {
                widget.page.invoke(data[index]["onTap"]);
              },
              onLongPress: () {
                widget.page.invoke(data[index]["onLongTap"]);
              },
            ));
  }
}
