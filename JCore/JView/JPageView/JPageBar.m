//
//  JPageBar.m
//  JPage
//
//  Created by Hitter on 2018/8/7.
//  Copyright © 2018年 Hitter. All rights reserved.
//

#import "JPageBar.h"

// 设置滑动时候的误差值 - （避免回弹）
CGFloat miniErrorW = 0.f;

@implementation JPageBar {
    UIScrollView *_contentView;
    UIImageView *_indicatorView;
    UIButton    *_currentButton;
    UIView      *_separatorView;
    
    
    NSMutableArray <UIView *> *_titleViews;
    NSMutableArray *_titleWidths;
    NSMutableArray *_originTitleWidths; // 未加工的titleWidths(用来自适应宽度) TODO: 待使用
    
    CGPoint _startOffset;       // 滑动起始位置
    CGPoint _currentOffset;     // 正在滑动位置
    CGFloat _startX;            // indicator滑动起始位置
    CGFloat _endX;              // indicator滑动结束位置
    NSInteger _currentIndex;    // 滑动索引
    UIEdgeInsets _indicatorEdgeInsets;
    UIEdgeInsets _itemEdgeInsets;
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
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reloadData];
}

#pragma mark - <Public>

- (void)reloadData {
    
    /// 获取数据源个数
    NSInteger itemCount = [self.dataSource numberOfPagesInPageBar:self];
    
    /// 设置了指示器偏移
    if ([self.delegate respondsToSelector:@selector(edgeInsetOfIndicatorView)]) {
        _indicatorEdgeInsets = [self.delegate edgeInsetOfIndicatorView];
    }
    
    /// 设置了item偏移
    if ([self.delegate respondsToSelector:@selector(edgeInsetOfTitleViewItems)]) {
        _itemEdgeInsets = [self.delegate edgeInsetOfTitleViewItems];
    }
    
    /// 更新数据和界面
    for (int index = 0; index < itemCount; ++index) {
        
        // 修改宽度
        CGFloat newWidth = [self.dataSource pageBar:self widthOfBarInIndex:index];
        if (_titleWidths.count < itemCount) {
            [_originTitleWidths addObject:@(newWidth)];
            [_titleWidths addObject:@(newWidth + _itemEdgeInsets.left + _itemEdgeInsets.right)];
        } else {
            CGFloat originWidth = [_titleWidths[index] floatValue];
            if (originWidth != newWidth) {
                [_titleWidths replaceObjectAtIndex:index withObject:@(newWidth + _itemEdgeInsets.left + _itemEdgeInsets.right)];
                [_originTitleWidths replaceObjectAtIndex:index withObject:@(newWidth)];
            }
        }
        
        // 修改view
        UIView *newView = [self.dataSource pageBar:self viewAtIndex:index];
        newView.tag = index;
        if (_titleViews.count < itemCount) {
            [_contentView addSubview:newView];
            [_titleViews addObject:newView];
        } else {
            UIView *originView = _titleViews[index];
            if (![originView isEqual:newView]) {
                [originView removeFromSuperview];
                [_contentView addSubview:newView];
                [_titleViews replaceObjectAtIndex:index withObject:newView];
            }
        }
        
        // 是自定义view
        [newView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
//        if (self.isCustomItems) {
//            if (![newView isMemberOfClass:[UIButton class]] || [((UIButton *)newView) allTargets].count < 1) { // 非Button || 未实现点击方法
//                [newView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
//            }
//        } else {
//            [newView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
//        }
    }
    
    if (self.style == JPageIndicatorStyleNone) {
        _indicatorView.hidden = YES;
    }
    
    [self layoutSubviews];
}

- (void)didScrollWithOffset:(CGPoint)offset {
    _currentOffset = offset;
    switch (self.style) {
        case JPageIndicatorStyleAdaption:
            [self setupAdaption];
            break;
        case JPageIndicatorStyleInvariable:
            [self setupInvariable];
            break;
        case JPageIndicatorStyleShrink:
            [self setupShrink];
            break;
        default:
            break;
    }
}

- (void)startScrollWithOffset:(CGPoint)offset {
    _currentIndex = offset.x / (self.frame.size.width == 0 ? offset.x : self.frame.size.width);
    _startOffset = offset;
    
    // 设置初始位置
    _startX = 0.f;
    for (int index = 0; index < _currentIndex; ++index) {
        _startX += [_titleWidths[index] floatValue];
    }
    _endX = _startX;
    if (_titleWidths.count > _currentIndex + 1) {
        _endX += [_titleWidths[_currentIndex + 1] floatValue];
    }
}

- (void)endScrollWithOffset:(CGPoint)offset {
    _currentIndex = offset.x / (self.frame.size.width == 0 ? offset.x : self.frame.size.width);
    
    if (!self.isCustomItems) { // 自带的items修改文字属性
        if ([_titleViews[_currentIndex] isKindOfClass:[UIButton class]]) {
            if ([self.delegate respondsToSelector:@selector(titleAttributedInIndex:)]) {
                NSDictionary *attributedItems = [self.delegate titleAttributedInIndex:_currentIndex];
                // 设置未选中状态
                _currentButton.selected = NO;
                _currentButton.titleLabel.font = attributedItems[kFontAttributeName];
                
                ((UIButton *)(_titleViews[_currentIndex])).selected = YES;
                ((UIButton *)(_titleViews[_currentIndex])).titleLabel.font = attributedItems[kFontSelectedAttributeName];
                
                _currentButton = (UIButton *)(_titleViews[_currentIndex]);
            }
        }
    }
    
    // 计算的索引
    NSInteger index = _currentIndex == 0 ? _currentIndex : _currentIndex - 1;
    index = _currentIndex == _titleWidths.count - 1 ? _currentIndex : _currentIndex + 1;
    // 前_currentIndex项和
    CGFloat frontNum = [[[_titleWidths subarrayWithRange:NSMakeRange(0, index)] valueForKeyPath:@"@sum.floatValue"] floatValue];
    // 后_currentIndex项和
    CGFloat lastNum = [[[_titleWidths subarrayWithRange:NSMakeRange(_currentIndex, _titleWidths.count - index)] valueForKeyPath:@"@sum.floatValue"] floatValue];
    if (frontNum - miniErrorW > self.frame.size.width / 2 && lastNum - miniErrorW > self.frame.size.width / 2) { // 大于屏幕一半 可以滚到中间
        [_contentView setContentOffset:CGPointMake(_titleViews[_currentIndex].frame.origin.x - self.frame.size.width / 2 + _titleViews[_currentIndex].frame.size.width / 2, 0) animated:YES];
    } else {
        if (frontNum < self.frame.size.width / 2) {
            [_contentView setContentOffset:CGPointMake(-10, 0) animated:YES];
        } else {
            [_contentView setContentOffset:CGPointMake(_contentView.contentSize.width - self.frame.size.width, 0) animated:YES];
        }
    }
    
    ///
//    switch (self.style) {
//        case JPageIndicatorStyleAdaption: {
//
//        } break;
//        case JPageIndicatorStyleInvariable: {
//
//        } break;
//        case JPageIndicatorStyleShrink: {
//
//        } break;
//        default: break;
//    }
}

#pragma mark - <Functions>

- (void)setupData {
    _originTitleWidths = [NSMutableArray array];
    _titleViews  = [NSMutableArray array];
    _titleWidths = [NSMutableArray array];
    _currentIndex = 0;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    // 滚动view
    _contentView = [[UIScrollView alloc] init];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [_contentView setContentInset:UIEdgeInsetsMake(0, kPageBarMargin, 0, kPageBarMargin)];
    [self addSubview:_contentView];
    
    // 指示器
    _indicatorView = [[UIImageView alloc] init];
    _indicatorView.layer.cornerRadius = 1.5f;
    _indicatorView.backgroundColor = [UIColor redColor];
    [_contentView addSubview:_indicatorView];
    
    // 分割线
    _separatorView = [[UIView alloc] init];
    [self addSubview:_separatorView];
}

- (void)setupFrame {
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat totalW = [[_titleWidths valueForKeyPath:@"@sum.floatValue"] floatValue];
    
    __block CGFloat itemX = 0.f;
    [_titleViews enumerateObjectsUsingBlock:^(UIView *titleView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            CGFloat indicatorX = titleView.center.x - kPageBarIndicatorDefaultW / 2;
            CGFloat indicatorY = self.frame.size.height - kPageBarIndicatorDefaultH - self->_indicatorEdgeInsets.bottom;
            CGFloat indicatorW = kPageBarIndicatorDefaultW;
            CGFloat indicatorH = kPageBarIndicatorDefaultH;
            self->_indicatorView.frame = CGRectMake(indicatorX, indicatorY, indicatorW, indicatorH);
        }
        
        CGFloat itemY = self->_itemEdgeInsets.top;
        CGFloat itemW = self->_titleWidths.count > idx ? [self->_titleWidths[idx] floatValue] : kPageBarTitleDefalutW;
        CGFloat itemH = self->_indicatorView.frame.origin.y - self->_indicatorEdgeInsets.top - self->_itemEdgeInsets.bottom;
        titleView.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        itemX += itemW;
    }];
    [_contentView bringSubviewToFront:_indicatorView];
    
    _contentView.contentSize = CGSizeMake(totalW + 20.f, 0); // 20.f是左右间距
}

