//
//  WJXMLToJsonVC.m
//  wjTestDemo
//
//  Created by gouzi on 2017/10/30.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "WJXMLToJsonVC.h"
#import "XMLReader.h"


@interface WJXMLToJsonVC ()
@property (weak, nonatomic) IBOutlet UILabel *xmlLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsonLabel;
@property (nonatomic, strong) NSData *xmlData;
@end

@implementation WJXMLToJsonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"Demo.xml" ofType:nil]; // 模拟器上是没得有问题的
    
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlFilePath];
    self.xmlData = xmlData;
    NSString *xmlStr = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    self.xmlLabel.text = xmlStr;
}

- (IBAction)xmlConvertJsonActionClick:(UIButton *)sender {
    self.jsonLabel.text = nil;
    NSDictionary *jsonDict = [XMLReader dictionaryForXMLString:self.xmlLabel.text error:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.jsonLabel.text = jsonStr;
}
- (IBAction)xmlDataConvertToJsonActionClick:(UIButton *)sender {
    self.jsonLabel.text = nil;
    NSDictionary *jsonDict = [XMLReader dictionaryForXMLData:self.xmlData error:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.jsonLabel.text = jsonStr;
}

@end
