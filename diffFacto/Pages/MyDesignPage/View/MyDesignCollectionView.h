//
//  MyDesignCollectionView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "MyDesignModel.h"

@protocol MyDesignCollectionViewDelegate <NSObject>
- (void)collectionViewDidSelectItemAtIndex:(NSInteger)index;
- (void)collectionViewDidLongPressItemAtIndex:(NSInteger)index;
- (void)collectionViewDidScroll:(CGFloat)offset;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MyDesignCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray<MyDesignModel *> *modelList;
@property (nonatomic, weak) id<MyDesignCollectionViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
