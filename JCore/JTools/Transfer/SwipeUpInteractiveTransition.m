//
//  SwipeUpInteractiveTransition.m
//  AliVideoDemo
//
//  Created by Hitter on 2018/10/31.
//  Copyright © 2018 Hitter. All rights reserved.
//

#import "SwipeUpInteractiveTransition.h"

@implementation SwipeUpInteractiveTransition

- (instancetype)init:(UIViewController *)vc {
    if (self = [super init]) {
        self.vc = vc;
    }
    return self;
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: { // 手势开始
            _isInteracting = YES;
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged: { // 手势改变
            CGFloat fraction = (translation.y / 400);
            fraction = fmin(fmaxf(fraction, 0.0), 1.0);
            _shouldComplete = fraction > 0.5;
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded: { // 手势结束
            _isInteracting = NO;
            if (!_shouldComplete || gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default: break;
    }
}

- (void)setVc:(UIViewController *)vc {
    _vc = vc;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandler:)];
    [vc.view addGestureRecognizer:pan];
}

@end
