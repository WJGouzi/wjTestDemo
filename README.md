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



### 5.touchID的应用

touchID，也是需要硬件的支持，有的时候需要在登录的时候验证身份，有的时候需要获取权限，往往在这种情景下会用到指纹识别。

需要用到的框架是import \<LocalAuthentication/LocalAuthentication.h\>

需要创建一个回话>> 如果设备支持>>开始识别指纹

### 6.手势解锁

手势解锁是对应用程序或者是个人用户信息资料的一种保护手段，需要将所绘制的手势保存到本地或者是服务器，然后下一次进行绘制的时候就进行比对，这个原理和touchID的原理类似，都是需要进行验证，如果不一致就不进行后续的操作。

此demo中的手势绘制是利用响应者touch手势的来绘制，同事兼顾着quartz2D技术进行绘制的图像。原则上一个点被绘制过后就不能够再次绘制，所以会有一个检测机制：避免重复绘制。

绘制的规则：绘制的点必须是4个点以上，然后不能有重复。

绘制保存：第一次绘制将作为原始的手势进行存储，当第二次绘制的时候，就会比对之前存储的值，如果一旦错误，就不进行后续操作。

清除之前的绘制图形：对于忘记密码的操作，就只要点击这一步就把本地的手势进行清除，同时将下一次的绘制当做是第一次进绘制，进行保存到本地中。


###7.医学影像
医学影像是模仿询医通患者版的影像资料做的demo，其中的标记图片的相关信息，本demo没有有做完。目前完成的部分仅限于与轮播图的设置，在iOS11上有frame的bug，以及完成了底部bar的UI界面的搭建，并没有进行更多的展示。

###8.数据加密
目前在这个demo中做了md5的加密方法以及des的加密和解密的方法。

md5加密是不可逆的，所以并没有进行md5的解密方法。

而在des加密中使用了一个加密的密钥："ZDwyfZSY"，同理在解密的时候也是需要这个密钥的。这个密钥可以根据具体的项目进行更改。

###9.选取关键字
选取关键字是将一段文字中把所选取的文字设置成为另一种颜色的做法，其实这也就是讲文本框的文字转为富文本的方式，将选择出来的文字设置成其他颜色，将剩余的文字的大小和颜色均不作处理，然后将处理后的富文本文字返回给文本框。

###10.网页缓存
网页的缓存将第一次加载网页的时候，就将网页的相关内容缓存在本地的做法，一旦在网络不好或者是在重复加载本个网页的情况下就直接加载缓存中的内容，就减少了对数据流量的使用，同样也节约了资源。

如果网页中的内容发生变化的时候，网页缓存的内容会被重新的写入，也就是之前网页的缓存会被清除，然后写入新的缓存。

###11.背景渐变
背景渐变并非使用的是一张渐变色的图片进行展示，而是将颜色或者是透明度通过frame的变化进行渐变。

###12.卡片式的轮播图
此类型的轮播并非是普通的轮播的样式，有点类似于卡片式的，当页面要展示的时候，页面将会变大，如果不在展示的时候，页面将会变小，当然还可以进行无限轮播。

###13.修改xml文件
目前修改xml文件仅限于在模拟器中进行，真机修改xml文件还没有成功。

利用的是DDXML三方库进行标签的操作，然后将标签的内容进行修改掉操作。修改完成后的xml会将写入到本地的沙盒目录中，完成整个的xml文件的修改。
