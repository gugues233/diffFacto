//
//  DesignPreviewMainView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <UIKit/UIKit.h>
#import "DesignPreview3DView.h"
#import "MoreActionMenuView.h"

@protocol DesignPreviewMainViewDelegate <NSObject>
- (void)backButtonDidClick;
- (void)moreButtonDidClick;
@end

NS_ASSUME_NONNULL_BEGIN

@interface DesignPreviewMainView : UIView
@property (nonatomic, weak) id<DesignPreviewMainViewDelegate> delegate;
@property (nonatomic, strong) DesignPreview3DView *preview3DView;
@property (nonatomic, strong) MoreActionMenuView *actionMenuView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *moreButton;

- (void)loadPointCloudData:(id)data;
- (void)updatePublicStatus:(BOOL)isPublic;
@end

NS_ASSUME_NONNULL_END
