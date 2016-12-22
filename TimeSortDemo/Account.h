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
