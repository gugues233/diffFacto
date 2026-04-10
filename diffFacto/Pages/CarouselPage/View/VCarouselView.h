//
//  VCarouselView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol VCarouselViewDelegate;

@interface VCarouselView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray<GoodsModel *> *dataArray;
@property (nonatomic, weak) id<VCarouselViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
- (void)reloadData;
@end

@protocol VCarouselViewDelegate <NSObject>
- (void)carouselDidSelectIndex:(NSInteger)index;
@end
