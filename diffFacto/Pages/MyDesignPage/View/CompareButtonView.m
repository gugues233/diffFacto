//
//  CompareButtonView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CompareButtonView.h"

#define kButtonSize 60
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation CompareButtonView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setupButton {
    self.compareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
    [self.compareButton setTitle:@"对比" forState:UIControlStateNormal];
    [self.compareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.compareButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    self.compareButton.backgroundColor = [UIColor systemBlueColor];
    self.compareButton.layer.cornerRadius = kButtonSize/2;
    self.compareButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.compareButton.layer.shadowOpacity = 0.2;
    self.compareButton.layer.shadowRadius = 8;
    [self.compareButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.compareButton];
    
    // 默认隐藏在屏幕外
    self.frame = CGRectMake(kScreenWidth + 20, self.frame.origin.y, kButtonSize, kButtonSize);
}

- (void)buttonClick {
    if (self.compareButtonClickBlock) {
        self.compareButtonClickBlock();
    }
}

- (void)showButton:(BOOL)show animated:(BOOL)animated {
    CGFloat targetX = show ? (kScreenWidth - kButtonSize - 20) : (kScreenWidth + 20);
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(targetX, self.frame.origin.y, kButtonSize, kButtonSize);
        } completion:nil];
    } else {
        self.frame = CGRectMake(targetX, self.frame.origin.y, kButtonSize, kButtonSize);
    }
}

- (void)updateHiddenStateWithScrollOffset:(CGFloat)offset {
    // 滑动中隐藏，停止后显示（通过scrollView代理回调）
    static CGFloat lastOffset = 0;
    if (fabs(offset - lastOffset) > 5) {
        // 正在滑动，隐藏
        [self showButton:NO animated:YES];
    } else {
        // 滑动停止，显示
        [self showButton:YES animated:YES];
    }
    lastOffset = offset;
}

@end
