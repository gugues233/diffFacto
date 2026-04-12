//
//  DesignStudioWaterfallLayout.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioWaterfallLayout.h"

@interface DesignStudioWaterfallLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;
@end

@implementation DesignStudioWaterfallLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _columnCount = 2;
        _columnSpacing = 10;
        _rowSpacing = 10;
        _sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.attributesArray = [NSMutableArray array];
    self.columnHeights = [NSMutableArray arrayWithCapacity:self.columnCount];
    
    // 初始化列高度
    for (int i=0; i<self.columnCount; i++) {
        [self.columnHeights addObject:@(self.sectionInset.top)];
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat itemWidth = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount-1)*self.columnSpacing) / self.columnCount;
    
    for (int i=0; i<itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat itemHeight = [self.delegate waterfallLayoutHeightForItemAtIndexPath:indexPath];
        
        // 找到最短的列
        NSInteger minColumn = 0;
        CGFloat minHeight = [self.columnHeights[0] floatValue];
        for (int j=1; j<self.columnCount; j++) {
            CGFloat height = [self.columnHeights[j] floatValue];
            if (height < minHeight) {
                minHeight = height;
                minColumn = j;
            }
        }
        
        // 计算item位置
        CGFloat x = self.sectionInset.left + minColumn*(itemWidth + self.columnSpacing);
        CGFloat y = minHeight + self.rowSpacing;
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attrs.frame = CGRectMake(x, y, itemWidth, itemHeight);
        [self.attributesArray addObject:attrs];
        
        // 更新列高度
        self.columnHeights[minColumn] = @(y + itemHeight);
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributesArray[indexPath.item];
}

- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = [self.columnHeights[0] floatValue];
    for (int i=1; i<self.columnCount; i++) {
        CGFloat height = [self.columnHeights[i] floatValue];
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight + self.sectionInset.bottom);
}

@end
