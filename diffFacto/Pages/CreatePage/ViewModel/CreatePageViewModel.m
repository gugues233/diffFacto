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
    // 模拟分类数据（实际项目从后端获取）
    NSMutableArray *categories = [NSMutableArray array];
    
    // 分类1：背景
    NSMutableArray *bgItems = [NSMutableArray array];
    for (int i=0; i<6; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%d", i]];
        CreateItemModel *item = [[CreateItemModel alloc] initWithImage:img name:[NSString stringWithFormat:@"bg_%d", i]];
        [bgItems addObject:item];
    }
    CreateCategoryModel *bgCategory = [[CreateCategoryModel alloc] initWithName:@"背景" items:bgItems];
    [categories addObject:bgCategory];
    
    // 分类2：腿
    NSMutableArray *legItems = [NSMutableArray array];
    for (int i=0; i<6; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"leg_%d", i]];
        CreateItemModel *item = [[CreateItemModel alloc] initWithImage:img name:[NSString stringWithFormat:@"leg_%d", i]];
        [legItems addObject:item];
    }
    CreateCategoryModel *legCategory = [[CreateCategoryModel alloc] initWithName:@"腿" items:legItems];
    [categories addObject:legCategory];
    
    _categoryList = [categories copy];
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
    CreateHistoryModel *historyModel = [[CreateHistoryModel alloc] initWithProductName:@"我的设计" selectedItems:[self.selectedList copy] pointCloudModel:result];
    
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
