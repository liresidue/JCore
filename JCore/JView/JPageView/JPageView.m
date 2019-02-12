//
//  JPageView.m
//  JPage
//
//  Created by Hitter on 2018/7/24.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import "JPageView.h"
#import "JPageBar.h"

@interface JPageView() <JPageBarDataSource, JPageBarViewDelegate>
@end

@implementation JPageView {
    JPageBar     *_pageBar;
    UIScrollView *_contentView;
    
    NSMutableArray *_controllers;
    NSDictionary<NSString *, id> *_attributedItems;
    
    NSInteger _totalCount;   // 全部内容页数
    CGFloat _titleViewHeight;
}

#pragma mark - <Systems>

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupData];
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFrame];
    
    // TODO: 寻找更适合放置位置，默认选中第一个
    [self selectItemAtIndex:0 animated:NO];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self reloadData];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(pageView:didScrollContentOffset:)]) {
        [self.delegate pageView:self didScrollContentOffset:scrollView.contentOffset];
    }
    [_pageBar didScrollWithOffset:scrollView.contentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pageBar startScrollWithOffset:scrollView.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pageBar endScrollWithOffset:scrollView.contentOffset];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [_pageBar endScrollWithOffset:scrollView.contentOffset];
    
    if ([self.dataSource respondsToSelector:@selector(pageView:titleForControllerInIndex:)] && ![self.dataSource respondsToSelector:@selector(pageView:titleViewForControllerInIndex:)]) {
        //
    }

    if (([self.dataSource respondsToSelector:@selector(pageView:titleViewForControllerInIndex:)] || [self.dataSource respondsToSelector:@selector(pageView:titleForControllerInIndex:)])
        && [self.delegate respondsToSelector:@selector(pageView:didEndDisplayingHeaderView:atIndex:)]) {
        //
    }
}

#pragma mark - <JPageBarDataSource>

- (NSInteger)numberOfPagesInPageBar:(JPageBar *)pageBar {
    return _controllers.count;
}

- (UIView *)pageBar:(JPageBar *)pageBar viewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageView:titleViewForControllerInIndex:)]) {
        pageBar.isCustomItems = YES;
        return [self.dataSource pageView:self titleViewForControllerInIndex:index];
    }
    
    if ([self.dataSource respondsToSelector:@selector(pageView:titleForControllerInIndex:)]) {
        pageBar.isCustomItems = NO;
        
        // 添加默认按钮
        UIButton *barItem = [[UIButton alloc] init];
        barItem.tag = index;
        barItem.titleLabel.numberOfLines    = 1;
        barItem.titleLabel.lineBreakMode    = NSLineBreakByClipping;
        barItem.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
        barItem.contentVerticalAlignment    = UIControlContentVerticalAlignmentBottom;;
        [barItem addTarget:self action:@selector(titleViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.dataSource respondsToSelector:@selector(pageView:titleAttributedInIndex:)]) {
            _attributedItems = [self.dataSource pageView:self titleAttributedInIndex:index];
        }
        // 设置文字属性
        [barItem setBackgroundColor:_attributedItems[kBackgroundColorAttributeName]];
        [barItem setTitleColor:_attributedItems[kFontColorAttributeName] forState:UIControlStateNormal];
        [barItem setTitleColor:_attributedItems[kFontColorSelectedAttributeName] forState:UIControlStateSelected];
        [barItem.titleLabel setFont:_attributedItems[kFontAttributeName]];
        // 默认文字
        [barItem setTitle:[NSString stringWithFormat:@"第%ld页", (long)index] forState:UIControlStateNormal];
        
        // 自定义标题
        [barItem setTitle:[self.dataSource pageView:self titleForControllerInIndex:index] forState:UIControlStateNormal];
        return barItem;
    }
    
    return [[UIButton alloc] init];
}

// 实现widthOfTitleViewInIndex代理 则优先使用 给定宽度
- (CGFloat)pageBar:(JPageBar *)pageBar widthOfBarInIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageView:widthOfTitleViewInIndex:)]) {
        return [self.dataSource pageView:self widthOfTitleViewInIndex:index];
    }
    if ([self.dataSource respondsToSelector:@selector(pageView:titleForControllerInIndex:)]) {
        NSString *newTitle = [self.dataSource pageView:self titleForControllerInIndex:index];
        if ([self.dataSource respondsToSelector:@selector(pageView:titleAttributedInIndex:)]) {
            _attributedItems = [self.dataSource pageView:self titleAttributedInIndex:index];
        }
        
        NSDictionary *attributes = @{NSFontAttributeName: _attributedItems[kFontAttributeName]};
        CGFloat textW = ceil([newTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil].size.width);
        return textW;
    }
    return 60.f;
}

#pragma mark - <JPageViewDelegate>

