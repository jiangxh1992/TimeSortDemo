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
