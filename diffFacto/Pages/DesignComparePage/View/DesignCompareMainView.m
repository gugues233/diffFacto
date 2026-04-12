//
//  DesignCompareMainView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignCompareMainView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation DesignCompareMainView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat halfHeight = (kScreenHeight - 88) / 2;
    
    // 顶部3D视图
    self.top3DView = [[DesignCompare3DView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, halfHeight)];
    [self addSubview:self.top3DView];
    
    // 分割线
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 88 + halfHeight, kScreenWidth, 1)];
    divider.backgroundColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.3];
    [self addSubview:divider];
    
    // 底部3D视图
    self.bottom3DView = [[DesignCompare3DView alloc] initWithFrame:CGRectMake(0, 89 + halfHeight, kScreenWidth, halfHeight - 1)];
    [self addSubview:self.bottom3DView];
    
    // 返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 54, 32, 32)];
    [self.backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [self.backButton setTintColor:[UIColor labelColor]];
    [self.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 54, 100, 32)];
    titleLabel.text = @"对比";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor labelColor];
    [self addSubview:titleLabel];
}

- (void)backClick {
    if ([self.delegate respondsToSelector:@selector(backButtonDidClick)]) {
        [self.delegate backButtonDidClick];
    }
}

- (void)loadFirstModelData:(id)firstData secondModelData:(id)secondData {
    [self.top3DView loadPointCloudData:firstData];
    [self.bottom3DView loadPointCloudData:secondData];
    [self setupSyncBetweenViews];
}

- (void)setupSyncBetweenViews {
    __weak typeof(self) weakSelf = self;
    
    // 顶部视图变化 → 同步到底部
    self.top3DView.cameraChangeBlock = ^(SCNView *scnView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.bottom3DView syncCameraFromView:scnView];
    };
    
    // 底部视图变化 → 同步到顶部
    self.bottom3DView.cameraChangeBlock = ^(SCNView *scnView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.top3DView syncCameraFromView:scnView];
    };
}

@end
