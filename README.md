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

###2.扫描二维码
扫描二维码也采用的是系统自带的方式进行扫描的，这样的效率更加的快。

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
![plist文件配置](/Users/jerry/Desktop/屏幕快照 2017-06-29 上午10.43.32.png)