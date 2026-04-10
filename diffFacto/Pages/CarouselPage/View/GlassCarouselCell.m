//
//  GlassCarouselCell.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "GlassCarouselCell.h"

#define kCornerRadius 24

@interface GlassCarouselCell ()
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation GlassCarouselCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        
        // 液态玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialLight];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.blurView.layer.cornerRadius = kCornerRadius;
        self.blurView.clipsToBounds = YES;
        
        // 边框
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        self.layer.borderWidth = 0.8;
        self.layer.cornerRadius = kCornerRadius;
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOpacity = 0.12;
        self.layer.shadowRadius = 10;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        
        // 标题
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        self.titleLabel.textColor = UIColor.labelColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.blurView];
        [self.blurView.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(GoodsModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.blurView.frame = self.bounds;
    self.titleLabel.frame = self.bounds;
}
@end
