//
//  LXGGViewController.m
//  LXGGView
//
//  Created by 刘新新 on 2018/3/24.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import "LXGGViewController.h"
#import "LXGGView.h"
@interface LXGGViewController ()
@property(nonatomic,strong)LXGGView *ggView;
@end

@implementation LXGGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.navigationItem.title = @"使用系统的图片选择器";
    
    self.navigationItem.rightBarButtonItem  =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
    self.ggView = [[LXGGView alloc]initWithFrame:CGRectMake(10, 70,kScreenW - 20 ,0)];
    self.ggView.isWebUrl  = NO;
    self.ggView.maxCount = 9;
    self.ggView.isSelect3rdPicker  = NO;

    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"ggView"];
    if (array && array.count >0) {
           self.ggView.imageA = [NSMutableArray arrayWithArray:array] ;
    }
 
    self.ggView.imageSize = CGSizeMake(90, 180);
    self.ggView.currentVc  = self;
    
    self.ggView.backgroundColor =[[UIColor hexStringToColor:@"000000"]colorWithAlphaComponent:0.5];
    
    [self.ggView beginLayout];
    [self.view addSubview:self.ggView];
  
}
-(void)saveAction{
    
    NSMutableArray *dataA= [NSMutableArray array];
    [self.ggView.imageA enumerateObjectsUsingBlock:^(UIImage * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj) {
            NSData *data= UIImageJPEGRepresentation(obj, 0.1);
            [dataA addObject:data];
            
        }
       
    }];
    
    [[NSUserDefaults standardUserDefaults]setObject:dataA forKey:@"ggView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
