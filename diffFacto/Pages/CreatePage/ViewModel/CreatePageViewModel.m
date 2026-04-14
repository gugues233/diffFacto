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

@end

@implementation CreatePageViewModel
- (void)loadCategoryData {
    // 模拟后端数据传输和解析
    NSDictionary *mockBackendData = @{
        @"categories": @[
            @{
                @"name": @"背景",
                @"items": @[
                    @{@"id": @"bg_0", @"name": @"背景1", @"image": @"bg_0"},
                    @{@"id": @"bg_1", @"name": @"背景2", @"image": @"bg_1"},
                    @{@"id": @"bg_2", @"name": @"背景3", @"image": @"bg_2"},
                    @{@"id": @"bg_3", @"name": @"背景4", @"image": @"bg_3"},
                    @{@"id": @"bg_4", @"name": @"背景5", @"image": @"bg_4"},
                    @{@"id": @"bg_5", @"name": @"背景6", @"image": @"bg_5"}
                ]
            },
            @{
                @"name": @"腿",
                @"items": @[
                    @{@"id": @"leg_0", @"name": @"腿1", @"image": @"leg_0"},
                    @{@"id": @"leg_1", @"name": @"腿2", @"image": @"leg_1"},
                    @{@"id": @"leg_2", @"name": @"腿3", @"image": @"leg_2"},
                    @{@"id": @"leg_3", @"name": @"腿4", @"image": @"leg_3"},
                    @{@"id": @"leg_4", @"name": @"腿5", @"image": @"leg_4"},
                    @{@"id": @"leg_5", @"name": @"腿6", @"image": @"leg_5"}
                ]
            },
            @{
                @"name": @"桌面",
                @"items": @[
                    @{@"id": @"table_0", @"name": @"桌面1", @"image": @"table_0"},
                    @{@"id": @"table_1", @"name": @"桌面2", @"image": @"table_1"},
                    @{@"id": @"table_2", @"name": @"桌面3", @"image": @"table_2"},
                    @{@"id": @"table_3", @"name": @"桌面4", @"image": @"table_3"},
                    @{@"id": @"table_4", @"name": @"桌面5", @"image": @"table_4"},
                    @{@"id": @"table_5", @"name": @"桌面6", @"image": @"table_5"}
                ]
            }
        ]
    };
    
    // 解析后端数据
    NSMutableArray *categories = [NSMutableArray array];
    NSArray *backendCategories = mockBackendData[@"categories"];
    
    for (NSDictionary *categoryDict in backendCategories) {
        NSString *categoryName = categoryDict[@"name"];
        NSArray *itemDicts = categoryDict[@"items"];
        
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *itemDict in itemDicts) {
            NSString *itemId = itemDict[@"id"];
            NSString *itemName = itemDict[@"name"];
            NSString *imageName = itemDict[@"image"];
            
            // 模拟图片加载，如果图片不存在则使用默认图片
            UIImage *img = [UIImage imageNamed:imageName];
            if (!img) {
                // 创建一个简单的彩色图片作为默认值
                UIGraphicsBeginImageContext(CGSizeMake(100, 100));
                [[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0] setFill];
                UIRectFill(CGRectMake(0, 0, 100, 100));
                img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            CreateItemModel *item = [[CreateItemModel alloc] initWithImage:img name:itemName];
            item.itemId = itemId;
            [items addObject:item];
        }
        
        CreateCategoryModel *category = [[CreateCategoryModel alloc] initWithName:categoryName items:items];
        [categories addObject:category];
    }
    
    _categoryList = categories;
    _selectedList = @[];
    _generateProgress = 0;
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

- (void)startGenerateCompletion:(void(^)(BOOL success, id _Nullable result))completion progress:(void(^)(CGFloat progress))progressBlock {
    // 模拟后端生成进度（实际项目替换为网络请求）
    __block CGFloat progress = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        while (progress < 1.0) {
            progress += 0.01;
            _generateProgress = progress;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) progressBlock(progress);
            });
            [NSThread sleepForTimeInterval:0.05];
        }
        
        // 生成完成，返回3D点云数据（实际项目为后端返回的模型数据）
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(YES, @"3D_point_cloud_data");
        });
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
