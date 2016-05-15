//
//  ViewController.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "ViewController.h"

#import "KCExtension.h"

@interface ViewController ()
@property (nonatomic, weak) UIView *v;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton *v = [UIButton new];
    v.frame = CGRectMake(100, 100, 100, 100);
    v.backgroundColor = [UIColor greenColor];
    [self.view addSubview:v];
    
    v.kc_badgeValue = @"999";
    
    self.v = v;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.v.kc_badgeValue = @"";
    
    [self.v kc_setBadgeValue:@"12" offset:CGPointMake(10, -10)];
}

@end
