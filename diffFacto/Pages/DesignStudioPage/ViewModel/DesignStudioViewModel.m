//
//  DesignStudioViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioViewModel.h"
#import <SceneKit/SceneKit.h>

@implementation DesignStudioViewModel
- (void)loadInitialDataWithCompletion:(void(^)(BOOL success))completion {
    // 从后端请求数据
    [self fetchModelsFromBackendWithCompletion:^(BOOL success, NSArray<DesignStudioModel *> *models) {
        if (success) {
            _modelList = models;
        } else {
            // 如果请求失败，使用默认数据
            _modelList = [self getDefaultModels];
            if (self.showAlertBlock) {
                self.showAlertBlock(@"提示", @"请求失败，已加载模拟数据");
            }
        }
        _isRefreshing = NO;
        if (completion) completion(YES);
    }];
}

- (void)refreshNewDataCompletion:(void(^)(BOOL success))completion {
    _isRefreshing = YES;
    // 从后端请求新数据
    [self fetchModelsFromBackendWithCompletion:^(BOOL success, NSArray<DesignStudioModel *> *models) {
        if (success) {
            _modelList = models;
            if (completion) completion(YES);
        } else {
            if (completion) completion(NO);
        }
        _isRefreshing = NO;
    }];
}

- (void)fetchModelsFromBackendWithCompletion:(void(^)(BOOL success, NSArray<DesignStudioModel *> *models))completion {
    // 构建请求
    NSString *urlString = @"http://localhost:6006/api/models/public";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"⚠️ 请求模型列表失败：%@", error.localizedDescription);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, nil);
                });
            }
            return;
        }
        
        // 处理响应
        if (data) {
            NSError *jsonError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                NSLog(@"⚠️ 解析响应失败：%@", jsonError.localizedDescription);
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NO, nil);
                    });
                }
                return;
            }
            
            // 解析模型数据
            NSArray *modelsArray = responseDict[@"data"];
            NSMutableArray *models = [NSMutableArray array];
            
            for (NSDictionary *modelDict in modelsArray) {
                NSString *modelId = modelDict[@"model_id"];
                id pointCloudData = modelDict[@"point_cloud_data"];
                NSString *modelType = modelDict[@"model_type"];
                
                // 转换点云数据为 SCNNode
                SCNNode *pointCloudNode = [self convertPointCloudToSCNNode:pointCloudData];
                
                // 使用默认图片作为预览图
                UIImage *previewImage = [UIImage imageNamed:@"studio_preview_0"];
                
                DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:modelId previewImage:previewImage data:pointCloudNode modelType:modelType];
                [models addObject:model];
            }
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, [models copy]);
                });
            }
        } else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, nil);
                });
            }
        }
    }];
    [task resume];
}

// 转换请求到的点云数据为 SCNNode
- (SCNNode *)convertPointCloudToSCNNode:(id)pointCloudData {
    SCNNode *pointCloudNode = [[SCNNode alloc] init];
    
    id processedData = pointCloudData;
    
    // 如果是字符串格式，先解析为JSON
    if ([pointCloudData isKindOfClass:[NSString class]] || [pointCloudData isKindOfClass:[NSMutableString class]]) {
        NSLog(@"📋 点云数据是字符串格式，解析JSON");
        NSString *jsonString = (NSString *)pointCloudData;
        if (jsonString.length > 0) {
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            id parsed = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (!error && parsed) {
                processedData = parsed;
            } else {
                NSLog(@"⚠️ 解析点云JSON失败：%@", error);
            }
        }
    }
    
    if ([processedData isKindOfClass:[NSArray class]]) {
        NSArray *points = (NSArray *)processedData;
        NSLog(@"📋 转换点云数据，共 %ld 个点", (long)points.count);
        
        // 只处理全部点
        NSInteger pointCount = points.count;
        for (int i=0; i<pointCount; i++) {
            id pointObj = points[i];
            if ([pointObj isKindOfClass:[NSArray class]]) {
                NSArray *point = (NSArray *)pointObj;
                if (point.count >= 3) {
                    // 获取坐标
                    CGFloat x = [point[0] floatValue];
                    CGFloat y = [point[1] floatValue];
                    CGFloat z = [point[2] floatValue];
                    
                    // 创建球体作为点
                    SCNGeometry *sphere = [SCNSphere sphereWithRadius:0.01];
                    SCNNode *node = [SCNNode nodeWithGeometry:sphere];
                    node.position = SCNVector3Make(x, y, z);
                    
                    // 设置颜色
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

- (NSArray<DesignStudioModel *> *)getDefaultModels {
    // 生成默认数据，当网络请求失败时使用
    NSMutableArray *models = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        UIImage *preview = [UIImage imageNamed:[NSString stringWithFormat:@"studio_preview_%d", i]];
        DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:[NSString stringWithFormat:@"studio_%d", i] previewImage:preview data:nil modelType:@"chair"];
        [models addObject:model];
    }
    return [models copy];
}

@end
