//
//  MoreActionMenuView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "MoreActionMenuView.h"

#define kMenuWidth 160
#define kMenuItemHeight 44
#define kCornerRadius 12

@implementation MoreActionMenuView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.userInteractionEnabled = YES;
        // 添加点击遮罩
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showMenuFromPoint:(CGPoint)point {
    self.frame = [UIScreen mainScreen].bounds;
    self.hidden = NO;
    
    // 创建菜单容器
    UIView *menuContainer = [[UIView alloc] initWithFrame:CGRectZero];
    menuContainer.backgroundColor = [UIColor systemBackgroundColor];
    menuContainer.layer.cornerRadius = kCornerRadius;
    menuContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    menuContainer.layer.shadowOpacity = 0.2;
    menuContainer.layer.shadowRadius = 8;
    menuContainer.tag = 1001;
    [self addSubview:menuContainer];
    
    // 创建菜单项
    NSArray *titles = @[@"分享到微信", @"另存为图片", @"删除", self.isPublic ? @"设为私有" : @"公开"];
    for (int i=0; i<4; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, i*kMenuItemHeight, kMenuWidth, kMenuItemHeight)];
        [item setTitle:titles[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        item.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        item.tag = i;
        [item addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuContainer addSubview:item];
        
        // 添加分割线
        if (i < 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, (i+1)*kMenuItemHeight, kMenuWidth-32, 0.5)];
            line.backgroundColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.3];
            [menuContainer addSubview:line];
        }
    }
    
    // 调整菜单位置（右上角弹出）
    CGFloat menuY = point.y + 8;
    CGFloat menuX = point.x - kMenuWidth + 30;
    menuContainer.frame = CGRectMake(menuX, menuY, kMenuWidth, 4*kMenuItemHeight);
    
    // 弹出动画
    menuContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    menuContainer.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        menuContainer.transform = CGAffineTransformIdentity;
        menuContainer.alpha = 1;
    } completion:nil];
}

- (void)dismissMenu {
    UIView *menuContainer = [self viewWithTag:1001];
    [UIView animateWithDuration:0.2 animations:^{
        menuContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
        menuContainer.alpha = 0;
    } completion:^(BOOL finished) {
        [menuContainer removeFromSuperview];
        self.hidden = YES;
    }];
}

- (void)menuItemClick:(UIButton *)sender {
    [self dismissMenu];
    if ([self.delegate respondsToSelector:@selector(moreActionDidSelect:)]) {
        [self.delegate moreActionDidSelect:(MoreActionType)sender.tag];
    }
}

@end
