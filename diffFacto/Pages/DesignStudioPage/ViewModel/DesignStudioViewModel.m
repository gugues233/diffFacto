//
//  DesignStudioViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioViewModel.h"

@implementation DesignStudioViewModel
- (void)loadInitialDataWithCompletion:(void(^)(BOOL success))completion {
    // 从后端请求数据
    [self fetchModelsFromBackendWithCompletion:^(BOOL success, NSArray<DesignStudioModel *> *models) {
        if (success) {
            _modelList = models;
        } else {
            // 如果请求失败，使用默认数据
            _modelList = [self getDefaultModels];
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
                
                // 处理点云数据格式
                id processedPointCloudData = [self processPointCloudData:pointCloudData];
                
                // 生成预览图片
                UIImage *previewImage = [self generatePreviewImageWithPointCloud:processedPointCloudData];
                
                // 只有在点云数据处理成功时才创建模型
                if (processedPointCloudData) {
                    DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:modelId previewImage:previewImage data:processedPointCloudData];
                    [models addObject:model];
                } else {
                    NSLog(@"⚠️ 点云数据处理失败，跳过模型：%@", modelId);
                }
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

- (id)processPointCloudData:(id)pointCloudData {
    if (!pointCloudData) {
        NSLog(@"⚠️ 点云数据为空");
        return nil;
    }
    
    NSLog(@"📋 原始点云数据类型：%@", [pointCloudData class]);
    
    // 如果是字符串，尝试解析为 JSON
    if ([pointCloudData isKindOfClass:[NSString class]]) {
        NSString *pointCloudString = (NSString *)pointCloudData;
        NSLog(@"📋 点云数据是字符串，长度：%ld", (long)pointCloudString.length);
        
        // 输出字符串的前200个字符，以便了解其格式
        if (pointCloudString.length > 0) {
            NSString *preview = [pointCloudString substringToIndex:MIN(pointCloudString.length, 200)];
            NSLog(@"📋 点云数据字符串预览：%@", preview);
        }
        
        // 尝试解析为 JSON
        NSError *error = nil;
        NSData *jsonData = [pointCloudString dataUsingEncoding:NSUTF8StringEncoding];
        id parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (!error && parsedData) {
            return [self processPointCloudData:parsedData];
        }
        
        NSLog(@"⚠️ 解析点云数据失败：%@", error.localizedDescription);
        
        // 尝试其他解析方式，例如直接从字符串中提取点云数据
        // 这里可以根据实际情况添加更多的解析逻辑
        
        // 尝试直接从字符串中提取点云数据
        // 假设字符串格式为："[[x1,y1,z1],[x2,y2,z2],...]"
        NSString *cleanString = [pointCloudString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([cleanString hasPrefix:@"["] && [cleanString hasSuffix:@"]"]) {
            // 移除首尾的 []
            cleanString = [cleanString substringWithRange:NSMakeRange(1, cleanString.length - 2)];
            
            // 分割字符串为点
            NSArray *pointStrings = [cleanString componentsSeparatedByString:@"],["];
            NSMutableArray *points = [NSMutableArray array];
            
            for (NSString *pointString in pointStrings) {
                // 清理每个点的字符串
                NSString *cleanPointString = [pointString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cleanPointString = [cleanPointString stringByReplacingOccurrencesOfString:@"[" withString:@""];
                cleanPointString = [cleanPointString stringByReplacingOccurrencesOfString:@"]" withString:@""];
                
                // 分割为坐标
                NSArray *coordinates = [cleanPointString componentsSeparatedByString:@","];
                if (coordinates.count >= 3) {
                    // 尝试转换为数字
                    NSMutableArray *point = [NSMutableArray array];
                    for (NSString *coord in coordinates) {
                        NSNumber *num = @([coord floatValue]);
                        [point addObject:num];
                    }
                    [points addObject:point];
                }
            }
            
            if (points.count > 0) {
                NSLog(@"✅ 从字符串中提取点云数据，共 %ld 个点", (long)points.count);
                return points;
            }
        }
    }
    
    // 如果是数组
    if ([pointCloudData isKindOfClass:[NSArray class]]) {
        NSArray *pointArray = (NSArray *)pointCloudData;
        
        // 检查是否是嵌套数组
        if (pointArray.count == 1 && [pointArray.firstObject isKindOfClass:[NSArray class]]) {
            NSLog(@"📋 检测到嵌套数组，解包后点云数量：%ld", (long)((NSArray *)pointArray.firstObject).count);
            return [self processPointCloudData:pointArray.firstObject];
        }
        
        // 验证第一个点的格式
        if (pointArray.count > 0) {
            id firstPoint = pointArray.firstObject;
            NSLog(@"📋 第一个点类型：%@", [firstPoint class]);
            if ([firstPoint isKindOfClass:[NSArray class]] && [(NSArray *)firstPoint count] >= 3) {
                NSLog(@"✅ 点云数据格式正确，共 %ld 个点", (long)pointArray.count);
                return pointArray;
            } else if ([firstPoint isKindOfClass:[NSDictionary class]]) {
                // 尝试从字典中提取点云数据
                NSLog(@"📋 第一个点是字典，尝试提取坐标");
                NSMutableArray *points = [NSMutableArray array];
                for (NSDictionary *pointDict in pointArray) {
                    if ([pointDict isKindOfClass:[NSDictionary class]]) {
                        // 尝试从字典中提取 x, y, z 坐标
                        NSNumber *x = pointDict[@"x"];
                        NSNumber *y = pointDict[@"y"];
                        NSNumber *z = pointDict[@"z"];
                        if (x && y && z) {
                            [points addObject:@[x, y, z]];
                        }
                    }
                }
                if (points.count > 0) {
                    NSLog(@"✅ 从字典中提取点云数据，共 %ld 个点", (long)points.count);
                    return points;
                } else {
                    NSLog(@"⚠️ 无法从字典中提取点云数据");
                }
            } else {
                NSLog(@"⚠️ 点格式不正确，期望包含3个坐标值");
            }
        } else {
            NSLog(@"⚠️ 点云数据为空数组");
        }
    }
    
    // 如果是字典，尝试从中提取点云数据
    if ([pointCloudData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *pointCloudDict = (NSDictionary *)pointCloudData;
        NSLog(@"📋 点云数据是字典，尝试提取点云数据");
        
        // 尝试从字典中提取点云数据
        id points = pointCloudDict[@"points"];
        if (points) {
            return [self processPointCloudData:points];
        }
        
        // 尝试从字典中提取 point_cloud 字段
        id pointCloud = pointCloudDict[@"point_cloud"];
        if (pointCloud) {
            return [self processPointCloudData:pointCloud];
        }
        
        NSLog(@"⚠️ 无法从字典中提取点云数据");
    }
    
    NSLog(@"⚠️ 点云数据格式不正确");
    return nil;
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
        CGFloat scale = 40.0; // 缩放因子
        CGFloat centerX = size.width / 2;
        CGFloat centerY = size.height / 2;
        
        // 旋转角度（弧度）
        CGFloat angleX = M_PI / 6; // 绕X轴旋转30度（向下倾斜）
        CGFloat angleZ = M_PI / 4;  // 绕Z轴旋转45度（侧面视角）
        
        // 只绘制前300个点，避免性能问题
        NSInteger pointCount = MIN(points.count, 300);
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
                    CGFloat z2 = y1 * sin(angleX) + z1 * cos(angleX);
                    
                    // 投影到2D平面
                    CGFloat x2d = x1 * scale + centerX;
                    CGFloat y2d = -y2 * scale + centerY; // 注意Y轴方向
                    
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

- (NSArray<DesignStudioModel *> *)getDefaultModels {
    // 生成默认数据，当网络请求失败时使用
    NSMutableArray *models = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        // 生成预览图片
        UIImage *preview = [self generatePreviewImageWithPointCloud:nil];
        DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:[NSString stringWithFormat:@"studio_%d", i] previewImage:preview data:nil];
        [models addObject:model];
    }
    return [models copy];
}

@end
