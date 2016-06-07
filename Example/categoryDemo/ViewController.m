//
//  ViewController.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "ViewController.h"

#import "KCCategory.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
////    self.view.backgroundColor = [UIColor redColor]
    
    [self.imageView.image kc_blurImageWithRatio:0.1 competion:^(UIImage *img) {
       
        self.imageView.image = img;
        
    }];
    
//    [self.imageView kc_blurEffectWithStyle:UIBlurEffectStyleDark];
}




@end
