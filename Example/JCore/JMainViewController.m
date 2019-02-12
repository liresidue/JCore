//
//  JViewController.m
//  JCore
//
//  Created by Hitter on 02/12/2019.
//  Copyright (c) 2019 Hitter. All rights reserved.
//

#import "JMainViewController.h"
#import "JViewController.h"

@interface JMainViewController ()

@end

@implementation JMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    JViewController *vc = [[JViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
