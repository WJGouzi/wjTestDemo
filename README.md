# wjTestDemo
this is a test demo!

这个demo用作于以后的所有test的demo的集合。也将作为个人的demo集合。

###0.ViewController基本设置
0.1.ViewController 中以一个列表的形式展示出来

0.2.数据的来源都是写在model.plist文件中的，然后用原生的UITableviewCell进行展示，在model.plist文件中需要编辑每行cell对应的名字以及icon。

0.3.对cell的icon的图片统一放在Assets文件中，对于每个test demo所需的图片等资源，在每个demo文件夹中创建一个专门用于保存图片等资源的文件夹进行管理。

0.4.在ViewController嵌套了一个导航控制器，每个控制器都可以在导航栏显示本控制器的名字，以便于区分。

###1.生成二维码
二维码的生成方式有系统原生的和自定义的二维码两种方案

系统原生的生成二维码需要继承import \<CoreImage/CoreImage.h\>框架，然后生成一张二维码的图片，然后再对生成的二维码图片进行高清化处理。

自定义的二维码也是使用的原生的框架，改变了二维码的颜色，修改了二维码的尺寸，给二维码添加了背景和中间的自定义的头像。

###2.扫描二维码
扫描二维码也采用的是系统自带的方式进行扫描的，这样的效率更加的快。二维码的扫描采用的是摄像头进行获取二维码的图片，然后进行分析图片。

在页面的结构中，添加了一些图片用于提示用户扫描的区域，然后对未扫描的区域进行蒙层的阴影化处理。

设置摄像头，首先得判断是否存在摄像头的硬件，然后再进行扫描，设置扫描的区域，设置会话以及设置扫描图片的类型，最后将扫描的图像插入到控制器中进行展示。

处理数据，对获取到的数据调用代理进行分析，得到扫描的结果并且用提醒框的方式进行展示。

### 3.更换应用图标（10.3之后）

更换应用的图标需要把图片资源放到工程目录中，在编译的时候会放到工程的bundle中，特别是真机运行的时候需要从bundle文件中读取图片资源。

plist文件进行配置

	<key>CFBundlePrimaryIcon</key>
	<dict>
		<key>CFBundleIconFiles</key>
		<array>
			<string>AppIcon</string>
		</array>
	</dict>
	<key>CFBundleAlternateIcons</key>
	<dict>
		<key>iconChange</key>
		<dict>
			<key>CFBundleIconFiles</key>
			<array>
				<string>iconChange</string>
			</array>
			<key>UIPrerenderedIcon</key>
			<false/>
		</dict>
	</dict>

### 4. 3Dtouch

3Dtouch功能只有在一些的机型上可以使用，在6s之后的手机可以使用，在手机的应用图标进行用力点击，会出现一个列表，当选择某一个选项的时候会进入到相关的页面。

3Dtouch中的peek操作以及手势的pop操作会在应用中将3Dtouch延续，可以在不进行跳转的页面的情况下预览下个页面的内容。上滑页面可以进行相关的操作，例如电话短信等操作。

静态设置icon展示的内容需要在plist文件中进行设置

	<dict>
		<key>UIApplicationShortcutItemTitle</key>
		<string>生成二维码</string>
		<key>UIApplicationShortcutItemType</key>
		<string>com.wangjun.wjTestDemo.3Dtouch.creatQRCode</string>
	</dict>
	<dict>
		<key>UIApplicationShortcutItemIconType</key>
		<string>UIApplicationShortcutIconTypeShuffle</string>
		<key>UIApplicationShortcutItemSubtitle</key>
		<string>应用图标更改</string>
		<key>UIApplicationShortcutItemTitle</key>
		<string>切换图标</string>
		<key>UIApplicationShortcutItemType</key>
		<string>com.wangjun.wjTestDemo.3Dtouch.changeAppIcon</string>
		<key>UIApplicationShortcutItemUserInfo</key>
		<dict>
			<key>key1</key>
			<string>value1</string>
		</dict>
	</dict>
当然也可以在appDelegate中进行设置，可以设置成系统的样式，也可以设置成自定义的样式，图片可以自由的设置。