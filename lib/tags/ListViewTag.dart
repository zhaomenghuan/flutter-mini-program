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
    List data = widget.page.data[widget.element.attributes['data']];

    return new ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) => new ListTile(
              title: new Text('${data[index]["title"]}',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: new Text('${data[index]["subtitle"]}'),
              onTap: () {
                widget.page.invoke("openPage('${data[index]["routeName"]}')");
              },
            ));
  }
}
