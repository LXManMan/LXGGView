//
//  NSObject+WLHud.h
//  WZElevator
//
//  Created by 刘新新 on 2018/3/8.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface NSObject (WLHud)

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)second;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view offset:(CGPoint)offset;
+(void)hideforView:(UIView *)view;
@end
