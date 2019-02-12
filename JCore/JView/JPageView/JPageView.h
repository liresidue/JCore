//
//  JPageView.h
//  JPage
//
//  Created by Hitter on 2018/7/24.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPageConstant.h"
@class JPageView;
@class JPageBar;


typedef enum : NSUInteger {
    JPageViewTypeNormal,
    JPageViewTypeAverage,
    JPageViewTypeCenter,
} JPageViewType;

@protocol JPageViewDataSource <NSObject>

@required
/**
 设置控制器数量

 @param pageView JPageView
 @return 控制器数量
 */
- (NSInteger)numberOfPagesInPageView:(JPageView *)pageView;

/**
 设置索引对应的控制器

 @param index 索引值
 @return 控制器
 */
- (nullable UIViewController *)viewControllerInIndex:(NSInteger)index;

@optional

/**
 controller对应的头部view（自定义）

 @param pageView JPageView
 @param index 当前索引
 @return 索引对应的头部view
 */
- (UIView *)pageView:(JPageView *)pageView titleViewForControllerInIndex:(NSInteger)index;

/**
 controller自定义头部view的宽度（默认全屏宽度）自定义头部控件实现此方法来确定宽度
 
 @param pageView JPageView
 @param index 当前索引
 @return 索引对应的头部view的宽度
 */
- (CGFloat)pageView:(JPageView *)pageView widthOfTitleViewInIndex:(NSInteger)index;

/**
 controller对应的文字，自定义view无效
 
 @param pageView JPageView
 @param index 当前索引
 @return 索引对应的头部文字
 */
- (nullable NSString *)pageView:(JPageView *)pageView titleForControllerInIndex:(NSInteger)index;

/**
 controller对应的文字属性，Key参考JPageConstant，自定义view无效，只影响自带的title
 
 @param pageView JPageView
 @param index 当前索引
 @return 索引对应的头部文字
 */
- (nullable NSDictionary<NSString *, id> *)pageView:(JPageView *)pageView titleAttributedInIndex:(NSInteger)index;

/**
 头部View对应的高度（统一设置默认44.f）

 @param pageView JPageView
 @return titleView的高度
 */
- (CGFloat)heightOfTitleView:(JPageView *)pageView;

@end

@protocol JPageViewDelegate <NSObject>

@optional

/**
 滚动栏指示器上下左右间距

 @return UIEdgeInsets
 */
- (UIEdgeInsets)edgeInsetOfIndicatorView;

/**
 滚动栏选项的上下左右间距
 
 @return UIEdgeInsets
 */
- (UIEdgeInsets)edgeInsetOfTitleViewItems;

// 滚动栏当前选中索引
- (void)pageView:(JPageView *)pageView didSeletedAtIndex:(NSInteger)index;

// 滑动时的偏移量（可以计算滑动比例对文字 进行缩放）
- (void)pageView:(JPageView *)pageView didScrollContentOffset:(CGPoint)contentOffset;

- (void)pageView:(JPageView *)pageView didEndDisplayingHeaderView:(UIView *)headerView atIndex:(NSInteger)index;
- (void)pageView:(JPageView *)pageView willDisplayingHeaderView:(UIView *)headerView atIndex:(NSInteger)index;

// 将要显示index位置对应的控制器
- (void)pageView:(JPageView *)pageView willDisplayViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

// index位置对应的控制器已经隐藏
- (void)pageView:(JPageView *)pageView didEndDisplayingViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

@end

@interface JPageView : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) id<JPageViewDelegate> delegate;
@property (weak, nonatomic) id<JPageViewDataSource> dataSource;

/**
 自定义头部滚动条左边view
 */
@property (strong, nonatomic) UIView *leftCustomView;

/**
 自定义头部滚动条右边view
 */
@property (strong, nonatomic) UIView *rightCustomView;

/**
 刷新数据
 */
- (void)reloadData;

/**
 选中某一个item（滚动到指定位置：scrollPosition:(UICollectionViewScrollPosition)scrollPosition）

 @param index 索引位置
 @param animated 是否添加动画
 */
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;
@end
