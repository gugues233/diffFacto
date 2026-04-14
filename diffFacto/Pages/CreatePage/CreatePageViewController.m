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
    
    [self restoreFromHistory];
    
    // 👇 右滑关闭
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
        
        // 直接使用itemIndex来选中对应的item
        [self.viewModel selectItemAtIndex:iIndex categoryIndex:cIndex completion:nil];
    }
}

- (void)setupViewModel {
    self.viewModel = [[CreatePageViewModel alloc] init];
    [self.viewModel loadCategoryData];
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
    __weak typeof(self) weakSelf = self;
    [self.viewModel startGenerateCompletion:^(BOOL success, id  _Nullable result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success && result) {
            // TODO: zxy-是需要在这里加缓存？
            
            // ========================
            // 👉 生成成功 → 缓存结果
            // ========================
            [strongSelf.viewModel addGenerateHistory:result];
            [strongSelf.mainView show3DResult:result];
        }
    } progress:^(CGFloat progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // TODO: zxy-生成进度这里，生成新的的时候，没有清空旧的，而且第二次进度条不是从0开始
        [strongSelf.mainView updateGenerateProgress:progress];
    }];
}

- (instancetype)initWithHistory:(NSArray<CreateHistoryModel *> *)history {
    self = [super init];
    if (self) {
        _historyList = history;
    }
    return self;
}

@end
