//
//  PresentedAnimation.m
//  AliVideoDemo
//
//  Created by Hitter on 2018/10/31.
//  Copyright © 2018 Hitter. All rights reserved.
//

#import "PresentedAnimation.h"

@implementation PresentedAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //拿到前后的两个controller
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到Presenting的最终Frame
    CGRect finalFrameForVc = [transitionContext finalFrameForViewController:toVc];
    //拿到转换的容器view
    UIView *containerView = [transitionContext containerView];
    CGRect bounds = [UIScreen mainScreen].bounds;
    toVc.view.frame = CGRectOffset(finalFrameForVc, 0, bounds.size.height);
    [containerView addSubview:toVc.view];
    [containerView sendSubviewToBack:fromVc.view];
    
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVc.view.alpha = 0.5;
        toVc.view.frame = finalFrameForVc;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {
}

@end
