//
//  MyDesignMainView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignMainView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation MyDesignMainView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 列表视图
    self.collectionView = [[MyDesignCollectionView alloc] initWithFrame:self.bounds];
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    // 对比按钮
    self.compareButton = [[CompareButtonView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 100, 60, 60)];
    __weak typeof(self) weakSelf = self;
    self.compareButton.compareButtonClickBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(compareButtonDidClick)]) {
            [strongSelf.delegate compareButtonDidClick];
        }
    };
    [self addSubview:self.compareButton];
}

- (void)updateModelList:(NSArray<MyDesignModel *> *)modelList {
    self.collectionView.modelList = modelList;
}

- (void)updateCompareButtonVisibility:(BOOL)show {
    [self.compareButton showButton:show animated:YES];
}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
}

#pragma mark - MyDesignCollectionViewDelegate
- (void)collectionViewDidSelectItemAtIndex:(NSInteger)index {
    // 由控制器处理
}

- (void)collectionViewDidLongPressItemAtIndex:(NSInteger)index {
    // 由控制器处理
}

- (void)collectionViewDidScroll:(CGFloat)offset {
    [self.compareButton updateHiddenStateWithScrollOffset:offset];
}

@end
