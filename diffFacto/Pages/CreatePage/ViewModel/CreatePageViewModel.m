//
//  CreatePageViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CreatePageViewModel.h"
#import "CreateHistoryModel.h"

@interface CreatePageViewModel ()

// 在 ViewModel.h 或者 ViewModel.m 里添加
@property (nonatomic, strong) NSMutableArray *generateHistoryList;
// 添加属性存储模型类型
@property (nonatomic, copy) NSString *modelType;


@end

@implementation CreatePageViewModel
// 修改 loadCategoryData 方法
- (void)loadCategoryDataWithModelType:(NSString *)modelType completion:(void(^)(BOOL success))completion {
    self.modelType = modelType;
    
    // 从后端获取风格库数据
    [self fetchStyleLibraryFromBackendWithModelType:modelType completion:^(BOOL success, NSDictionary *styleLibraryData) {
        if (success) {
            // 解析风格库数据
            NSMutableArray *categories = [NSMutableArray array];
            NSLog(@"📋 开始解析风格库数据，共有 %ld 个部位", styleLibraryData.allKeys.count);
            
            // 遍历风格库中的每个部位
            for (NSString *partName in styleLibraryData.allKeys) {
                NSArray *styles = styleLibraryData[partName];
                NSLog(@"📋 处理部位：%@，共有 %ld 个风格", partName, styles.count);
                
                NSMutableArray *items = [NSMutableArray array];
                for (int i = 0; i < styles.count; i++) {
                    NSDictionary *styleData = styles[i];
                    NSString *itemId = [NSString stringWithFormat:@"%@_%d", partName, i];
                    NSString *itemName = [NSString stringWithFormat:@"%@风格%d", partName, i+1];
                    
                    // 创建预览图片 - 使用点云数据生成预览
                    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
                    
                    // 使用白色背景
                    [[UIColor whiteColor] setFill];
                    UIRectFill(CGRectMake(0, 0, 100, 100));
                    
                    // 尝试从styleData中获取点云数据
                    NSArray *points = styleData[@"points"];
                    if (points && [points isKindOfClass:[NSArray class]] && points.count > 0) {
                        // 绘制点云
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                        
                        // 斜上方视角投影参数
                        CGFloat scale = 15.0; // 缩放因子
                        CGFloat centerX = 50.0;
                        CGFloat centerY = 50.0;
                        
                        // 旋转角度（弧度）
                        CGFloat angleX = M_PI / 6; // 绕X轴旋转30度（向下倾斜）
                        CGFloat angleZ = M_PI / 4;  // 绕Z轴旋转45度（侧面视角）
                        
                        // 只绘制前200个点，避免性能问题
                        NSInteger pointCount = MIN(points.count, 200);
                        for (int j = 0; j < pointCount; j++) {
                            NSArray *point = points[j];
                            if ([point isKindOfClass:[NSArray class]] && point.count >= 3) {
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
                                CGContextFillEllipseInRect(context, CGRectMake(x2d-1, y2d-1, 2, 2));
                            }
                        }
                    } else {
                        // 如果没有点云数据，使用文本作为占位符
                        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
                        textStyle.alignment = NSTextAlignmentCenter;
                        
                        NSDictionary *attributes = @{
                            NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium],
                            NSForegroundColorAttributeName: [UIColor darkTextColor],
                            NSParagraphStyleAttributeName: textStyle
                        };
                        
                        [itemName drawInRect:CGRectMake(0, 40, 100, 20) withAttributes:attributes];
                    }
                    
                    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    if (img) {
                        NSLog(@"✅ 成功创建图片：%@，大小：%@", itemName, NSStringFromCGSize(img.size));
                        
                        // 保存图片到文档目录，以便查看
                        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", itemName]];
                        NSData *imageData = UIImagePNGRepresentation(img);
                        [imageData writeToFile:imagePath atomically:YES];
                        NSLog(@"✅ 图片保存到：%@", imagePath);
                    } else {
                        NSLog(@"❌ 创建图片失败：%@", itemName);
                    }
                    
                    CreateItemModel *item = [[CreateItemModel alloc] initWithImage:img name:itemName];
                    item.itemId = itemId;
                    item.styleData = styleData; // 存储风格数据
                    [items addObject:item];
                    NSLog(@"✅ 添加风格项：%@", itemName);
                }
                NSLog(@"📋 部位 %@ 处理完成，共 %ld 个风格", partName, items.count);
                
                CreateCategoryModel *category = [[CreateCategoryModel alloc] initWithName:partName items:items];
                [categories addObject:category];
                NSLog(@"✅ 添加分类：%@，共 %ld 个风格", partName, items.count);
            }
            
            _categoryList = categories;
            _selectedList = @[];
            _generateProgress = 0;
            NSLog(@"✅ 风格库数据解析完成，共 %ld 个分类", categories.count);
            
            if (completion) completion(YES);
        } else {
            // 使用默认数据
            NSLog(@"⚠️ 使用默认数据");
            [self loadDefaultCategoryData];
            if (completion) completion(NO);
        }
    }];
}

