//
//  ViewController.m
//  LXGGView
//
//  Created by 刘新新 on 2018/3/24.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import "ViewController.h"
#import "LXGGViewController.h"
#import "LXWebGGViewController.h"
#import "LXGGView2Controller.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)url:(id)sender {
    LXWebGGViewController *rightListVc =[[LXWebGGViewController alloc]init];
    [self.navigationController pushViewController:rightListVc animated:YES];
}

- (IBAction)image:(id)sender {
    
    LXGGViewController *rightListVc =[[LXGGViewController alloc]init];
    [self.navigationController pushViewController:rightListVc animated:YES];
}
- (IBAction)rd:(id)sender {
    LXGGView2Controller *rightListVc =[[LXGGView2Controller alloc]init];
    [self.navigationController pushViewController:rightListVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
