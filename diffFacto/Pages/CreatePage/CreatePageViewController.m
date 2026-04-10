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

@interface CreatePageViewController () <CreatePageMainViewDelegate, CategoryScrollViewDelegate>
@property (nonatomic, strong) CreatePageMainView *mainView;
@property (nonatomic, strong) CreatePageViewModel *viewModel;
@end

@implementation CreatePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupMainView];
    
    // 👇 右滑关闭
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        }
    }];
}

#pragma mark - CreatePageMainViewDelegate
- (void)generateButtonDidClick {
    __weak typeof(self) weakSelf = self;
    [self.viewModel startGenerateCompletion:^(BOOL success, id  _Nullable result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            [strongSelf.mainView show3DResult:result];
        }
    } progress:^(CGFloat progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.mainView updateGenerateProgress:progress];
    }];
}

@end
