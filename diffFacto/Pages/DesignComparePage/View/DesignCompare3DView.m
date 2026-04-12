//
//  DesignCompare3DView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignCompare3DView.h"

@implementation DesignCompare3DView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup3DView];
        [self addCameraObserver];
    }
    return self;
}

- (void)setup3DView {
    self.scnView = [[SCNView alloc] initWithFrame:self.bounds];
    self.scnView.backgroundColor = [UIColor systemBackgroundColor];
    self.scnView.allowsCameraControl = YES; // 支持手势旋转/缩放
    self.scnView.autoenablesDefaultLighting = YES;
    self.scnView.showsStatistics = NO;
    
    SCNScene *scene = [SCNScene scene];
    // 添加相机节点（用于同步）
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5);
    [scene.rootNode addChildNode:cameraNode];
    self.scnView.pointOfView = cameraNode;
    
    [self addSubview:self.scnView];
}

- (void)addCameraObserver {
    // 监听相机位置/角度变化，触发同步回调
    [self.scnView.pointOfView addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
    [self.scnView.pointOfView addObserver:self forKeyPath:@"eulerAngles" options:NSKeyValueObservingOptionNew context:nil];
    [self.scnView addObserver:self forKeyPath:@"pointOfView.camera.zFar" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"position"] || [keyPath isEqualToString:@"eulerAngles"] || [keyPath isEqualToString:@"pointOfView.camera.zFar"]) {
        if (self.cameraChangeBlock) {
            self.cameraChangeBlock(self.scnView);
        }
    }
}

- (void)loadPointCloudData:(id)pointCloudData {
    // 清空旧节点
    [self.scnView.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        if (![child isEqual:self.scnView.pointOfView]) {
            [child removeFromParentNode];
        }
    }];
    
    // 渲染点云（替换为真实数据）
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

- (void)syncCameraFromView:(SCNView *)sourceView {
    // 同步相机状态
    SCNNode *sourceCamera = sourceView.pointOfView;
    SCNNode *targetCamera = self.scnView.pointOfView;
    
    targetCamera.position = sourceCamera.position;
    targetCamera.eulerAngles = sourceCamera.eulerAngles;
    self.scnView.pointOfView.camera.zFar = sourceView.pointOfView.camera.zFar;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scnView.frame = self.bounds;
}

- (void)dealloc {
    // 移除KVO监听，防止内存泄漏
    [self.scnView.pointOfView removeObserver:self forKeyPath:@"position"];
    [self.scnView.pointOfView removeObserver:self forKeyPath:@"eulerAngles"];
    [self.scnView removeObserver:self forKeyPath:@"pointOfView.camera.zFar"];
}
@end
