//
//  MainViewController.m
//  TopPageView
//
//  Created by Hitter on 2019/1/24.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import "JViewController.h"
#import <objc/runtime.h>

#import "JView.h"

@interface MainViewController () <JPageViewDelegate, JPageViewDataSource>
@property (strong, nonatomic) JPageView *pageView;

@end

@implementation MainViewController

#pragma mark - <UITableViewDelegate>

#pragma mark - <Systems>

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.pageView];
}

- (NSInteger)numberOfPagesInPageView:(JPageView *)pageView {
    return 20;
}

- (UIViewController *)viewControllerInIndex:(NSInteger)index {
    UIViewController *vc = [[UIViewController alloc] init];
    if (index % 2 == 0) {
        vc.view.backgroundColor = [UIColor redColor];
    }
    return vc;
}

- (NSString *)pageView:(JPageView *)pageView titleForControllerInIndex:(NSInteger)index {
    if (index % 2 == 0) {
        return [NSString stringWithFormat:@"测试 - %ld", index];
    }
    return [NSString stringWithFormat:@"测试测试 - %ld", index];
}

- (UIEdgeInsets)edgeInsetOfIndicatorView {
    return UIEdgeInsetsMake(5.f, 0.f, 5.f, 0.f);
}

- (UIEdgeInsets)edgeInsetOfTitleViewItems {
    return UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
}

- (CGFloat)heightOfTitleView:(JPageView *)pageView {
    return 100.f;
}

- (NSDictionary<NSString *,id> *)pageView:(JPageView *)pageView titleAttributedInIndex:(NSInteger)index {
    // 设置按钮文字属性
    return @{kFontAttributeName : [UIFont systemFontOfSize:14.f],
             kFontSelectedAttributeName : [UIFont systemFontOfSize:16.f],
             kFontColorAttributeName : [UIColor blackColor],
             kFontColorSelectedAttributeName : [UIColor redColor],
             };
}

//- (UIView *)pageView:(JPageView *)pageView titleViewForControllerInIndex:(NSInteger)index {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor blueColor];
//    [button setTitle:@"这是按钮" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//
//- (CGFloat)pageView:(JPageView *)pageView widthOfTitleViewInIndex:(NSInteger)index {
//    return 60.f;
//}

- (void)click {
    NSLog(@"click - button");
}

- (void)click1 {
    NSLog(@"***************");
    [self.navigationController popViewControllerAnimated:YES];
}

- (JPageView *)pageView {
    if (!_pageView) {
        _pageView = [[JPageView alloc] init];
        _pageView.frame = self.view.bounds;
        _pageView.delegate = self;
        _pageView.dataSource = self;
    }
    return _pageView;
}
@end
