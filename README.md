# LXGGView

![image](https://github.com/liuxinixn/LXGGView/blob/master/%E9%80%89%E6%8B%A9%E7%85%A7%E7%89%87.gif)

```
使用方法：

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
```

```
介绍

@interface LXGGView : UIView
@property(nonatomic,strong)NSMutableArray *imageA;//必须是不可变数组（可传入，返回的是UIImage的数组）接受NSData, UIImage ,NSString的集合
@property(nonatomic,assign)NSInteger maxCount;//最多个数
@property(nonatomic,weak)UIViewController *currentVc;//

@property(nonatomic,assign)BOOL isWebUrl;//最多剩余图片个数
@property(nonatomic,assign)CGSize imageSize;

@property(nonatomic,assign)BOOL isSelect3rdPicker;//默认是原生的,可以选择TZlPicker

-(void)beginLayout;//开始布局


@property(nonatomic,assign)CGFloat totalH;
```
