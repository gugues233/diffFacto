//
//  DesignCompareMainView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <UIKit/UIKit.h>
#import "DesignCompare3DView.h"

@protocol DesignCompareMainViewDelegate <NSObject>
- (void)backButtonDidClick;
@end

NS_ASSUME_NONNULL_BEGIN

@interface DesignCompareMainView : UIView
@property (nonatomic, weak) id<DesignCompareMainViewDelegate> delegate;
@property (nonatomic, strong) DesignCompare3DView *top3DView;
@property (nonatomic, strong) DesignCompare3DView *bottom3DView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isGlobalSyncing; // 全局同步标志，防止循环同步

- (void)loadFirstModelData:(id)firstData secondModelData:(id)secondData;
- (void)setupSyncBetweenViews;
@end

NS_ASSUME_NONNULL_END
