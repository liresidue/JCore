//
//  DismissAnimation.m
//  AliVideoDemo
//
//  Created by Hitter on 2018/10/31.
//  Copyright © 2018 Hitter. All rights reserved.
//

#import "DismissAnimation.h"

@implementation DismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //拿到前后的两个controller
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    //拿到Presenting的最终Frame
    CGRect finalFrame = CGRectOffset(initFrame, 0, screenBounds.size.height);

    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = finalFrame;
        toVc.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        BOOL complate = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:(!complate)];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {
}

@end
