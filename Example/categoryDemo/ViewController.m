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
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage kc_pureColorImageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"sdfs" style:UIBarButtonItemStylePlain target:self action:@selector(jump)];
//    
    //    self.kc_navgationBarBackgroundHidden = YES;
    
//    [self.imageView kc_setRoundedCoverWithBackgroundColor:self.view.backgroundColor cornerRadius:self.imageView.kc_width*0.3];
//    [self.imageView kc_setLayerCornerRadiusWithClips:self.imageView.kc_width * 0.2];
    //
//    self.imageView.kc_layerCornerRadiusWithClips = self.imageView.kc_width;
    
    [self.imageView kc_setTapBlock:^(UIView *view, UITapGestureRecognizer *tap) {
        
    }];
    
//    self.imageView.kc_badgeValue = @"1";
    
    UIVisualEffectView *blurEffectView = [UIVisualEffectView kc_blurEffectViewWithBlurEffectStyle:UIBlurEffectStyleExtraLight];
    [self.view addSubview:blurEffectView];
    
    blurEffectView.frame = CGRectMake(20, 200, 300, 88);
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"12313" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    btn.imageTitleSpacing = 10;
    btn.imagePosition = KCButtonImagePositionTop;
    btn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    btn.frame = CGRectMake(100, 100, 200, 200);
    
    [self.view addSubview:btn];
    
}

- (void)jump
{
    
    [self.navigationController pushViewController:[[self class] new] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
//    if (offsetY > 0) {
//        [self kc_setNavigationBarBackgroundHidden:NO animate:YES];
//    }else {
//        
//        [self kc_setNavigationBarBackgroundHidden:YES animate:YES];
//    }
    
    self.kc_navgationBarBackgroundAlpha = (offsetY + 64)/64;
    
}




@end
