//
//  DesignPreview3DView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreview3DView.h"

@implementation DesignPreview3DView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup3DView];
    }
    return self;
}

- (void)setup3DView {
    self.scnView = [[SCNView alloc] initWithFrame:self.bounds];
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
    
    // 检查数据是否为数组
    if ([pointCloudData isKindOfClass:[NSArray class]]) {
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
        
        if (vertices.count > 0) {
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
            material.diffuse.contents = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
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
        } else {
            NSLog(@"⚠️ 没有有效的点云数据");
            // 使用模拟数据
            [self loadMockPointCloudData];
        }
    } else {
        NSLog(@"⚠️ 点云数据格式不正确，类型：%@", [pointCloudData class]);
        // 使用模拟数据
        [self loadMockPointCloudData];
    }
}

- (void)loadMockPointCloudData {
    // 模拟点云渲染
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    for (int i=0; i<2000; i++) {
        SCNSphere *sphere = [SCNSphere sphereWithRadius:0.008];
        SCNNode *node = [SCNNode nodeWithGeometry:sphere];
        node.position = SCNVector3Make(arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5, arc4random()%100/100.0 - 0.5);
        node.geometry.firstMaterial.diffuse.contents = [UIColor systemBlueColor];
        [pointCloudNode addChildNode:node];
    }
    [self.scnView.scene.rootNode addChildNode:pointCloudNode];
    NSLog(@"✅ 加载模拟点云数据完成");
}

- (UIImage *)captureScreenshot {
    return [self.scnView snapshot];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scnView.frame = self.bounds;
}
@end
