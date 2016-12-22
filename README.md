# TimeSortDemo
时间戳排序

> 将对象按照时间戳排序，这里典型的一个例子是登录账户的排序：本地客户端可能保存了多个账户信息，在登录窗口用户可以选择已经登陆过的账户直接登录，现在的需求是要时刻让最近登陆过的账户排在前面，对于每个账户，每次登陆时都记录下当前登陆的时间，时间是一个时间戳（从1970年到现在的秒数）。我们要做的是将时间戳排序，然后按照时间戳的顺序将所有账户排序。当然这也适用于其他关于时间排序的问题。

***
<img src="http://img.blog.csdn.net/20161222183549241?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvY29yZG92YQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" width="300px"/>

> ## 实现思路和过程

- 1.先将每个账户对象的时间戳变量（要足够精确，采用long long int）取出来：一方面要将每个时间戳转换成NSDate对象用于排序；另一方面要将每一个时间戳转换成一个字符串作为key和对应的账户对象放入字典中做成一个哈希表，用于之后根据排序好的时间戳将账户对象数组排序。

 排序过程需要一个数组用于时间排序的NSDate对象，一个字典作为存放‘时间戳-对象’的哈希表：

```objc
    // 时间戳数组(存放时间NSDate对象用于排序)
    NSMutableArray *timeArr = [[NSMutableArray alloc]init];
    // 时间戳-对象字典，将对象和其对应的时间戳字符串存入字典（哈希表）
    NSMutableDictionary *dateKeyArr = [[NSMutableDictionary alloc]init];
    
    // 时间戳取出，并格式化处理
    for(Account *acc in _accountArray) {
        // 1.时间戳转成时间对象用于排序
        NSDate  *date = [NSDate dateWithTimeIntervalSince1970:acc.loginTime];
        [timeArr addObject:date];
        // 2.时间戳转成时间戳字符串作为key,制作哈希表
        NSNumber *dataNum = [NSNumber numberWithLongLong:acc.loginTime];
        NSString *datekey = [dataNum stringValue];
        [dateKeyArr setObject:acc forKey:datekey];
    }
```

- 2.将取出的NSDate对象数组排序

```objc
	// 3.将时间NSDate数组排序
    NSArray *orderedDateArray = [timeArr sortedArrayUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
        // 降序排序，最近的时间靠前
        return [date2 compare:date1];
    }];
```

- 3.按照排序好的时间数组，安排好的顺序将对象从哈希表一次取出得到排序好的对象数组：

```objc
	// 根据排序好的时间数组对号入座将对象按时间排序
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
    
    // sortedAccounts就是我们要的结果了
```

> ## 完整的示例Demo

这里制作一个只包含用户名和时间戳的假账户数据，排序后按照顺序显示在一个textview中：

### 账户Account

```objc
//
//  Account.h
//  TimeSortDemo
//
//  Created by Xinhou Jiang on 22/12/16.
//  Copyright © 2016年 Xinhou Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, copy) NSString *name;              // 姓名
@property (nonatomic, assign) long long int loginTime;   // 上次登录时间戳（距离1970年的秒数）

+ (Account*)newAccountWithName:(NSString *)name andTime:(long long int)logintime;

@end
```

```objc
//
//  Account.m
//  TimeSortDemo
//
//  Created by Xinhou Jiang on 22/12/16.
//  Copyright © 2016年 Xinhou Jiang. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (Account *)newAccountWithName:(NSString *)name andTime:(long long)logintime {
    Account *acc = [[Account alloc] init];
    acc.name = name;
    acc.loginTime = logintime;
    return acc;
}

@end
```

### UIViewController

```objc
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

@property(nonatomic, strong) IBOutlet UITextView *text;

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
```
