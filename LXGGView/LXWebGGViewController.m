//
//  LXWebGGViewController.m
//  LXGGView
//
//  Created by 刘新新 on 2018/3/24.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import "LXWebGGViewController.h"
#import "LXGGView.h"
@interface LXWebGGViewController ()
@property(nonatomic,strong)LXGGView *ggView;

@end

@implementation LXWebGGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];

    self.ggView = [[LXGGView alloc]initWithFrame:CGRectMake(10, 100,kScreenW - 20 ,0)];
    self.ggView.isWebUrl  = YES;
    self.ggView.maxCount = 9;
    self.ggView.imageSize = CGSizeMake(90, 180);
    self.ggView.currentVc  = self;

    NSMutableArray *array =[NSMutableArray array];
    [array addObject:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1521889500&di=d82d9d90bb313b7fcbfc7aeaf54b0ff8&src=http://www.zhlzw.com/UploadFiles/Article_UploadFiles/201204/20120412123906588.jpg"];
    
    [array addObject:@"http://www.zhlzw.com/UploadFiles/Article_UploadFiles/201204/20120412123912727.jpg"];
    

 
    
    [array addObject:@"http://www.zhlzw.com/UploadFiles/Article_UploadFiles/201210/20121006203301121.jpg"];
    
    self.ggView.imageA = array;
    self.ggView.backgroundColor =[[UIColor hexStringToColor:@"000000"]colorWithAlphaComponent:0.5];
    [self.ggView beginLayout];

    [self.view addSubview:self.ggView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
