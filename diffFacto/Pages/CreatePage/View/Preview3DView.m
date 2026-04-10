//
//  Preview3DView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "Preview3DView.h"

@implementation Preview3DView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup3DView];
        [self setupProgressView];
    }
    return self;
}

- (void)setup3DView {
    self.scnView = [[SCNView alloc] initWithFrame:self.bounds];
    self.scnView.backgroundColor = [UIColor systemBackgroundColor];
    self.scnView.allowsCameraControl = YES; // 允许用户旋转查看
    self.scnView.autoenablesDefaultLighting = YES;
    [self addSubview:self.scnView];
    
    // 添加场景
    SCNScene *scene = [SCNScene scene];
    self.scnView.scene = scene;
}

- (void)setupProgressView {
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(self.bounds.size.width/2 - 100, self.bounds.size.height/2 - 10, 200, 20);
    self.progressView.progressTintColor = [UIColor systemBlueColor];
    self.progressView.trackTintColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.3];
    self.progressView.hidden = YES;
    [self addSubview:self.progressView];
}

- (void)startGenerateProgress:(CGFloat)progress {
    self.progressView.hidden = NO;
    [self.progressView setProgress:progress animated:YES];
}

- (void)show3DPointCloud:(id)pointCloudData {
    self.progressView.hidden = YES;
    // 实际项目：根据后端返回的点云数据创建3D节点
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    // 模拟点云（实际替换为真实数据）
    for (int i=0; i<1000; i++) {
        SCNGeometry *sphere = [SCNSphere sphereWithRadius:0.01];
        SCNNode *node = [SCNNode nodeWithGeometry:sphere];
        node.position = SCNVector3Make(arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5);
        [pointCloudNode addChildNode:node];
    }
    [self.scnView.scene.rootNode addChildNode:pointCloudNode];
}

- (void)resetPreview {
    [self.scnView.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        [child removeFromParentNode];
    }];
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
}
@end