- (void)loadDefaultCategoryData {
    // 加载默认数据
    NSMutableArray *categories = [NSMutableArray array];
    
    // 默认部位：back, seat, leg, arm
    NSArray *partNames = @[@"back", @"seat", @"leg", @"arm"];
    
    for (NSString *partName in partNames) {
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            NSString *itemId = [NSString stringWithFormat:@"%@_%d", partName, i];
            NSString *itemName = [NSString stringWithFormat:@"%@风格%d", partName, i+1];
            
            // 创建默认图片
            UIGraphicsBeginImageContext(CGSizeMake(100, 100));
            [[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0] setFill];
            UIRectFill(CGRectMake(0, 0, 100, 100));
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            CreateItemModel *item = [[CreateItemModel alloc] initWithImage:img name:itemName];
            item.itemId = itemId;
            [items addObject:item];
        }
        
        CreateCategoryModel *category = [[CreateCategoryModel alloc] initWithName:partName items:items];
        [categories addObject:category];
    }
    
    _categoryList = categories;
    _selectedList = @[];
    _generateProgress = 0;
}

- (void)fetchStyleLibraryFromBackendWithModelType:(NSString *)modelType completion:(void(^)(BOOL success, NSDictionary *styleLibraryData))completion {
    // 构建请求
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:6006/api/style-library?model_type=%@", [modelType stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"⚠️ 请求风格库数据失败：%@", error.localizedDescription);
            if (completion) completion(NO, nil);
            return;
        }
        
        // 处理响应
        if (data) {
            NSError *jsonError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                NSLog(@"⚠️ 解析响应失败：%@", jsonError.localizedDescription);
                if (completion) completion(NO, nil);
                return;
            }
            
            // 解析风格库数据
            BOOL success = [responseDict[@"success"] boolValue];
            if (success) {
                NSDictionary *dataDict = responseDict[@"data"];
                NSDictionary *styleLibraryData = dataDict[@"style_library"];
                NSLog(@"✅ 成功获取风格库数据，包含 %ld 个部位", styleLibraryData.count);
                if (completion) completion(YES, styleLibraryData);
            } else {
                NSLog(@"⚠️ 后端返回失败：%@", responseDict[@"message"]);
                if (completion) completion(NO, nil);
            }
        } else {
            NSLog(@"⚠️ 未收到响应数据");
            if (completion) completion(NO, nil);
        }
    }];
    [task resume];
}

