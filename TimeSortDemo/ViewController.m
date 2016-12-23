//
//  ViewController.m
//  TimeSortDemo
//
//  Created by Xinhou Jiang on 22/12/16.
//  Copyright © 2016年 Xinhou Jiang. All rights reserved.
//

#import "ViewController.h"
#import "Account.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UITextView *text;

@property (nonatomic, strong) NSMutableArray<Account*> *accountArray; // 账户数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    [self request];
    // 排序前
    [self showUI];
    
}

- (void) request {
    // 初始化数组并添加几个账户假数据对象
    _accountArray = [[NSMutableArray alloc] init];
    [_accountArray addObject:[Account newAccountWithName:@"张三" andTime:1450675000]];
    [_accountArray addObject:[Account newAccountWithName:@"李四" andTime:1450923000]];
    [_accountArray addObject:[Account newAccountWithName:@"小明" andTime:1450656000]];
    [_accountArray addObject:[Account newAccountWithName:@"小丽" andTime:1450435000]];
}

// 将数组按照时间戳排序
- (IBAction)sort:(id)sender {
    /** 按照时间戳排序 **/
    // 1.初始化
    // 时间戳数组(存放时间NSDate对象用于排序)
    NSMutableArray *timeArr = [[NSMutableArray alloc]init];
    // 时间戳-对象字典，将对象和其对应的时间戳字符串存入字典（哈希表）
    NSMutableDictionary *dateKeyArr = [[NSMutableDictionary alloc]init];
    
    // 2.时间戳取出，并格式化处理
    for(Account *acc in _accountArray) {
        // 时间戳转成时间对象用于排序
        NSDate  *date = [NSDate dateWithTimeIntervalSince1970:acc.loginTime];
        [timeArr addObject:date];
        // 时间戳转成时间戳字符串作为key,制作哈希表
        NSNumber *dataNum = [NSNumber numberWithLongLong:acc.loginTime];
        NSString *datekey = [dataNum stringValue];
        [dateKeyArr setObject:acc forKey:datekey];
    }
    
    // 3.将时间NSDate数组排序
    NSArray *orderedDateArray = [timeArr sortedArrayUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
        // 降序排序，最近的时间靠前
        return [date2 compare:date1];
    }];
    
    // 4.根据排序好的时间数组对号入座将对象按时间排序
    // 临时数组，保存排序后的对象数组
    NSMutableArray *sortedAccounts = [[NSMutableArray alloc]init];
    NSDate *datekey = [[NSDate alloc]init];
    for (int i = 0; i<orderedDateArray.count; i++) {
        datekey = orderedDateArray[i];
        // 日期对象转换成时间戳字符串key
        NSString *datekeys = [NSString stringWithFormat:@"%lld", (long long)[datekey timeIntervalSince1970]];
        // 根据时间戳字符串key取对应的对象（哈希表）
        [sortedAccounts addObject:[dateKeyArr objectForKey:datekeys]];
    }
    
    // 5.更新排序后的对象数组[ARC中不需要手动释放排序前的数组]
    _accountArray = sortedAccounts;
    
    // 显示排序后的数据
    [self showUI];
}

// 显示数据到页面
- (void) showUI {
    NSString *s = [NSString stringWithFormat:@"%@[%lld]\n%@[%lld]\n%@[%lld]\n%@[%lld]",
                   _accountArray[0].name,_accountArray[0].loginTime,
                   _accountArray[1].name,_accountArray[1].loginTime,
                   _accountArray[2].name,_accountArray[2].loginTime,
                   _accountArray[3].name,_accountArray[3].loginTime];
    _text.text = s;
}

@end