- (void)setupAdaption { // 自适应
    
}

- (void)setupInvariable { // 固定的
    
    CGFloat distance = 0.f; // 当前滑到下一个总距离
    CGFloat initialPosition = [_titleWidths[_currentIndex] floatValue] / 2; // 初始位置
    
    if (_currentIndex * self.frame.size.width < _startOffset.x || _currentIndex == 0) { // 左滑 <- contentOffset+
        // 边界计算 是否是最后一个
        if (_currentIndex + 1 >= _titleWidths.count) { // 最后一个
            distance = [_titleWidths.lastObject floatValue] / 2;
        } else {
            distance = ([_titleWidths[_currentIndex] floatValue] + [_titleWidths[_currentIndex + 1] floatValue]) / 2;
        }
    } else { // 右滑 -> contentOffset-
        // 边界计算 是否是第一个
        if (_currentIndex < 1) { // 第一个
            distance = [_titleWidths.firstObject floatValue] / 2;
        } else {
            distance = ([_titleWidths[_currentIndex] floatValue] + [_titleWidths[_currentIndex - 1] floatValue]) / 2;
        }
    }
    
    // 修改位置
    CGFloat w = distance * (_currentOffset.x - _currentIndex * self.frame.size.width) / self.frame.size.width + initialPosition;
    _indicatorView.frame = CGRectMake(_startX + w - _indicatorView.frame.size.width / 2, _indicatorView.frame.origin.y, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
}

- (void)setupShrink { // 收缩适应
    CGFloat w = _indicatorView.frame.size.width > [_titleWidths[0] floatValue] ?[_titleWidths[0] floatValue] : _indicatorView.frame.size.width + _startOffset.x + _currentOffset.x - _indicatorView.frame.size.width / 2;
    _indicatorView.frame = CGRectMake(_indicatorView.frame.origin.x, _indicatorView.frame.origin.y, w, _indicatorView.frame.size.height);
}

#pragma mark - <Events>

- (void)tapClick:(UITapGestureRecognizer *)ges {
    NSLog(@"UITapGestureRecognizer - tap %ld", ges.view.tag);
    [self.delegate pageBar:self didSeletedAtIndex:ges.view.tag];
}

- (void)titleClick:(UIButton *)sender {
    
}

- (void)leftClick {
    
}

- (void)rightClick {
    
}

#pragma mark - <Setter>

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    
    [_indicatorView setBackgroundColor:indicatorColor];
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

@end
