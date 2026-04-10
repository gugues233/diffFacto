//
//  CategoryScrollView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CategoryScrollView.h"
#import "CategoryItemCell.h"

#define kItemSize 60
#define kItemSpacing 10
#define kCategoryHeaderHeight 30

@interface CategoryScrollView ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) CGFloat categoryOffset; // 分类分界偏移量
@end

@implementation CategoryScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
        [self setupCategoryLabel];
    }
    return self;
}

- (void)setupCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake(kItemSize, kItemSize);
    self.layout.minimumInteritemSpacing = kItemSpacing;
    self.layout.minimumLineSpacing = kItemSpacing;
    self.layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kCategoryHeaderHeight, self.bounds.size.width, kItemSize+10) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[CategoryItemCell class] forCellWithReuseIdentifier:@"CategoryItemCell"];
    [self addSubview:self.collectionView];
}

- (void)setupCategoryLabel {
    self.currentCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, kCategoryHeaderHeight)];
    self.currentCategoryLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.currentCategoryLabel.textColor = [UIColor labelColor];
    self.currentCategoryLabel.text = @"背景";
    [self addSubview:self.currentCategoryLabel];
}

- (void)setCategoryList:(NSArray<CreateCategoryModel *> *)categoryList {
    _categoryList = categoryList;
    // 计算分类分界偏移量
    NSMutableArray *offsets = [NSMutableArray array];
    CGFloat offset = 0;
    for (CreateCategoryModel *category in categoryList) {
        offset += (category.itemList.count * (kItemSize + kItemSpacing)) + 30;
        [offsets addObject:@(offset)];
    }
    self.categoryOffset = [offsets.firstObject floatValue];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.categoryList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryList[section].itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryItemCell" forIndexPath:indexPath];
    cell.model = self.categoryList[indexPath.section].itemList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryItemCell *cell = (CategoryItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell playSelectedAnimation];
    
    if ([self.delegate respondsToSelector:@selector(categoryItemDidSelect:categoryIndex:fromView:)]) {
        [self.delegate categoryItemDidSelect:indexPath.item categoryIndex:indexPath.section fromView:cell];
    }
}

#pragma mark - UIScrollViewDelegate（分类名联动）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    // 计算当前显示的分类
    NSInteger currentSection = 0;
    CGFloat sectionOffset = 0;
    for (int i=0; i<self.categoryList.count; i++) {
        CreateCategoryModel *category = self.categoryList[i];
        CGFloat sectionWidth = (category.itemList.count * (kItemSize + kItemSpacing)) + 30;
        if (offsetX < sectionOffset + sectionWidth) {
            currentSection = i;
            break;
        }
        sectionOffset += sectionWidth;
    }
    
    // 更新分类名，带动画
    if (currentSection < self.categoryList.count) {
        CreateCategoryModel *category = self.categoryList[currentSection];
        if (![self.currentCategoryLabel.text isEqualToString:category.categoryName]) {
            // 推动消失动画
            [UIView animateWithDuration:0.2 animations:^{
                self.currentCategoryLabel.transform = CGAffineTransformMakeTranslation(-80, 0);
                self.currentCategoryLabel.alpha = 0;
            } completion:^(BOOL finished) {
                self.currentCategoryLabel.text = category.categoryName;
                self.currentCategoryLabel.transform = CGAffineTransformMakeTranslation(80, 0);
                [UIView animateWithDuration:0.2 animations:^{
                    self.currentCategoryLabel.transform = CGAffineTransformIdentity;
                    self.currentCategoryLabel.alpha = 1;
                }];
            }];
        }
    }
}
@end
