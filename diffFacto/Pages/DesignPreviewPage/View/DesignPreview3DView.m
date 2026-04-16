//
//  DesignPreview3DView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreview3DView.h"
#import "DesignPreviewSCNView.h"

@implementation DesignPreview3DView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup3DView];
    }
    return self;
}

- (void)setup3DView {
    self.scnView = [[DesignPreviewSCNView alloc] initWithFrame:self.bounds];
    self.scnView.backgroundColor = [UIColor systemBackgroundColor];
    self.scnView.allowsCameraControl = YES; // 360度旋转查看
    self.scnView.autoenablesDefaultLighting = YES;
    self.scnView.showsStatistics = NO;
    [self addSubview:self.scnView];
    
    SCNScene *scene = [SCNScene scene];
    self.scnView.scene = scene;
}

- (void)loadPointCloudData:(id)pointCloudData {
    // 实际项目：根据后端返回的点云数据创建3D节点
    [self.scnView.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        [child removeFromParentNode];
    }];
    
    if ([pointCloudData isKindOfClass:[SCNNode class]]) {
        // 如果是 SCNNode 类型，直接添加到场景中
        SCNNode *node = (SCNNode *)pointCloudData;
        [self.scnView.scene.rootNode addChildNode:node];
    } else {
        // 模拟点云渲染（替换为真实数据）
        SCNNode *pointCloudNode = [[SCNNode alloc] init];
        for (int i=0; i<2000; i++) {
            SCNSphere *sphere = [SCNSphere sphereWithRadius:0.008];
            SCNNode *node = [SCNNode nodeWithGeometry:sphere];
            node.position = SCNVector3Make(arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5);
            node.geometry.firstMaterial.diffuse.contents = [UIColor systemBlueColor];
            [pointCloudNode addChildNode:node];
        }
        [self.scnView.scene.rootNode addChildNode:pointCloudNode];
    }
}

- (UIImage *)captureScreenshot {
    return [self.scnView snapshot];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scnView.frame = self.bounds;
}
@end
