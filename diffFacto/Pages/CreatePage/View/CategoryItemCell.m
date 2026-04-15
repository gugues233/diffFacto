//
//  CategoryItemCell.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CategoryItemCell.h"

#define kCellSize 60
#define kBorderWidth 3

@implementation CategoryItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"📋 CategoryItemCell 初始化，frame：%@", NSStringFromCGRect(frame));
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 图片容器
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, kCellSize-8, kCellSize-8)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = (kCellSize-8)/2;
    [self.contentView addSubview:self.imageView];
    
    // 选中蓝圈（默认隐藏）
    self.selectedBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellSize, kCellSize)];
    self.selectedBorderView.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.selectedBorderView.layer.borderWidth = 0;
    self.selectedBorderView.layer.cornerRadius = kCellSize/2;
    self.selectedBorderView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.selectedBorderView];
}

- (void)setModel:(CreateItemModel *)model {
    _model = model;
    self.imageView.image = model.itemImage;
    // 更新选中状态
    if (model.isSelected) {
        self.selectedBorderView.layer.borderWidth = kBorderWidth;
    } else {
        self.selectedBorderView.layer.borderWidth = 0;
    }
}

- (void)playSelectedAnimation {
    // 选中缩放动画
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.selectedBorderView.layer.borderWidth = kBorderWidth;
    } completion:nil];
}
@end
