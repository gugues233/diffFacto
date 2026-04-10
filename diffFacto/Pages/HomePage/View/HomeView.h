//
//  HomeView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
@class GlassButton;

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView
@property (nonatomic, strong) GlassButton *CreateBtn;
@property (nonatomic, strong) GlassButton *myDesignBtn;
@property (nonatomic, copy) void(^buttonClickBlock)(NSInteger index); // 按钮点击回调

- (void)updateButtonSelectedAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
