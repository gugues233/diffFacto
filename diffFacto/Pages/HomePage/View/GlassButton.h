//
//  GlassButton.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlassButton : UIButton
@property (nonatomic, assign) BOOL isSelected; // 选中状态（控制边框变蓝）
@property (nonatomic, strong) UIVisualEffectView *blurView; // 毛玻璃效果

- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
