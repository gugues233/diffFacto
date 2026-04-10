//
//  MyDesignCollectionView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignCollectionView.h"
#import "MyDesignItemCell.h"

#define kItemSpacing 15
#define kLineSpacing 15
#define kSectionInset UIEdgeInsetsMake(15, 15, 15, 15)

@implementation MyDesignCollectionView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = kItemSpacing;
    layout.minimumLineSpacing = kLineSpacing;
    layout.sectionInset = kSectionInset;
    
    CGFloat itemWidth = (self.bounds.size.width - kSectionInset.left - kSectionInset.right - kItemSpacing) / 2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[MyDesignItemCell class] forCellWithReuseIdentifier:@"MyDesignItemCell"];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    longPress.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:longPress];
    
    [self addSubview:self.collectionView];
}

- (void)setModelList:(NSArray<MyDesignModel *> *)modelList {
    _modelList = modelList;
    [self.collectionView reloadData];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyDesignItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyDesignItemCell" forIndexPath:indexPath];
    cell.model = self.modelList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionViewDidSelectItemAtIndex:)]) {
        [self.delegate collectionViewDidSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(collectionViewDidScroll:)]) {
        [self.delegate collectionViewDidScroll:scrollView.contentOffset.y];
    }
}

#pragma mark - Long Press Handle
- (void)longPressHandle:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath && [self.delegate respondsToSelector:@selector(collectionViewDidLongPressItemAtIndex:)]) {
            [self.delegate collectionViewDidLongPressItemAtIndex:indexPath.item];
        }
    }
}

@end
