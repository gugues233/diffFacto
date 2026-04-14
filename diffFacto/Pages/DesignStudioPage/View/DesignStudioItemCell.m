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
    self.scnView = [[SCNView alloc] initWithFrame:self.bounds];
    self.scnView.backgroundColor = [UIColor systemBackgroundColor];
    self.scnView.allowsCameraControl = NO; // 禁用用户交互，只有在放大查看时才能交互
    self.scnView.autoenablesDefaultLighting = YES;
    self.scnView.layer.cornerRadius = 12;
    self.scnView.clipsToBounds = YES;
    self.scnView.layer.borderWidth = 1;
    self.scnView.layer.borderColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.3].CGColor;
    [self.contentView addSubview:self.scnView];
    
    // 添加场景
    SCNScene *scene = [SCNScene scene];
    self.scnView.scene = scene;
}

- (void)setModel:(DesignStudioModel *)model {
    _model = model;
    
    // 清空旧的点云
    [self.scnView.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        [child removeFromParentNode];
    }];
    
    // 如果有预览图，显示预览图
    if (model.previewImage) {
        // 创建一个平面来显示预览图
        SCNPlane *plane = [SCNPlane planeWithWidth:1 height:1];
        plane.firstMaterial.diffuse.contents = model.previewImage;
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        planeNode.position = SCNVector3Make(0, 0, 0);
        [self.scnView.scene.rootNode addChildNode:planeNode];
    }
    
    // 如果有点云数据，显示点云
    if (model.pointCloudData) {
        [self show3DPointCloud:model.pointCloudData];
    } else {
        // 如果没有点云数据，显示默认的点云（模拟）
        [self showDefaultPointCloud];
    }
}

- (void)show3DPointCloud:(id)pointCloudData {
    // 实际项目：根据后端返回的点云数据创建3D节点
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    
    // 模拟点云（实际替换为真实数据）
    for (int i=0; i<500; i++) {
        SCNGeometry *sphere = [SCNSphere sphereWithRadius:0.008];
        SCNNode *node = [SCNNode nodeWithGeometry:sphere];
        node.position = SCNVector3Make(arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5);
        [pointCloudNode addChildNode:node];
    }
    
    [self.scnView.scene.rootNode addChildNode:pointCloudNode];
}

- (void)showDefaultPointCloud {
    // 显示默认的点云（模拟）
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    
    for (int i=0; i<500; i++) {
        SCNGeometry *sphere = [SCNSphere sphereWithRadius:0.008];
        SCNNode *node = [SCNNode nodeWithGeometry:sphere];
        node.position = SCNVector3Make(arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5);
        [pointCloudNode addChildNode:node];
    }
    
    [self.scnView.scene.rootNode addChildNode:pointCloudNode];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scnView.frame = self.bounds;
}

@end
