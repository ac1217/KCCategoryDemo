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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"sdfs" style:UIBarButtonItemStylePlain target:self action:@selector(jump)];
    
    self.kc_navgationBarBackgroundHidden = YES;
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
