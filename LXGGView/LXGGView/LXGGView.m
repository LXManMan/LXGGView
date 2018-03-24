
//
//  LXGGView.m
//  LXGGView
//
//  Created by 刘新新 on 2018/3/24.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import "LXGGView.h"
#import "SDPhotoBrowser.h"
#import "TZImagePickerController.h"
#define COL_COUNT 3
typedef enum : NSInteger {
    
    LXDataUrl,
    LXDataImage
}LXGGDataType;
@interface  LXGGView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,SDPhotoBrowserDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,strong)UIImageView *eidtImageView;//正在编辑的imageView
@property(nonatomic,assign)BOOL isEidtImage;//是否在编辑图片


@end
@implementation LXGGView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}


-(void)beginLayout{
    
    if (!self.imageA || self.imageA.count <=0) {
        
        if (self.isWebUrl) {
            self.height = 0;
            return;
        }else{
            
            if (!self.imageA) {
                self.imageA = [NSMutableArray array];
            }
            
        }
        
    }
    
    //如果是data提前转换
    [self.imageA enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSData class]]) {
            [self.imageA replaceObjectAtIndex:idx withObject:[UIImage imageWithData:obj]];
        }
    }];
    
    
    [self.imageA enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //大于最大个数，停止
        if (idx > (self.maxCount-1)) {
            
            *stop = YES;
        }
        //创建图片
        UIImageView *imageView = [self createImageView];
        
        if ([obj isKindOfClass:[UIImage class]]) {
            imageView.image = obj;
            
        }
        
        if ([obj isKindOfClass:[NSData class]]) {
            imageView.image = [UIImage imageWithData:obj];
            
            
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
            
            imageView.tag  = idx;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShow:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tapGesture];
            
            
        }
        
        if (!self.isWebUrl) {
            imageView.userInteractionEnabled = YES;
            
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changImage:)];
            
            [imageView addGestureRecognizer:tapGesture];
        }
        
        [self addSubview:imageView];
        
        
    }];
    
     //是否有add按钮
     if (!self.isWebUrl) {
         
         if (self.subviews.count < self.maxCount) {
            
             UIImageView *imageView = [self createImageView];
             [self addSubview:imageView];
             
             
            UIImageView *addImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_picture"]];
             addImageView.userInteractionEnabled = YES;
             addImageView.contentMode = UIViewContentModeScaleAspectFit;
             addImageView.center = CGPointMake(self.imageSize.width/2, self.imageSize.height/2);
             
             
             UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic)];
             
             [addImageView addGestureRecognizer:tapGesture];
            [imageView addSubview:addImageView];
        }
         
     }
     
    
    
    [self dealImageA];
    
}
-(void)tapShow:(UITapGestureRecognizer *)tap{
    
    UIImageView  *imageView= (UIImageView *)tap.view;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.imageA.count; // 图片总数
    browser.currentImageIndex = imageView.tag;
    browser.delegate = self;
    [browser show];
    
}
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView  *imageView = self.subviews[index];
    
    return imageView.image;
}

-(void)addPic{
    
    if (self.isSelect3rdPicker) {
        
        TZImagePickerController *pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:self.maxCount - self.imageA.count delegate:self];
//        pickerController.sortAscendingByModificationDate = NO;
      
        WS(weakSelf);
        [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray *assets, BOOL isSelectOriginalPhoto){
            
            if (photo.count) {
              
                [weakSelf addNewImages:photo];
                
                
            }
        }];
        [self.currentVc presentViewController:pickerController animated:YES completion:nil];
        
    }else{
        [self showAlert];
    }
    
}