- (void)selectItemAtIndex:(NSInteger)itemIndex categoryIndex:(NSInteger)categoryIndex completion:(void(^)(BOOL success))completion {
    if (categoryIndex < 0 || categoryIndex >= self.categoryList.count) {
        if (completion) completion(NO);
        return;
    }
    
    CreateCategoryModel *category = self.categoryList[categoryIndex];
    if (itemIndex < 0 || itemIndex >= category.itemList.count) {
        if (completion) completion(NO);
        return;
    }
    
    // 取消同分类旧选中
    if (category.selectedIndex >= 0) {
        CreateItemModel *oldItem = category.itemList[category.selectedIndex];
        oldItem.isSelected = NO;
    }
    
    // 设置新选中
    CreateItemModel *newItem = category.itemList[itemIndex];
    newItem.isSelected = YES;
    category.selectedIndex = itemIndex;
    
    // 更新已选列表
    NSMutableArray *newSelected = [NSMutableArray array];
    for (int i=0; i<self.categoryList.count; i++) {
        CreateCategoryModel *cat = self.categoryList[i];
        if (cat.selectedIndex >= 0) {
            CreateItemModel *item = cat.itemList[cat.selectedIndex];
            CreateSelectedItemModel *selected = [[CreateSelectedItemModel alloc] initWithCategory:cat.categoryName itemName:item.itemName image:item.itemImage categoryIndex:i itemIndex:cat.selectedIndex];
            [newSelected addObject:selected];
        }
    }
    _selectedList = [newSelected copy];
    
    if (completion) completion(YES);
}

// 修改 startGenerateCompletion 方法
- (void)startGenerateCompletion:(void(^)(BOOL success, id _Nullable result))completion progress:(void(^)(CGFloat progress))progressBlock {
    // 模拟后端生成进度
    __block CGFloat progress = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // 先显示加载进度
        while (progress < 0.7) {
            progress += 0.01;
            _generateProgress = progress;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) progressBlock(progress);
            });
            [NSThread sleepForTimeInterval:0.05];
        }
        
        // 从后端获取点云数据
        [self fetchPointCloudFromBackendWithCompletion:^(BOOL success, id pointCloudData) {
            // 完成剩余进度
            while (progress < 1.0) {
                progress += 0.01;
                _generateProgress = progress;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) progressBlock(progress);
                });
                [NSThread sleepForTimeInterval:0.02];
            }
            
            // 生成完成，返回点云数据
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(success, pointCloudData);
            });
        }];
    });
}

- (void)resetAllSelection {
    for (CreateCategoryModel *category in self.categoryList) {
        if (category.selectedIndex >= 0) {
            CreateItemModel *item = category.itemList[category.selectedIndex];
            item.isSelected = NO;
            category.selectedIndex = -1;
        }
    }
    _selectedList = @[];
    _generateProgress = 0;
}

- (void)restoreSelectedItem:(id)item categoryIndex:(NSInteger)cIndex {
    if (cIndex >= self.categoryList.count) return;
    
    // 取出分类
    id category = self.categoryList[cIndex];
    
    // 用 KVC 取 itemList（兼容 id 类型，不报错）
    NSArray *itemList = [category valueForKey:@"itemList"];
    
    // 遍历对比
    for (id obj in itemList) {
        // 对比 itemId（安全判断）
        if ([obj isEqual:item]) {
            NSInteger index = [itemList indexOfObject:obj];
            [self selectItemAtIndex:index categoryIndex:cIndex completion:nil];
            break;
        }
        
        id objId = [obj valueForKey:@"itemId"];
        id itemId = [item valueForKey:@"itemId"];
        if (objId && itemId && [objId isEqual:itemId]) {
            NSInteger index = [itemList indexOfObject:obj];
            [self selectItemAtIndex:index categoryIndex:cIndex completion:nil];
            break;
        }
    }
}

