//
//  LXGGView.h
//  LXGGView
//
//  Created by 刘新新 on 2018/3/24.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXGGView : UIView
@property(nonatomic,strong)NSMutableArray *imageA;//必须是不可变数组（可传入，返回的是UIImage的数组）接受NSData, UIImage ,NSString的集合
@property(nonatomic,assign)NSInteger maxCount;//最多个数
@property(nonatomic,weak)UIViewController *currentVc;//

@property(nonatomic,assign)BOOL isWebUrl;//最多剩余图片个数
@property(nonatomic,assign)CGSize imageSize;

@property(nonatomic,assign)BOOL isSelect3rdPicker;//默认是原生的,可以选择TZlPicker

-(void)beginLayout;//开始布局


@property(nonatomic,assign)CGFloat totalH;
@end
