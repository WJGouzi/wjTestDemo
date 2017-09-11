//
//  WJModifyXMLFileVC.m
//  wjTestDemo
//
//  Created by jerry on 2017/9/11.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJModifyXMLFileVC.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"

@interface WJModifyXMLFileVC ()

@property (nonatomic, strong) UITextView *textView;


@end

@implementation WJModifyXMLFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改xml文件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 64, 275, 275)];
    textView.scrollEnabled = YES;
    textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"Demo.xml" ofType:nil]; // 模拟器上是没得有问题的
    
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlFilePath];
    
    NSError *error = nil;
    
    DDXMLDocument *xmlDocument = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        return;
    }
    NSArray *stuedents = [xmlDocument nodesForXPath:@"//students" error:nil];
    NSLog(@"%@", stuedents.firstObject);
    DDXMLElement *studentsElement = (DDXMLElement *)stuedents.firstObject;
    NSLog(@"students attribute is : %@",studentsElement.attributes);
    // 修改students的属性
    DDXMLNode *countNode = [studentsElement attributeForName:@"count"];
    NSLog(@"count node is : %@", countNode.stringValue);
    DDXMLNode *gradeNode = [studentsElement attributeForName:@"grade"];
    [countNode setStringValue:@"6"];
    [countNode setName:@"peoples"];
    [gradeNode setStringValue:@"9"];
    // 修改age
    NSArray *ages = [xmlDocument nodesForXPath:@"//students//student//age" error:nil];
    for (int i = 0; i < ages.count; i++) {
        DDXMLElement *ageElement = ages[i];
        NSLog(@"age element is %@ : %@", ageElement.name, ageElement.stringValue);
        [ageElement setStringValue:@"1124"];
        //保存到沙盒目录下
        
        NSString *result=[[NSString alloc] initWithFormat:@"%@",xmlDocument];
        //写入数据
        [result writeToFile:xmlFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    NSLog(@"xml path is %@", xmlFilePath);
    
    NSData *newData = [NSData dataWithContentsOfFile:xmlFilePath];
    NSString *newXml = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    self.textView.text = newXml;
}


@end
