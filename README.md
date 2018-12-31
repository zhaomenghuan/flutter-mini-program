# flutter_mini_program

A Flutter UI Framework by parsing HTML + CSS, is for developing mini-program, just like [WebChat miniprogram](https://developers.weixin.qq.com/miniprogram/dev/framework/MINA.html). This Project is inspired by [FlutterHtmlView](https://github.com/PonnamKarthik/FlutterHtmlView).

## Getting Started

Define Page View：

```html
<config>
{
    "navigationBarTitleText": "Flutter 小程序"
}
</config>

<template>
    <view>
         <!--Icon-->
         <icon type="threesixty" size="30"></icon>

         <!--Image-->
         <text>Network Image：</text>
         <image src="https://avatars2.githubusercontent.com/u/13075561?s=460&v=4"></image>
         <text>Local Image：</text>
         <image src="../images/avatar.png"></image>

         <!--Button-->
         <button type="close">关闭类型的按钮</button>
         <button type="back">返回类型的按钮</button>
         <button type="floating-action" onclick="onFloatingButtonClick">Icon 类型的按钮</button>
         <button type="icon">Icon 类型的按钮</button>
         <button type="flat">扁平的 Material 类型的按钮</button>
         <button type="raised">阴影效果的按钮</button>
         <button type="raw-material">背景透明的按钮</button>
    </view>
</template>
```

Define Page Controller：

```dart
class IndexPage extends Page {
  String url;
  BuildContext mContext;

  IndexPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;

    print(page);
    print(page.emitter);
    print(page.view);
    print(Application.router);

    page.emitter.on('lifecycle', () => print('监听'));
  }

  Map data = {
    "list": [
      {"title": "Icon", "subtitle": "图标", "routeName": "/icon"},
      {"title": "Text", "subtitle": "文本", "routeName": "/text"},
      {"title": "Button", "subtitle": "按钮", "routeName": "/button"},
      {"title": "Image", "subtitle": "图片", "routeName": "/image"},
      {"title": "Checkbox", "subtitle": "复选框", "routeName": "/checkbox"}
    ]
  };

  Map<String, Function> get methods => {
    "openPage": (String path) {
      Application.navigateTo(mContext, path);
    }
  };
}
```

## Supported Tags

- icon
- text
- button
- checkbox
- image
- video
