//
//  CreatePageViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CreatePageViewController.h"
#import "CreatePageMainView.h"
#import "CreatePageViewModel.h"
#import "CategoryItemCell.h"
#import "CreateHistoryModel.h"

@interface CreatePageViewController () <CreatePageMainViewDelegate, CategoryScrollViewDelegate>
@property (nonatomic, strong) CreatePageMainView *mainView;
@property (nonatomic, strong) CreatePageViewModel *viewModel;
@property (nonatomic, strong) NSArray<CreateHistoryModel *> *historyList;
@end

@implementation CreatePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupMainView];
    
    // 重新加载分类滚动视图，更新选中状态
    [self.mainView.categoryScrollView reloadData];
    
    // 加载数据
    NSString *modelType = self.modelType ?: @"chair";
    NSLog(@"📋 当前模型类型：%@", modelType);
    [self.viewModel loadCategoryDataWithModelType:modelType completion:^(BOOL success) {
        if (success) {
            NSLog(@"✅ 风格库数据加载成功");
        } else {
            NSLog(@"⚠️ 风格库数据加载失败，使用默认数据");
        }
        
        // 检查数据
        NSLog(@"📋 分类数量：%ld", self.viewModel.categoryList.count);
        for (int i = 0; i < self.viewModel.categoryList.count; i++) {
            CreateCategoryModel *category = self.viewModel.categoryList[i];
            NSLog(@"📋 分类 %d：%@，风格数量：%ld", i, category.categoryName, category.itemList.count);
            for (int j = 0; j < category.itemList.count; j++) {
                CreateItemModel *item = category.itemList[j];
                NSLog(@"📋 风格 %d：%@，图片是否存在：%@", j, item.itemName, item.itemImage ? @"是" : @"否");
            }
        }
        
        // 确保在主线程上执行UI操作
        dispatch_async(dispatch_get_main_queue(), ^{ 
            // 刷新UI
            NSLog(@"📋 开始刷新UI");
            self.mainView.categoryScrollView.categoryList = self.viewModel.categoryList;
            NSLog(@"📋 设置categoryList完成");
            [self.mainView.categoryScrollView reloadData];
            NSLog(@"📋 刷新UI完成");
            
            // 恢复历史记录
            [self restoreFromHistory];
        });
    }];
    
    // 👇 右滑关闭
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// TODO: zxy-这里怎么也能直接取最新的一条呢？？
- (void)restoreFromHistory {
    if (!self.historyList.count) return;
    
    // 获取最近的一条历史记录
    CreateHistoryModel *latestHistory = self.historyList.firstObject;
    if (!latestHistory.selectedItems.count) return;
    
    // 遍历selectedItems，恢复选择
    for (CreateSelectedItemModel *selectedItem in latestHistory.selectedItems) {
        NSInteger cIndex = selectedItem.categoryIndex;
        NSInteger iIndex = selectedItem.itemIndex;
        
        if (cIndex >= self.viewModel.categoryList.count) continue;
        if (iIndex < 0) continue;
        
        CreateCategoryModel *category = self.viewModel.categoryList[cIndex];
        if (iIndex >= category.itemList.count) continue;
        
        // TODO: zxy-这又是个啥逻辑？
        // 直接使用itemIndex来选中对应的item
        [self.viewModel selectItemAtIndex:iIndex categoryIndex:cIndex completion:nil];
    }
}

- (void)setupViewModel {
    self.viewModel = [[CreatePageViewModel alloc] init];
}

- (void)setupMainView {
    self.mainView = [[CreatePageMainView alloc] initWithFrame:self.view.bounds];
    self.mainView.delegate = self;
    self.mainView.categoryScrollView.delegate = self;
    self.mainView.categoryScrollView.categoryList = self.viewModel.categoryList;
    [self.view addSubview:self.mainView];
}

#pragma mark - CategoryScrollViewDelegate
- (void)categoryItemDidSelect:(NSInteger)itemIndex categoryIndex:(NSInteger)categoryIndex fromView:(UIView *)fromView {
    __weak typeof(self) weakSelf = self;
    [self.viewModel selectItemAtIndex:itemIndex categoryIndex:categoryIndex completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            // 更新列表
            [strongSelf.mainView updateSelectedList:strongSelf.viewModel.selectedList];
            // 执行飞行动画
            [strongSelf.mainView addItemAnimationFromView:fromView];
            // 重新加载分类滚动视图，更新选中状态
            [strongSelf.mainView.categoryScrollView reloadData];
        }
    }];
}

#pragma mark - CreatePageMainViewDelegate
- (void)generateButtonDidClick {
    // 清空旧的点云和重置进度条
    [self.mainView.previewView resetPreview];
    
    __weak typeof(self) weakSelf = self;
    [self.viewModel startGenerateCompletion:^(BOOL success, id _Nullable result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success && result) {
            [strongSelf.viewModel addGenerateHistory:result modelId:strongSelf.viewModel.currentModelId];
            [strongSelf.mainView show3DResult:result];
        }
    } progress:^(CGFloat progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.mainView updateGenerateProgress:progress];
    }];
}

- (instancetype)initWithModelType:(NSString *)modelType history:(NSArray<CreateHistoryModel *> *)history {
    self = [super init];
    if (self) {
        _modelType = modelType ?: @"chair";
        _historyList = history;
    }
    return self;
}


- (instancetype)initWithModelType:(NSString *)modelType selectedItems:(NSArray *)selectedItems pointCloudModel:(id)pointCloudModel {
    self = [super init];
    if (self) {
        _modelType = modelType;
        _selectedItems = selectedItems;
        _pointCloudModel = pointCloudModel;
    }
    return self;
}

@end
