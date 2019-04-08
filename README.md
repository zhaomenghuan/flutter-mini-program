[中文文档](./README-zh.md)

# Flutter MiniProgram

A Flutter's mini-program development framework by parsing HTML、CSS and JS / Dart. This Project is inspired by [FlutterHtmlView](https://github.com/PonnamKarthik/FlutterHtmlView).

## Features

- Convert html tags to flutter widgets
- Support use css to rendering flutter widgets
- Support template compile and data binding

## Framework

### View layer

The view layer of the framework is written by html and css, and the view layer of the page is defined by the .html file, which is displayed by the component. The data of the logical layer is reflected into a view, and the events of the view layer are sent to the logical layer. A Component is the basic building block of a view.

```html
<template>
    <view class="container">
        <text>{{message}}</text>
        <view class="m-10">
            <button type="primary" onTap="onEvaluateJavascript()">evaluateJavascript</button>
        </view>
    </view>
</template>

<script>
Page({
    config: {
        "navigationBarTitleText": "Flutter MiniProgram - JS-API"
    },
    data: {
        message: "Hello Flutter's MiniProgram"
    },
    onLoad() {

    },
    methods: {
        onEvaluateJavascript: function() {
            log('onEvaluateJavascript');
        }
    }
});
</script>

<style>
.container {
    padding: 10px;
}
.m-10 {
    margin: 10px;
}
</style>
```

### Logic Layer

The logic layer of the mini-program development framework is developed using JS / Dart syntax, and the organization of the view logic and native plugin calls are done through the Dart / Flutter plugin. The logic layer processes the data and sends it to the view layer, while accepting event feedback from the view layer.

```js
Page({
    config: {
        "navigationBarTitleText": "Flutter MiniProgram - JS-API"
    },
    data: {
        message: "Hello Flutter's MiniProgram"
    },
    onLoad() {

    },
    methods: {
        onEvaluateJavascript: function() {
            log('onEvaluateJavascript');
        }
    }
});
```

## Component

### Supported Tags

- view/div: 视图容器
- icon: 图标
- text: 文本
- br: 换行符
- hr: 水平分隔线
- p: 段落
- h1 ~ h6: 标题
- a: 链接
- button: 按钮
- input: 输入框
- checkbox: 复选框
- switch: 单选开关
- slider: 滑块
- image: 图片
- video: 视频
- table: 表格
- list-view: 列表
- web-view: 网页容器

### View

A view container, equivalent to the div tag of the Web or the View component of React Native.

API

| Attribute name   |      Types      |  Defaults | Description |
|----------|:-------------:|------:|:-------------:|
| class |  String |  | Custom style name |
| style |  String |  | Inline style |
| onTap | EventHandle |  | Click event |
| onLongTap | EventHandle |  | Long press event |