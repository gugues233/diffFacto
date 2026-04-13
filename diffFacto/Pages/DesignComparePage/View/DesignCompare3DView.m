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
    self.scnView.scene = scene; // 重要：设置场景
    
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
    // 如果正在同步，不触发回调，防止循环调用
    if (self.isSyncing) {
        NSLog(@"⏭️ Skipping KVO callback during sync");
        return;
    }
    
    if ([keyPath isEqualToString:@"position"] || [keyPath isEqualToString:@"eulerAngles"] || [keyPath isEqualToString:@"pointOfView.camera.zFar"]) {
        NSLog(@"📷 Camera changed: %@, triggering sync", keyPath);
        if (self.cameraChangeBlock) {
            self.cameraChangeBlock(self.scnView);
        }
    }
}

- (void)loadPointCloudData:(id)pointCloudData {
    NSLog(@"📍 loadPointCloudData called, data type: %@", [pointCloudData class]);
    NSLog(@"📍 Current pointOfView: %@", self.scnView.pointOfView);
    NSLog(@"📍 Scene has %ld child nodes before clearing", (long)self.scnView.scene.rootNode.childNodes.count);
    
    // 保存相机节点引用
    SCNNode *cameraNode = self.scnView.pointOfView;
    
    // 清空旧节点（保留相机节点）
    NSArray *childNodes = [self.scnView.scene.rootNode.childNodes copy];
    for (SCNNode *child in childNodes) {
        // 使用指针比较，而不是isEqual:
        if (child != cameraNode) {
            NSLog(@"📍 Removing child: %@", child);
            [child removeFromParentNode];
        } else {
            NSLog(@"📍 Keeping camera node: %@", child);
        }
    }
    
    NSLog(@"📍 Scene has %ld child nodes after clearing", (long)self.scnView.scene.rootNode.childNodes.count);
    
    // 检查传入的数据类型
    if ([pointCloudData isKindOfClass:[SCNNode class]]) {
        NSLog(@"✅ Data is SCNNode, adding to scene");
        SCNNode *node = (SCNNode *)pointCloudData;
        NSLog(@"   Node has %ld child nodes", (long)node.childNodes.count);
        [self.scnView.scene.rootNode addChildNode:node];
    } else {
        NSLog(@"⚠️ Data is not SCNNode, creating mock data");
        // 否则创建模拟点云
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
    
    NSLog(@"📍 Scene now has %ld child nodes", (long)self.scnView.scene.rootNode.childNodes.count);
    NSLog(@"📍 pointOfView is still: %@", self.scnView.pointOfView);
    
    // 确保相机节点仍然存在
    if (!self.scnView.pointOfView && cameraNode) {
        NSLog(@"⚠️ pointOfView was lost, restoring it");
        self.scnView.pointOfView = cameraNode;
    }
}

- (void)syncCameraFromView:(SCNView *)sourceView {
    NSLog(@"🔄 syncCameraFromView called");
    
    // 同步相机状态
    SCNNode *sourceCamera = sourceView.pointOfView;
    SCNNode *targetCamera = self.scnView.pointOfView;
    
    // 空值检查
    if (!sourceCamera || !targetCamera) {
        NSLog(@"⚠️ Source or target camera is nil");
        return;
    }
    
    // 设置同步标志，防止循环调用
    self.isSyncing = YES;
    
    NSLog(@"📍 Syncing position from (%.2f, %.2f, %.2f) to (%.2f, %.2f, %.2f)",
          sourceCamera.position.x, sourceCamera.position.y, sourceCamera.position.z,
          targetCamera.position.x, targetCamera.position.y, targetCamera.position.z);
    
    targetCamera.position = sourceCamera.position;
    targetCamera.eulerAngles = sourceCamera.eulerAngles;
    
    // 检查camera是否存在
    if (sourceCamera.camera && targetCamera.camera) {
        targetCamera.camera.zFar = sourceCamera.camera.zFar;
    }
    
    // 重置同步标志
    self.isSyncing = NO;
    
    NSLog(@"✅ Sync completed");
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
