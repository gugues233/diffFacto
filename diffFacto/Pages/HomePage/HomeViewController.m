//
//  HomeViewController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "HomeViewModel.h"
#import "HomeModel.h"
// 导入要跳转的页面
#import "carouselViewController.h"
//#import "MyDesignViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong) HomeView *mainView;
@property (nonatomic, strong) HomeViewModel *viewModel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创作"; // 页面标题（对应TabBar的“创作”）
    [self setupViewModel];
    [self setupMainView];
}

- (void)setupViewModel {
    self.viewModel = [[HomeViewModel alloc] init];
    [self.viewModel loadData];
}

- (void)setupMainView {
    self.mainView = [[HomeView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    self.mainView.buttonClickBlock = ^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 更新ViewModel选中状态
        strongSelf.viewModel.selectedIndex = index;
        // 跳转对应页面
        HomeModel *model = [strongSelf.viewModel modelAtIndex:index];
        if (!model) return;
        
        // 根据模型跳转（这里用类名动态创建，也可以直接写死）
        Class vcClass = NSClassFromString(model.jumpVCName);
        if (vcClass) {
            UIViewController *vc = [[vcClass alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    [self.view addSubview:self.mainView];
}

@end
