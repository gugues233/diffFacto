//
//  MyDesignViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignViewModel.h"
#import "CreateHistoryModel.h"
#import "CreatePageViewModel.h"
#import <SceneKit/SceneKit.h>

#define kMaxSelectCount 2

@implementation MyDesignViewModel
- (void)loadLocalCacheModels {
    // 从缓存读取CreateHistoryModel
    CreatePageViewModel *createViewModel = [[CreatePageViewModel alloc] init];
    NSMutableArray<CreateHistoryModel *> *historyList = [createViewModel getGenerateHistory];
    
    // 转换为MyDesignModel
    NSMutableArray *models = [NSMutableArray array];
    for (CreateHistoryModel *history in historyList) {
        // 将点云数据转换为 SCNNode 格式
        SCNNode *pointCloudNode = [self convertPointCloudToSCNNode:history.pointCloudModel];
        
        // 使用真实点云数据生成预览图片
        UIImage *previewImage = [self generatePreviewImageWithPointCloud:history.pointCloudModel];
 
        MyDesignModel *model = [[MyDesignModel alloc] initWithModelId:history.modelId previewImage:previewImage data:pointCloudNode modelType:history.modelType];
        model.createTime = [self formatDate:history.createdDate];
        [models addObject:model];
    }
    
    _modelList = [models copy];
    _selectedList = @[];
    _isLongPressMode = NO;
}

- (UIImage *)generatePreviewImage {
    // 生成一个简单的占位图
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 背景色
    [[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 绘制模拟点云
    for (int i = 0; i < 200; i++) {
        CGFloat x = arc4random() % 180 + 10;
        CGFloat y = arc4random() % 180 + 10;
        CGFloat radius = arc4random() % 3 + 1;
        
        UIColor *color = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(x, y, radius, radius));
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

- (SCNNode *)convertPointCloudToSCNNode:(id)pointCloudData {
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    
    if ([pointCloudData isKindOfClass:[NSArray class]]) {
        NSArray *points = (NSArray *)pointCloudData;
        NSLog(@"📋 转换点云数据，共 %ld 个点", (long)points.count);
        
        // 处理所有点
        for (id pointObj in points) {
            if ([pointObj isKindOfClass:[NSArray class]]) {
                NSArray *point = (NSArray *)pointObj;
                if (point.count >= 3) {
                    CGFloat x = [point[0] floatValue];
                    CGFloat y = [point[1] floatValue];
                    CGFloat z = [point[2] floatValue];
                    
                    SCNGeometry *sphere = [SCNSphere sphereWithRadius:0.01];
                    SCNNode *node = [SCNNode nodeWithGeometry:sphere];
                    node.position = SCNVector3Make(x, y, z);
                    
                    SCNMaterial *material = [SCNMaterial material];
                    material.diffuse.contents = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1.0];
                    sphere.materials = @[material];
                    
                    [pointCloudNode addChildNode:node];
                }
            }
        }
    }
    
    return pointCloudNode;
}

- (UIImage *)generatePreviewImageWithPointCloud:(id)pointCloudData {
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 背景色
    [[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 检查点云数据
    if ([pointCloudData isKindOfClass:[NSArray class]]) {
        NSArray *points = (NSArray *)pointCloudData;
        NSLog(@"📋 生成预览图，点云数据数量：%ld", (long)points.count);
        
        // 绘制真实点云
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8].CGColor);
        
        // 斜上方视角投影参数
        CGFloat scale = 40.0;
        CGFloat centerX = size.width / 2;
        CGFloat centerY = size.height / 2;
        
        // 旋转角度（弧度）
        CGFloat angleX = M_PI;
        CGFloat angleZ = M_PI;
        
        // 只绘制前300个点，避免性能问题
        NSInteger pointCount = points.count;
        for (int i = 0; i < pointCount; i++) {
            id pointObj = points[i];
            if ([pointObj isKindOfClass:[NSArray class]]) {
                NSArray *point = (NSArray *)pointObj;
                if (point.count >= 3) {
                    CGFloat x3d = [point[0] floatValue];
                    CGFloat y3d = [point[1] floatValue];
                    CGFloat z3d = [point[2] floatValue];
                    
                    // 绕Z轴旋转
                    CGFloat x1 = x3d * cos(angleZ) - y3d * sin(angleZ);
                    CGFloat y1 = x3d * sin(angleZ) + y3d * cos(angleZ);
                    CGFloat z1 = z3d;
                    
                    // 绕X轴旋转
                    CGFloat y2 = y1 * cos(angleX) - z1 * sin(angleX);
                    
                    // 投影到2D平面
                    CGFloat x2d = x1 * scale + centerX;
                    CGFloat y2d = -y2 * scale + centerY;
                    
                    // 绘制点
                    CGFloat radius = 1.5;
                    CGContextFillEllipseInRect(context, CGRectMake(x2d - radius, y2d - radius, radius * 2, radius * 2));
                }
            }
        }
    } else {
        // 生成模拟点云
        NSLog(@"📋 生成预览图，使用模拟点云数据");
        for (int i = 0; i < 200; i++) {
            CGFloat x = arc4random() % 180 + 10;
            CGFloat y = arc4random() % 180 + 10;
            CGFloat radius = arc4random() % 3 + 1;
            
            UIColor *color = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(x, y, radius, radius));
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)enterLongPressMode {
    _isLongPressMode = YES;
}

- (void)exitLongPressMode {
    _isLongPressMode = NO;
    [self clearAllSelection];
}

- (BOOL)toggleSelectModelAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.modelList.count) return NO;
    
    MyDesignModel *model = self.modelList[index];
    if (model.isSelected) {
        // 取消选中
        model.isSelected = NO;
        NSMutableArray *newSelected = [NSMutableArray arrayWithArray:self.selectedList];
        [newSelected removeObject:model];
        _selectedList = [newSelected copy];
        return YES;
    } else {
        // 尝试选中
        if (self.selectedList.count >= kMaxSelectCount) {
            return NO; // 已达最大选择数
        }
        model.isSelected = YES;
        NSMutableArray *newSelected = [NSMutableArray arrayWithArray:self.selectedList];
        [newSelected addObject:model];
        _selectedList = [newSelected copy];
        return YES;
    }
}

- (void)clearAllSelection {
    for (MyDesignModel *model in self.modelList) {
        model.isSelected = NO;
    }
    _selectedList = @[];
}

- (BOOL)canSelectMore {
    return self.selectedList.count < kMaxSelectCount;
}

@end
