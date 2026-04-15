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
    
    // 清空旧的点云
    [self resetPreview];
    
    // 检查数据是否为数组
    if (![pointCloudData isKindOfClass:[NSArray class]]) {
        NSLog(@"⚠️ 点云数据格式不正确");
        return;
    }
    
    NSArray *points = (NSArray *)pointCloudData;
    NSLog(@"📋 开始渲染点云，共 %ld 个点", (long)points.count);
    
    // 创建点云节点
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    
    // 使用SCNGeometrySource和SCNGeometryElement来高效渲染大量点
    NSMutableArray *vertices = [NSMutableArray arrayWithCapacity:points.count];
    
    for (id pointObj in points) {
        if ([pointObj isKindOfClass:[NSArray class]]) {
            NSArray *point = (NSArray *)pointObj;
            if (point.count >= 3) {
                float x = [point[0] floatValue];
                float y = [point[1] floatValue];
                float z = [point[2] floatValue];
                
                SCNVector3 vertex = SCNVector3Make(x, y, z);
                [vertices addObject:[NSValue valueWithSCNVector3:vertex]];
            }
        }
    }
    
    if (vertices.count == 0) {
        NSLog(@"⚠️ 没有有效的点云数据");
        return;
    }
    
    // 将NSMutableArray转换为SCNVector3数组
    SCNVector3 *vertexArray = malloc(sizeof(SCNVector3) * vertices.count);
    for (NSInteger i = 0; i < vertices.count; i++) {
        vertexArray[i] = [[vertices objectAtIndex:i] SCNVector3Value];
    }
    
    // 创建几何数据
    SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithVertices:vertexArray count:vertices.count];
    
    // 为每个点创建索引
    int *indices = malloc(sizeof(int) * vertices.count);
    for (NSInteger i = 0; i < vertices.count; i++) {
        indices[i] = (int)i;
    }
    
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(int) * vertices.count];
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:indexData primitiveType:SCNGeometryPrimitiveTypePoint primitiveCount:vertices.count bytesPerIndex:sizeof(int)];
    
    free(indices);
    free(vertexArray);
    
    // 创建几何体
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[vertexSource] elements:@[element]];
    
    // 设置点的颜色和大小
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIColor blackColor];
    material.lightingModelName = SCNLightingModelConstant; // 不受光照影响
    geometry.materials = @[material];
    
    // 设置点的大小（iOS 11+）
    if (@available(iOS 11.0, *)) {
        element.pointSize = 3.0; // 设置点的大小为3像素
        element.minimumPointScreenSpaceRadius = 1.0;
        element.maximumPointScreenSpaceRadius = 10.0;
    }
    
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    [pointCloudNode addChildNode:node];
    
    [self.scnView.scene.rootNode addChildNode:pointCloudNode];
    
    NSLog(@"✅ 点云渲染完成，共 %ld 个点", (long)vertices.count);
}

- (void)resetPreview {
    [self.scnView.scene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        [child removeFromParentNode];
    }];
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
}
@end
