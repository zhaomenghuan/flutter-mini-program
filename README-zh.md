# Flutter 小程序

一个基于 Flutter 框架的小程序开发框架。通过解析 HTML 标签 和 CSS 样式，用于开发小程序应用，项目灵感来自 [FlutterHtmlView](https://github.com/PonnamKarthik/FlutterHtmlView)。

## 特性

- 将 html 标签转换为 Flutter 组件
- 支持使用 css 样式渲染 Flutter 组件
- 支持模板编译及数据绑定

## 框架

### 视图层

框架的视图层由 html 与 css 编写，通过 .html 文件定义页面的视图层，由组件来进行展示。将逻辑层的数据反应成视图，同时将视图层的事件发送给逻辑层。组件(Component)是视图的基本组成单元。

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

### 逻辑层

小程序开发框架的逻辑层使用 JS / Dart 语法进行开发，通过 Dart / Flutter 插件完成视图逻辑的组织及原生插件调用。逻辑层将数据进行处理后发送给视图层，同时接受视图层的事件反馈。

```dart
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

## 组件

### 支持的组件

- view: 视图容器
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

### 视图

视图容器，相当于 Web 的 div 标签或者 React Native 的 View 组件。

#### API

| 属性名   |      类型      |  默认值 | 描述 |
|----------|:-------------:|------:|:-------------:|
| class |  String |  | 自定义样式名 |
| style |  String |  | 内联样式 |
| onTap | EventHandle |  | 点击事件 |
| onLongTap | EventHandle |  | 长按事件 |

### Button

按钮。

#### API

| 属性名   |      类型      |  默认值 | 描述 |
|----------|:-------------:|------:|:-------------:|
| size |  String | default | 按钮的大小 |
| type |  String | default | 按钮的样式类型 |
| plain |  Boolean | false | 按钮是否镂空，背景色透明 |
| disabled |  Boolean | false | 是否禁用 |
| loading |  Boolean | false | 名称前是否带 loading 图标 |

#### 示例

```html
<view class="container">
    <text>按钮</text>
    <view class="mb-10">
        <button type="default" ontap="">default</button>
    </view>
    <view class="mb-10">
        <button type="primary">primary</button>
    </view>
    <view class="mb-10">
        <button type="warn">warn</button>
    </view>

    <text>disabled 状态</text>
    <view class="mb-10">
        <button type="default" disabled="true">default</button>
    </view>
    <view class="mb-10">
        <button type="primary" disabled="true">primary</button>
    </view>
    <view class="mb-10">
        <button type="warn" disabled="true">warn</button>
    </view>

    <text>loading 状态</text>
    <view class="mb-10">
        <button type="default" loading="true">default</button>
    </view>
    <view class="mb-10">
        <button type="primary" loading="true">primary</button>
    </view>
    <view class="mb-10">
        <button type="warn" loading="true">warn</button>
    </view>

    <text>plain 状态</text>
    <view class="mb-10">
        <button type="default" plain="true">default</button>
    </view>
    <view class="mb-10">
        <button type="primary" plain="true">primary</button>
    </view>
    <view class="mb-10">
        <button type="warn" plain="true">warn</button>
    </view>

    <text>按钮大小</text>
    <view class="mb-10">
        <button type="default" size="mini">default</button>
    </view>
    <view class="mb-10">
        <button type="primary" size="mini">primary</button>
    </view>
    <view class="mb-10">
        <button type="warn" size="mini">warn</button>
    </view>
</view>
```

### Switch

开关选择器。

#### API

| 属性名   |      类型      |  默认值 | 描述 |
|----------|:-------------:|------:|:-------------:|
| checked | Boolean |  | 是否选中 |
| disabled | Boolean |  | 禁用状态 |
| size | double |   | 自定义大小 |
| color | String |   | 自定义颜色 |
| onChange | EventHandle |   | checked 改变时触发 |

### 文本输入框

文本输入框, 相当于 Web 的 input 标签 或者 iOS 中的 UITextField 和 Android 中的 EditText。

| 属性名   |      类型      |  默认值 | 描述 |
|----------|:-------------:|------:|:-------------:|
| type | String |  | input 的类型 |
| placeholder | String |  | 占位符 |
| focus | Boolean |  false | 获取焦点 |

```html
<view>
    <text>这是一个可以自动聚焦的input: </text>
    <input type="text" placeholder="这是一个可以自动聚焦的input" focus="true" />
</view>
<view>
    <text>数字键盘: </text>
    <input type="number" placeholder="数字键盘" />
</view>
```

### 图片

API

| 属性名   |      类型      |  默认值 | 描述 |
|----------|:-------------:|------:|:-------------:|
| class |  String |  | 自定义样式名 |
| style |  String |  | 内联样式 |
| src | String |  | 图片路径 |
| fit | String |  | 图片裁剪、缩放的模式, fill | contain | cover | fitWidth | fitHeight | none | scaleDown |

```html
<view>
    <h4>网络图片：</h4>
    <image src="https://avatars2.githubusercontent.com/u/13075561?s=460&v=4"
           style="width: 200px;height:200px"></image>
</view>
<view>
    <h4>本地图片：</h4>
    <image src="../images/avatar.png" style="width: 200px;height:200px"></image>
</view>
<view>
    <h4>图片裁剪模式 fit = "fill": </h4>
    <image src="../images/avatar.png" style="width: 200px;height:100px" fit="fill"></image>
</view>
```