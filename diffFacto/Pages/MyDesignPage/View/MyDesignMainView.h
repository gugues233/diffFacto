//
//  MyDesignMainView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "MyDesignCollectionView.h"
#import "CompareButtonView.h"

@protocol MyDesignMainViewDelegate <NSObject>
- (void)compareButtonDidClick;
- (void)showMaxSelectAlert;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MyDesignMainView : UIView <MyDesignCollectionViewDelegate>
@property (nonatomic, weak) id<MyDesignMainViewDelegate> delegate;
@property (nonatomic, strong) MyDesignCollectionView *collectionView;
@property (nonatomic, strong) CompareButtonView *compareButton;

- (void)updateModelList:(NSArray<MyDesignModel *> *)modelList;
- (void)updateCompareButtonVisibility:(BOOL)show;
- (void)reloadCollectionView;
@end

NS_ASSUME_NONNULL_END
