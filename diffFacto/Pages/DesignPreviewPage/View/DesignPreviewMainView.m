//
//  DesignPreviewMainView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewMainView.h"

@implementation DesignPreviewMainView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 3D预览视图
    self.preview3DView = [[DesignPreview3DView alloc] initWithFrame:CGRectMake(0, 88, self.bounds.size.width, self.bounds.size.height - 88)];
    [self addSubview:self.preview3DView];
    
    // 返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 54, 32, 32)];
    [self.backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [self.backButton setTintColor:[UIColor labelColor]];
    [self.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    // 更多按钮（三个点）
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 48, 54, 32, 32)];
    [self.moreButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    [self.moreButton setTintColor:[UIColor labelColor]];
    [self.moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    
    // 应用按钮
    self.applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.applyButton.frame = CGRectMake(self.bounds.size.width-80, 54, 60, 32);
    [self.applyButton setTitle:@"应用" forState:0];
    [self.applyButton setTitleColor:[UIColor systemBlueColor] forState:0];
    [self.applyButton addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.applyButton];
    self.applyButton.hidden = YES;
    
    // 操作菜单
    self.actionMenuView = [[MoreActionMenuView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.actionMenuView];
}

- (void)backClick {
    if ([self.delegate respondsToSelector:@selector(backButtonDidClick)]) {
        [self.delegate backButtonDidClick];
    }
}

- (void)moreClick {
    if ([self.delegate respondsToSelector:@selector(moreButtonDidClick)]) {
        [self.delegate moreButtonDidClick];
    }
    CGPoint point = [self.moreButton convertPoint:self.moreButton.bounds.origin toView:self];
    [self.actionMenuView showMenuFromPoint:point];
}

- (void)loadPointCloudData:(id)data {
    [self.preview3DView loadPointCloudData:data];
}

- (void)updatePublicStatus:(BOOL)isPublic {
    self.actionMenuView.isPublic = isPublic;
}

- (void)applyClick {
    if (self.applyButtonBlock) self.applyButtonBlock();
}
- (void)showMyModelUI {
    self.moreButton.hidden = NO;
    self.applyButton.hidden = YES;
}
- (void)showOtherModelUI {
    self.moreButton.hidden = YES;
    self.applyButton.hidden = NO;
}

@end
