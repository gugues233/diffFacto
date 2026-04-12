//
//  DesignStudioMainView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioMainView.h"
#import "DesignStudioItemCell.h"

@implementation DesignStudioMainView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setupCollectionView];
        [self setupRefreshControl];
    }
    return self;
}

- (void)setupCollectionView {
    DesignStudioWaterfallLayout *layout = [[DesignStudioWaterfallLayout alloc] init];
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[DesignStudioItemCell class] forCellWithReuseIdentifier:@"DesignStudioItemCell"];
    [self addSubview:self.collectionView];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshHandle) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

- (void)refreshHandle {
    if ([self.delegate respondsToSelector:@selector(didPullToRefresh)]) {
        [self.delegate didPullToRefresh];
    }
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DesignStudioItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DesignStudioItemCell" forIndexPath:indexPath];
    cell.model = self.modelList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - DesignStudioWaterfallLayoutDelegate
- (CGFloat)waterfallLayoutHeightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.modelList[indexPath.item].itemHeight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

@end
