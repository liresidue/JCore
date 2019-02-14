//
//  JTestViewController.m
//  JCore_Example
//
//  Created by Hitter on 2019/2/14.
//  Copyright © 2019 acct<blob>=<NULL>. All rights reserved.
//

#import "JTestViewController.h"

@interface JTestViewController ()

@end

@implementation JTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试控制器";
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 200, 200);
    [button setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:button];
}

- (void)backClick {
    for (UIView *view = self.view; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController *)nextResponder).navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIView *view = self.view; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            JTestViewController *vc = [[JTestViewController alloc] init];
            [((UIViewController *)nextResponder).navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

@end
