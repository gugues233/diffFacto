//
//  CreatePageMainView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "CategoryScrollView.h"
#import "SelectedItemView.h"
#import "Preview3DView.h"

@protocol CreatePageMainViewDelegate <NSObject>
- (void)generateButtonDidClick;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CreatePageMainView : UIView <CategoryScrollViewDelegate>
@property (nonatomic, weak) id<CreatePageMainViewDelegate> delegate;
@property (nonatomic, strong) CategoryScrollView *categoryScrollView;
@property (nonatomic, strong) SelectedItemView *selectedView;
@property (nonatomic, strong) Preview3DView *previewView;
@property (nonatomic, strong) UIButton *generateButton;

- (void)updateSelectedList:(NSArray *)selectedList;
- (void)updateGenerateProgress:(CGFloat)progress;
- (void)show3DResult:(id)result;
- (void)addItemAnimationFromView:(UIView *)fromView;
@end

NS_ASSUME_NONNULL_END
