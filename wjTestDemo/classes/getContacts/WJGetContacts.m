//
//  WJGetContacts.m
//  wjTestDemo
//
//  Created by gouzi on 2017/10/23.
//  Copyright © 2017年 wangjun. All rights reserved.
//  获取的是本手机中的通讯录的demo

/*
 *  1.首先要在info.plist文件中添加获取通讯录的权限
 *  2.在AppDelegate文件中进行授权。如果没有授权成功，不能调取手机的通讯录
 *  3.这里只需要获取到本地通讯录，所以要在本个类中验证权限问题
 */


#import "WJGetContacts.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface WJGetContacts () <CNContactPickerDelegate>

// 被选择的联系人的label
@property (nonatomic, strong) UILabel *contactLabel;


@end

@implementation WJGetContacts

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
}

- (void)creatUI {

    self.title = @"通讯录相关";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *selectContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectContactBtn setTitle:@"选择联系人" forState:UIControlStateNormal];
    [selectContactBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectContactBtn.frame = CGRectMake(37.5, 100, 300, 50);
    [selectContactBtn addTarget:self action:@selector(selectContactsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectContactBtn];
    
    UILabel *contactsLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5, 200, 300, 50)];
    contactsLabel.layer.borderWidth = 0.5f;
    contactsLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contactsLabel.textAlignment = NSTextAlignmentLeft;
    contactsLabel.font = [UIFont systemFontOfSize:15.0f];
    contactsLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:contactsLabel];
    self.contactLabel = contactsLabel;
}

// 授权验证->没有UI界面的
- (void)getContactWithoutUI {
    // 授权验证
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        NSLog(@"已经授权...");
    } else {
        return;
    }
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        
        NSString *name = [UIDevice currentDevice].name;
        NSString *phoneName = [familyName stringByAppendingString:givenName];
        NSLog(@"phone name is :%@", phoneName);
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            if ([name isEqualToString:phoneName]) {
                NSString *label = labelValue.label;
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
                *stop = YES;
            }
        }
        //    *stop = YES; // 停止循环，相当于break；
    }];
    
}



#pragma mark - 按钮的点击事件 ->这个是UI界面的
- (void)selectContactsAction:(UIButton *)btn {
    NSLog(@"sss");
    CNContactPickerViewController *contactPickerVC = [[CNContactPickerViewController alloc] init];
    contactPickerVC.delegate = self;
    [self presentViewController:contactPickerVC animated:YES completion:nil];
    
}

#pragma mark - CNContactPickerDelegate
// 选中一个联系人 -> 实现这个方法后就不会实现下面这个选中属性的方法了
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
//    NSLog(@"contact is %@", contact);
//
//
//
//    for (CNLabeledValue *labelValue in contact.phoneNumbers) {
//        CNPhoneNumber *phoneNumber = labelValue.value;
//        NSLog(@"number is %@", phoneNumber.stringValue);
//    }
//}

// 选中一个联系人的属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    NSLog(@"contact property is %@", contactProperty);
    NSString *familyName = contactProperty.contact.familyName;
    NSString *middleName = contactProperty.contact.middleName;
    NSString *givenName = contactProperty.contact.givenName;
    NSString *name = [NSString string];
    if ([familyName isValidChinese] || [middleName isValidChinese] || [givenName isValidChinese]) {
        name = [NSString stringWithFormat:@"%@ %@ %@", familyName, middleName, givenName];
    } else {
        name = [NSString stringWithFormat:@"%@ %@ %@", givenName, middleName, familyName];
    }
    
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    self.contactLabel.text = [NSString stringWithFormat:@"%@ - %@", name, phoneNumber.stringValue];
}
/*
 
 // 选中多个联系人
 - (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
 
 }
 
 // 选中一个联系人的多个属性
 - (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty *> *)contactProperties {
 
 }
 */

@end
