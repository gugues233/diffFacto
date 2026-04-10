//
//  MyDesignItemCell.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignItemCell.h"

#define kBorderWidth 3

@implementation MyDesignItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 预览图
    self.previewImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.previewImageView.clipsToBounds = YES;
    self.previewImageView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.previewImageView];
    
    // 选中蓝圈（默认隐藏）
    self.selectedBorderView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBorderView.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.selectedBorderView.layer.borderWidth = 0;
    self.selectedBorderView.layer.cornerRadius = 12;
    self.selectedBorderView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.selectedBorderView];
}

- (void)setModel:(MyDesignModel *)model {
    _model = model;
    self.previewImageView.image = model.previewImage;
    [self updateSelectedState];
}

- (void)updateSelectedState {
    if (self.model.isSelected) {
        self.selectedBorderView.layer.borderWidth = kBorderWidth;
    } else {
        self.selectedBorderView.layer.borderWidth = 0;
    }
}

@end
