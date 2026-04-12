//
//  MoreActionMenuView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoreActionType) {
    MoreActionTypeShareWeChat,
    MoreActionTypeSaveImage,
    MoreActionTypeDelete,
    MoreActionTypeTogglePublic
};

@protocol MoreActionMenuViewDelegate <NSObject>
- (void)moreActionDidSelect:(MoreActionType)type;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MoreActionMenuView : UIView
@property (nonatomic, weak) id<MoreActionMenuViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPublic; // 当前公开状态

- (void)showMenuFromPoint:(CGPoint)point;
- (void)dismissMenu;
@end

NS_ASSUME_NONNULL_END