- (void)pageBar:(JPageBar *)pageBar didSeletedAtIndex:(NSInteger)index {
    // 移动位置
    [_pageBar startScrollWithOffset:_contentView.contentOffset];
    [_contentView setContentOffset:CGPointMake(self.frame.size.width * index, 0) animated:YES];
    
    // 点击索引对应的头部
    if ([self.delegate respondsToSelector:@selector(pageView:didSeletedAtIndex:)]) {
        [self.delegate pageView:self didSeletedAtIndex:index];
    } else {
        NSLog(@"----------");
    }
}

- (UIEdgeInsets)edgeInsetOfIndicatorView {
    if ([self.delegate respondsToSelector:@selector(edgeInsetOfIndicatorView)]) return [self.delegate edgeInsetOfIndicatorView];
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UIEdgeInsets)edgeInsetOfTitleViewItems {
    if ([self.delegate respondsToSelector:@selector(edgeInsetOfTitleViewItems)]) return [self.delegate edgeInsetOfTitleViewItems];
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (nullable NSDictionary<NSString *, id> *)titleAttributedInIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageView:titleAttributedInIndex:)]) {
        return [self.dataSource pageView:self titleAttributedInIndex:index];
    }
    return _attributedItems;
}

#pragma mark - <Public>

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (_totalCount > 0) {
        [_contentView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:animated];
        if (!animated) { // 滑动到指定位置不会触发滑动事件 给定一个滑动动画触发事件
            [_contentView setContentOffset:CGPointMake(index * self.frame.size.width + 1.f, 0) animated:YES];
            [_contentView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:NO];
        }
        [_pageBar startScrollWithOffset:_contentView.contentOffset];
    }
}

- (void)reloadData {
    /// 总个数
    _totalCount = [self.dataSource numberOfPagesInPageView:self];
    
    /// 更新主界面
    for (int index = 0; index < _totalCount; ++index) {
        // 1、获取当前索引的view
        UIViewController *newSubViewController = [self.dataSource viewControllerInIndex:index];
        if (_controllers.count < _totalCount) {
            // 2、更新界面
            [_contentView addSubview:newSubViewController.view];
            // 3、更新数据
            [_controllers addObject:newSubViewController];
        } else {
            UIViewController *originSubViewController = _controllers[index];
            if (![newSubViewController isEqual:originSubViewController]) { // 非同一个subView 移除旧的 -> 添加新的
                // 2、更新界面
                [originSubViewController.view removeFromSuperview];
                [_contentView addSubview:newSubViewController.view];
                // 3、更新数据
                [_controllers replaceObjectAtIndex:index withObject:newSubViewController];
            }
        }
    }
    
    /// 设置自定义高度
    if ([self.dataSource respondsToSelector:@selector(heightOfTitleView:)]) {
        _titleViewHeight = [self.dataSource heightOfTitleView:self];
    }
    
    [_pageBar reloadData];
}

#pragma mark - <Events>

- (void)titleViewDidClick:(UIButton *)sender {
    [_pageBar startScrollWithOffset:_contentView.contentOffset];
    [_contentView setContentOffset:CGPointMake(self.frame.size.width * sender.tag, 0) animated:YES];
}

#pragma mark - <Functions>

- (void)setupData {
    _controllers = [NSMutableArray array];
    _totalCount  = 0;
    _titleViewHeight = 44.f;
    
    // 设置默认参数
    _attributedItems = @{
                         kBackgroundColorAttributeName: [UIColor whiteColor],           // 背景颜色
                         kFontSelectedAttributeName: [UIFont systemFontOfSize:14.f],    // 文字字体大小
                         kFontAttributeName: [UIFont systemFontOfSize:18.f],            // 选中字体大小
                         kFontColorAttributeName: [UIColor lightGrayColor],             // 文字颜色
                         kFontColorSelectedAttributeName: [UIColor blackColor],         // 选中文字颜色
                         };
}

- (void)setupView {
    _pageBar = [[JPageBar alloc] init];
    _pageBar.dataSource = self;
    _pageBar.delegate   = self;
    [self addSubview:_pageBar];
    
    _contentView = [[UIScrollView alloc] init];
    _contentView.pagingEnabled  = YES;
    _contentView.delegate       = self;
    [self addSubview:_contentView];
}

- (void)setupFrame {
    _pageBar.frame = CGRectMake(0, 0, self.bounds.size.width, _titleViewHeight);
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_pageBar.frame), self.bounds.size.width, self.bounds.size.height - _titleViewHeight);
    [_controllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(idx * self->_contentView.frame.size.width, 0, self->_contentView.frame.size.width, self->_contentView.frame.size.height);
    }];
    _contentView.contentSize = CGSizeMake(self.bounds.size.width * _totalCount, 0);
}


@end
