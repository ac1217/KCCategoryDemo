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
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) UIView *v;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.textView.kc_placeholder = @"hahahahah";
    self.textView.text = @"jjjjj";
    self.textView.font = [UIFont systemFontOfSize:22];
    UILabel *v = [UILabel new];
    v.layer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view addSubview:v];
    
    v.frame = CGRectMake(100, 100, 100, 100);
    v.kc_badgeValue = @"999";
    
    self.v = v;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.v.kc_badgeValue = @"11";
    
    
}

@end
