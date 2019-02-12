//
//  JPageBar.h
//  JPage
//
//  Created by Hitter on 2018/8/7.
//  Copyright © 2018年 Hitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPageConstant.h"
@class JPageBar;

/// 数据源
@protocol JPageBarDataSource <NSObject, UITableViewDelegate>

@required
// controller的数量
- (NSInteger)numberOfPagesInPageBar:(JPageBar *)pageBar;

// 索引对应的控制器
- (nullable UIView *)pageBar:(JPageBar *)pageBar viewAtIndex:(NSInteger)index;
- (CGFloat)pageBar:(JPageBar *)pageBar widthOfBarInIndex:(NSInteger)index;
@end

/// 代理
@protocol JPageBarViewDelegate <NSObject>

@optional

/**
 选中索引

 @param pageBar JPageBar
 @param index 索引位置
 */
- (void)pageBar:(JPageBar *)pageBar didSeletedAtIndex:(NSInteger)index;

/**
 指示器上下左右间距
 
 @return UIEdgeInsets
 */
- (UIEdgeInsets)edgeInsetOfIndicatorView;

/**
 滚动栏选项的上下左右间距
 
 @return UIEdgeInsets
 */
- (UIEdgeInsets)edgeInsetOfTitleViewItems;

/**
 文字属性

 @param index 当前索引
 @return 索引对应的头部文字
 */
- (nullable NSDictionary<NSString *, id> *)titleAttributedInIndex:(NSInteger)index;

@end

@interface JPageBar : UIView

@property (weak, nonatomic) id<JPageBarDataSource> dataSource;
@property (weak, nonatomic) id<JPageBarViewDelegate> delegate;

// 结束滚动
- (void)endScrollWithOffset:(CGPoint)offset;
// 开始滚动
- (void)startScrollWithOffset:(CGPoint)offset;
// 正在滚动
- (void)didScrollWithOffset:(CGPoint)offset;

/**
 刷新数据
 */
- (void)reloadData;

// 设置索引条颜色(默认 : redColor)
@property (strong, nonatomic) UIColor *indicatorColor;
// 是否自适应宽度（设置为YES则indicatorEdgeInsets无效）
@property (assign, nonatomic, getter=isAutoAdaptive) BOOL autoAdaptive;
// 是否为JPage自定义items
@property (assign, nonatomic) BOOL isCustomItems;
// 滚动样式
@property (assign, nonatomic) JPageIndicatorStyle style;

@end
