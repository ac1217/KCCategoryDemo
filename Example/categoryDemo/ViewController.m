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

@property (weak, nonatomic) UIView *showView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"zyurl://TargetA/Action/type?name=zhangyu&age=10"];
    
    NSString *action = url.relativePath;
    NSString *target = url.host;
    
    NSString *query = url.query;
    
    NSLog(@"%@---%@---%@",target, action, query);
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.kc_navigationBarBackgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    
    
    self.kc_navigationBarHidden = arc4random_uniform(2);
    
    self.navigationController.kc_fullscreenInteractivePopGestureRecognizerEnabled = YES;
    
//    NSString *str = nil;
//    NSMutableArray *arrM = @[].mutableCopy;
//    [arrM addObject:str];
//    [arrM removeObject:nil];
//
//    [arrM insertObject:str atIndex:0];
//    
//    NSArray *arr = @[];
//
//    [arr arrayByAddingObject:nil];
//    
//    
//    NSMutableDictionary *dictM = @{}.mutableCopy;
//    
//    [dictM setObject:nil forKey:@"123"];
//    
//    [dictM removeObjectForKey:nil];
    
//    NSMutableSet *set = [NSMutableSet set];
//    NSLog(@"%@", [set class]);
    
//    [set removeObject:nil];
    
//    [set addObject:nil];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage kc_pureColorImageWithColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"sdfs" style:UIBarButtonItemStylePlain target:self action:@selector(jump)];
//    
    //    self.kc_navgationBarBackgroundHidden = YES;
    
//    [self.imageView kc_setRoundedCoverWithBackgroundColor:self.view.backgroundColor cornerRadius:self.imageView.kc_width*0.3];
//    [self.imageView kc_setLayerCornerRadiusWithClips:self.imageView.kc_width * 0.2];
    //
//    self.imageView.kc_layerCornerRadiusWithClips = self.imageView.kc_width;
    
//    [self.imageView kc_setTapBlock:^(UIView *view, UITapGestureRecognizer *tap) {
//
//    }];
    
//    self.imageView.kc_badgeValue = @"1";
    
//    UIVisualEffectView *blurEffectView = [UIVisualEffectView kc_blurEffectViewWithBlurEffectStyle:UIBlurEffectStyleExtraLight];
//    [self.view addSubview:blurEffectView];
//
//    blurEffectView.frame = CGRectMake(20, 200, 300, 88);
//
//    UIButton *btn = [UIButton new];
//    [btn setTitle:@"12313" forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
//    btn.kc_imageTitleSpacing = 10;
//    btn.kc_imagePosition = KCButtonImagePositionTop;
//    btn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
//    btn.frame = CGRectMake(100, 100, 200, 200);
//
//    [self.view addSubview:btn];
    
}

- (void)jump
{
    
    [self.navigationController pushViewController:[[self class] new] animated:YES];
}
- (IBAction)push:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)root:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    self.kc_navigationBarBackgroundAlpha = (offsetY + 64)/64;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sugar://openUserDetail?userID=12345"]];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sugar://openRecord"]];
    
    
//    NSString *date = [NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000];
//
//
//    NSInteger n = [date integerValue];
//
//    NSLog(@"date = %@, n = %zd", date, n);
    
    
}




@end
