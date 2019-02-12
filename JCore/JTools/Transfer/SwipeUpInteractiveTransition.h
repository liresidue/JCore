//
//  SwipeUpInteractiveTransition.h
//  AliVideoDemo
//
//  Created by Hitter on 2018/10/31.
//  Copyright © 2018 Hitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, assign) BOOL isInteracting;
@property (nonatomic, assign) BOOL shouldComplete;

- (instancetype)init:(UIViewController *)vc;

@end
