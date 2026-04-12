//
//  DesignStudioItemCell.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioItemCell.h"

@implementation DesignStudioItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.previewImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.previewImageView.clipsToBounds = YES;
    self.previewImageView.layer.cornerRadius = 12;
    self.previewImageView.backgroundColor = [UIColor systemGray5Color];
    [self.contentView addSubview:self.previewImageView];
}

- (void)setModel:(DesignStudioModel *)model {
    _model = model;
    self.previewImageView.image = model.previewImage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewImageView.frame = self.bounds;
}

@end