- (void)fetchPointCloudFromBackendWithCompletion:(void(^)(BOOL success, id pointCloudData))completion {
    // 构建请求
    NSString *urlString = @"http://localhost:6006/api/generate";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 准备请求参数
    NSMutableDictionary *selectedStyles = [NSMutableDictionary dictionary];
    for (CreateSelectedItemModel *selectedItem in self.selectedList) {
        // 找到对应的item，获取风格数据
        CreateCategoryModel *category = self.categoryList[selectedItem.categoryIndex];
        CreateItemModel *item = category.itemList[selectedItem.itemIndex];
        selectedStyles[selectedItem.categoryName] = item.styleData;
    }
    
    NSDictionary *requestBody = @{
        @"model_type": self.modelType ?: @"chair",
        @"selected_styles": selectedStyles
    };
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"⚠️ 构建请求参数失败：%@", error.localizedDescription);
        if (completion) completion(NO, nil);
        return;
    }
    
    [request setHTTPBody:jsonData];
    
    // 发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"⚠️ 请求点云数据失败：%@", error.localizedDescription);
            if (completion) completion(NO, nil);
            return;
        }
        
        // 处理响应
        if (data) {
            NSError *jsonError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
                NSLog(@"⚠️ 解析响应失败：%@", jsonError.localizedDescription);
                if (completion) completion(NO, nil);
                return;
            }
            
            // 解析点云数据
            BOOL success = [responseDict[@"success"] boolValue];
            if (success) {
                NSDictionary *dataDict = responseDict[@"data"];
                id pointCloudData = dataDict[@"point_cloud"];
                
                NSLog(@"📋 point_cloud 类型：%@，是否为数组：%@", [pointCloudData class], [pointCloudData isKindOfClass:[NSArray class]] ? @"是" : @"否");
                
                NSArray *finalPointCloud = nil;
                
                if ([pointCloudData isKindOfClass:[NSArray class]]) {
                    NSArray *pointArray = (NSArray *)pointCloudData;
                    
                    // 检查是否是嵌套数组（后端返回的数据可能被额外包装了一层）
                    if (pointArray.count == 1 && [pointArray.firstObject isKindOfClass:[NSArray class]]) {
                        // 取出第一个元素作为实际的点云数据
                        finalPointCloud = pointArray.firstObject;
                        NSLog(@"📋 检测到嵌套数组，解包后点云数量：%ld", (long)finalPointCloud.count);
                    } else {
                        // 直接使用原数组
                        finalPointCloud = pointArray;
                        NSLog(@"📋 直接使用点云数据，数量：%ld", (long)finalPointCloud.count);
                    }
                    
                    // 验证第一个点的格式
                    if (finalPointCloud.count > 0) {
                        id firstPoint = finalPointCloud.firstObject;
                        NSLog(@"📋 第一个点类型：%@，是否为数组：%@", [firstPoint class], [firstPoint isKindOfClass:[NSArray class]] ? @"是" : @"否");
                        if ([firstPoint isKindOfClass:[NSArray class]] && [(NSArray *)firstPoint count] >= 3) {
                            NSLog(@"✅ 成功获取点云数据，共 %ld 个点", (long)finalPointCloud.count);
                        } else {
                            NSLog(@"⚠️ 点格式不正确，期望包含3个坐标值");
                        }
                    }
                } else {
                    NSLog(@"⚠️ 点云数据格式不正确，类型：%@", [pointCloudData class]);
                }
                
                if (completion) completion(YES, finalPointCloud);
            } else {
                NSLog(@"⚠️ 后端返回失败：%@", responseDict[@"message"]);
                if (completion) completion(NO, nil);
            }
        } else {
            NSLog(@"⚠️ 未收到响应数据");
            if (completion) completion(NO, nil);
        }
    }];
    [task resume];
}

#pragma mark - 缓存
- (void)addGenerateHistory:(id)result {
    if (!result) return;

    // 初始化数组
    if (!_generateHistoryList) {
        _generateHistoryList = [NSMutableArray array];
    }

    // 创建CreateHistoryModel对象
    // 为每个模型生成唯一的名称，使用时间戳
    NSString *uniqueName = [NSString stringWithFormat:@"我的设计_%d", (int)[[NSDate date] timeIntervalSince1970]];
    CreateHistoryModel *historyModel = [[CreateHistoryModel alloc] initWithProductName:uniqueName selectedItems:[self.selectedList copy] pointCloudModel:result];
    
    // 追加新数据
    [_generateHistoryList addObject:historyModel];

    // 保存到本地
    [self saveHistoryToLocal];
}

// 保存到本地
- (void)saveHistoryToLocal {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"GenerateHistory.data"];
    [NSKeyedArchiver archiveRootObject:self.generateHistoryList toFile:filePath];
    NSLog(@"✅ 缓存成功：%@", filePath);
}

// 读取历史
- (NSMutableArray *)getGenerateHistory {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"GenerateHistory.data"];
    NSMutableArray *historyList = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return historyList ? historyList : [NSMutableArray array];
}
@end
