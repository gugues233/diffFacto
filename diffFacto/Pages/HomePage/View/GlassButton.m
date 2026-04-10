//
//  GlassButton.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "GlassButton.h"

#define kCornerRadius 16
#define kBorderWidth 2

@implementation GlassButton

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self setupGlassEffect];
        [self setupTitleLabel:title];
        self.clipsToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        _isSelected = NO;
    }
    return self;
}

- (void)setupGlassEffect {
    // 液态玻璃毛玻璃效果（iOS原生）
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurView.layer.cornerRadius = kCornerRadius;
    self.blurView.clipsToBounds = YES;
    // 默认边框（透明）
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = kCornerRadius;
    [self addSubview:self.blurView];
}

- (void)setupTitleLabel:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor labelColor];
    titleLabel.userInteractionEnabled = NO;
    [self.blurView.contentView addSubview:titleLabel];
    
    // 布局
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.blurView.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:self.blurView.centerYAnchor],
         
        [titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.blurView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.blurView.trailingAnchor constant:-20]
    ]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.blurView.frame = self.bounds;
}

// 重写选中状态，控制边框变蓝
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        // 选中：边框变系统蓝，加粗
        self.layer.borderColor = [UIColor systemBlueColor].CGColor;
        self.layer.borderWidth = kBorderWidth;
    } else {
        // 未选中：透明细边框
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        self.layer.borderWidth = 1;
    }
}

@end
