//
//  VCarouselView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "VCarouselView.h"
#import "GlassCarouselCell.h"

#define kItemW 160
#define kItemH 240
#define kSpacing 40

@interface VCarouselView ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation VCarouselView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollection];
    }
    return self;
}

- (void)setupCollection {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake(kItemW, kItemH);
    self.layout.minimumInteritemSpacing = kSpacing;
    self.layout.minimumLineSpacing = kSpacing;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[GlassCarouselCell class] forCellWithReuseIdentifier:@"GlassCell"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, self.frame.size.width/2 - kItemW/2, 0, self.frame.size.width/2 - kItemW/2);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GlassCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GlassCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

// V 型布局 + 缩放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat centerX = scrollView.contentOffset.x + scrollView.frame.size.width/2;
    
    for (GlassCarouselCell *cell in self.collectionView.visibleCells) {
        CGFloat distance = fabs(cell.center.x - centerX);
        CGFloat scale = 0.7 + 0.3 * (1 - distance/(kItemW + kSpacing));
        scale = MAX(scale, 0.7);
        
        // 缩放
        cell.transform = CGAffineTransformMakeScale(scale, scale);
        
        // V 型倾斜
        CGFloat offset = cell.center.x - centerX;
        CGFloat angle = offset / 550;
        cell.transform = CGAffineTransformConcat(cell.transform, CGAffineTransformMakeRotation(angle));
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self updateCurrentIndex];
}

- (void)updateCurrentIndex {
    CGPoint center = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:center];
    if (path && [self.delegate respondsToSelector:@selector(carouselDidSelectIndex:)]) {
        [self.delegate carouselDidSelectIndex:path.item];
    }
}

- (NSInteger)currentIndex {
    CGPoint center = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    return [self.collectionView indexPathForItemAtPoint:center].item;
}

- (void)reloadData {
    [self.collectionView reloadData];
}
@end
