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
    self.scnView.delegate = self; // 设置渲染代理
    
    SCNScene *scene = [SCNScene scene];
    self.scnView.scene = scene; // 重要：设置场景
    
    // 添加相机节点（用于同步）
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5);
    [scene.rootNode addChildNode:cameraNode];
    self.scnView.pointOfView = cameraNode;
    
    // 初始化上一次相机状态
    self.lastCameraPosition = cameraNode.position;
    self.lastCameraEulerAngles = cameraNode.eulerAngles;
    
    [self addSubview:self.scnView];
}

- (void)addCameraObserver {
    // 不再使用KVO，改用SCNSceneRendererDelegate
}

#pragma mark - SCNSceneRendererDelegate
- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    // 如果正在同步，跳过检查
    if (self.isSyncing) {
        return;
    }
    
    SCNNode *cameraNode = self.scnView.pointOfView;
    if (!cameraNode) {
        return;
    }
    
    // 检查相机位置或角度是否发生变化
    SCNVector3 currentPosition = cameraNode.position;
    SCNVector3 currentEulerAngles = cameraNode.eulerAngles;
    
    // 计算位置变化距离
    CGFloat dx = currentPosition.x - self.lastCameraPosition.x;
    CGFloat dy = currentPosition.y - self.lastCameraPosition.y;
    CGFloat dz = currentPosition.z - self.lastCameraPosition.z;
    CGFloat distance = sqrt(dx*dx + dy*dy + dz*dz);
    
    // 计算角度变化
    CGFloat angleX = fabs(currentEulerAngles.x - self.lastCameraEulerAngles.x);
    CGFloat angleY = fabs(currentEulerAngles.y - self.lastCameraEulerAngles.y);
    CGFloat angleZ = fabs(currentEulerAngles.z - self.lastCameraEulerAngles.z);
    CGFloat maxAngleChange = MAX(MAX(angleX, angleY), angleZ);
    
    // 设置阈值，只有变化超过阈值才触发同步
    CGFloat positionThreshold = 0.01; // 位置变化阈值
    CGFloat angleThreshold = 0.01;    // 角度变化阈值（弧度）
    
    BOOL positionChanged = distance > positionThreshold;
    BOOL angleChanged = maxAngleChange > angleThreshold;
    
    if (positionChanged || angleChanged) {
        
        // 更新上一次状态
        self.lastCameraPosition = currentPosition;
        self.lastCameraEulerAngles = currentEulerAngles;
        
        // 触发同步回调
        if (self.cameraChangeBlock) {
            self.cameraChangeBlock(self.scnView);
        }
    }
}

- (void)loadPointCloudData:(id)pointCloudData {
    
    // 保存相机节点引用
    SCNNode *cameraNode = self.scnView.pointOfView;
    
    // 清空旧节点（保留相机节点）
    NSArray *childNodes = [self.scnView.scene.rootNode.childNodes copy];
    for (SCNNode *child in childNodes) {
        // 使用指针比较，而不是isEqual:
        if (child != cameraNode) {
            [child removeFromParentNode];
        }
    }
    
    
    // 检查传入的数据类型
    if ([pointCloudData isKindOfClass:[SCNNode class]]) {
        SCNNode *node = (SCNNode *)pointCloudData;
        [self.scnView.scene.rootNode addChildNode:node];
    } else {
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
    
    if (!self.scnView.pointOfView && cameraNode) {
        self.scnView.pointOfView = cameraNode;
    }
}

- (void)syncCameraFromView:(SCNView *)sourceView {
    SCNNode *sourceCamera = sourceView.pointOfView;
    SCNNode *targetCamera = self.scnView.pointOfView;
    
    // 空值检查
    if (!sourceCamera || !targetCamera) {
        return;
    }
    
    // 设置同步标志，防止循环调用
    self.isSyncing = YES;
    
    BOOL wasAllowsCameraControl = self.scnView.allowsCameraControl;
    self.scnView.allowsCameraControl = NO;
    
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0];
    
    targetCamera.position = sourceCamera.position;
    targetCamera.eulerAngles = sourceCamera.eulerAngles;
    
    [SCNTransaction commit];
    
    self.lastCameraPosition = targetCamera.position;
    self.lastCameraEulerAngles = targetCamera.eulerAngles;
    
    // 检查camera是否存在
    if (sourceCamera.camera && targetCamera.camera) {
        targetCamera.camera.zFar = sourceCamera.camera.zFar;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scnView.allowsCameraControl = wasAllowsCameraControl;
        self.isSyncing = NO;
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scnView.frame = self.bounds;
}

- (void)dealloc {
    // 不再使用KVO，无需移除观察者
}
@end
