//
//  TransitionAnimator.m
//  Test
//
//  Created by Hitter on 2018/11/21.
//  Copyright © 2018 Hitter. All rights reserved.
//

#import "TransitionAnimator.h"
#import "SwipeUpInteractiveTransition.h"
#import "DismissAnimation.h"
#import "PresentedAnimation.h"

// 

@interface TransitionAnimator()

@property (nonatomic, strong) SwipeUpInteractiveTransition *toInteractive;

@end

@implementation TransitionAnimator

#pragma mark - <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentedAnimation alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DismissAnimation alloc] init];
}

/// 设置过场动画
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return (self.toInteractive.isInteracting ? self.toInteractive : nil);
}

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return self.toInteractive.interation ? self.toInteractive : nil;
//}

@end
