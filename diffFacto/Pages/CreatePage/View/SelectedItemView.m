//
//  SelectedItemView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "SelectedItemView.h"

#define kItemSize 50
#define kItemSpacing 15

@implementation SelectedItemView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelectedList:(NSArray<CreateSelectedItemModel *> *)selectedList {
    _selectedList = selectedList;
    [self reloadItems];
}

- (void)reloadItems {
    // 移除旧视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 按分类顺序添加
    for (int i=0; i<self.selectedList.count; i++) {
        CreateSelectedItemModel *model = self.selectedList[i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, i*(kItemSize + kItemSpacing), kItemSize, kItemSize)];
        imgView.image = model.selectedImage;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 8;
        imgView.layer.borderColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.5].CGColor;
        imgView.layer.borderWidth = 1;
        [self addSubview:imgView];
    }
}

- (void)addItemWithImage:(UIImage *)image fromPoint:(CGPoint)fromPoint completion:(void(^)(void))completion {
    // 复制动画：从点击位置飞到左侧列表
    UIImageView *flyView = [[UIImageView alloc] initWithImage:image];
    flyView.frame = CGRectMake(fromPoint.x, fromPoint.y, kItemSize, kItemSize);
    flyView.contentMode = UIViewContentModeScaleAspectFill;
    flyView.clipsToBounds = YES;
    flyView.layer.cornerRadius = 8;
    [self.superview addSubview:flyView];
    
    // 目标位置（列表最后一个位置）
    CGFloat targetY = self.selectedList.count * (kItemSize + kItemSpacing);
    CGPoint targetPoint = CGPointMake(10 + self.frame.origin.x, targetY + self.frame.origin.y);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        flyView.frame = CGRectMake(targetPoint.x, targetPoint.y, kItemSize, kItemSize);
        flyView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [flyView removeFromSuperview];
        [self reloadItems];
        if (completion) completion();
    }];
}
@end
