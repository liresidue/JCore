//
//  JFloatedViewController.m
//  TopPageView
//
//  Created by Hitter on 2019/1/30.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import "JFloatedViewController.h"
#import "JFloatedViewCell.h"

@interface JFloatedViewController() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation JFloatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.bounds;
    [self.collectionView registerClass:[JFloatedViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JFloatedViewCell class])];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFloatedViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JFloatedViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

// 在开始移动时会调用此代理方法，
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

// 在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    /**
     *sourceIndexPath 原始数据 indexpath
     * destinationIndexPath 移动到目标数据的 indexPath
     */
    
}

#pragma mark - <Getter>

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(50.f, 50.f);
        _flowLayout.minimumInteritemSpacing = 5.f;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
