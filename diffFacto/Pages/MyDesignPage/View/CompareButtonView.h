//
//  CompareButtonView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompareButtonView : UIView
@property (nonatomic, strong) UIButton *compareButton;
@property (nonatomic, copy) void(^compareButtonClickBlock)(void);

- (void)showButton:(BOOL)show animated:(BOOL)animated;
- (void)updateHiddenStateWithScrollOffset:(CGFloat)offset;
@end

NS_ASSUME_NONNULL_END