//替换图片
-(void)changeImageForIndex:(NSUInteger)index image:(UIImage *)changeImage{
    
    [self.imageA replaceObjectAtIndex:index withObject:changeImage];
}
-(void)addNewImage:(UIImage *)newImage{
    
    [self.imageA insertObject:newImage atIndex:0];
    UIImageView *imageView = [self createImageView];
    imageView.image = newImage;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changImage:)];
    
    [imageView addGestureRecognizer:tapGesture];
    [self insertSubview:imageView atIndex:0];
    
    if (self.imageA.count  == self.maxCount) {
        UIImageView *addIcon = self.subviews[self.maxCount];
        
        [addIcon removeFromSuperview];
        
    }
    [self dealImageA];
    
}
//添加多张图片--
-(void)addNewImages:(NSArray *)newImages{
    
    //默认多张图片选择顺序是按照用户选择顺序，所以这里进行反序，因为后面把刚添加的index 置为0；
     NSArray* images = [[newImages reverseObjectEnumerator] allObjects];
    [images enumerateObjectsUsingBlock:^(UIImage * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageA insertObject:obj atIndex:0];
        UIImageView *imageView = [self createImageView];
        imageView.image = obj;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changImage:)];
        [imageView addGestureRecognizer:tapGesture];
        [self insertSubview:imageView atIndex:0];
        
    }];
    
    if (self.imageA.count  == self.maxCount) {
        UIImageView *addIcon = self.subviews[self.maxCount];
        
        [addIcon removeFromSuperview];
        
    }
    [self dealImageA];
}
-(void)changImage:(UITapGestureRecognizer *)tap{
    
    self.isEidtImage = YES;
    self.eidtImageView = (UIImageView *)tap.view;
    if (self.isSelect3rdPicker) {
        
      
        TZImagePickerController *pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:self.maxCount - self.imageA.count delegate:self];
        
        WS(weakSelf);
        [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray *assets, BOOL isSelectOriginalPhoto){
            
            
         
            if (photo.count) {
                
                UIImage *image =  photo[0];
                weakSelf.eidtImageView.image = image;
                
                NSUInteger index = [weakSelf.subviews indexOfObject:weakSelf.eidtImageView];
                [weakSelf changeImageForIndex:index image:image];
                weakSelf.isEidtImage = NO;
                weakSelf.eidtImageView = nil;
                
                
            }
        }];
        [self.currentVc presentViewController:pickerController animated:YES completion:nil];
        
    }else{
    
       [self showAlert];
    }
}
-(void)showAlert{
    
    UIAlertController *headImageChangeActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            imagePicker.navigationBar.translucent = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.currentVc.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }else{
            [NSObject showMessag:@"暂不支持相机" toView:kKeyWindow afterDelay:1];
        }
        
        
    }];
    
    [headImageChangeActionSheet addAction:cameraAction];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.navigationBar.translucent = NO;
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.currentVc.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }
        
        
    }];
    
    [headImageChangeActionSheet addAction:albumAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isEidtImage = NO;
        self.eidtImageView = nil;
    }];
    
    
    [headImageChangeActionSheet addAction:cancelAction];
    
    [self.currentVc.navigationController presentViewController:headImageChangeActionSheet animated:YES completion:nil];
    
}




#pragma mark --- <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image) {
        
        
        if (self.isEidtImage) {
            
            self.eidtImageView.image = image;
            
            NSUInteger index = [self.subviews indexOfObject:self.eidtImageView];
            [self changeImageForIndex:index image:image];
            self.isEidtImage = NO;
            self.eidtImageView = nil;
            
        }else{
            [self addNewImage:image];
        }
        
        
    }
    
    
    
}
-(UIImageView *)createImageView{
    
    //创建图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor =[UIColor hexStringToColor:@"F1F1F1"];
    imageView.contentMode =UIViewContentModeScaleAspectFill;
    [imageView setFTCornerdious:4];
    return imageView;
}

//处理
-(void)dealImageA{
    
    
    CGFloat imageW = self.imageSize.width;
    CGFloat imageH = self.imageSize.height;
    [self.subviews enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        // 图片所在行
        NSInteger row = idx / COL_COUNT;
        // 图片所在列
        NSInteger col = idx % COL_COUNT;
        // 间距
        CGFloat margin = (self.width - (self.imageSize.width * COL_COUNT)) / (COL_COUNT + 1);
        //        CGFloat margin = 10;
        // PointX
        CGFloat picX = margin + (imageW + margin) * col;
        // PointY
        CGFloat picY = margin + (imageH + margin) * row;
        
        // 图片的frame
        obj.frame = CGRectMake(picX, picY, imageW, imageH);
        
        if (idx == self.subviews.count -1) {
            
            self.totalH = obj.bottom + margin;
            
            self.height = self.totalH ;
            
            NSLog(@"%.2f",self.totalH);
        }
        
   
    }];

    
}

@end
