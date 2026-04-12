//
//  DesignStudioMainView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <UIKit/UIKit.h>
#import "DesignStudioWaterfallLayout.h"
#import "DesignStudioModel.h"

@protocol DesignStudioMainViewDelegate <NSObject>
- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)didPullToRefresh;
@end

NS_ASSUME_NONNULL_BEGIN

@interface DesignStudioMainView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, DesignStudioWaterfallLayoutDelegate>
@property (nonatomic, weak) id<DesignStudioMainViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray<DesignStudioModel *> *modelList;

- (void)endRefreshing;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
