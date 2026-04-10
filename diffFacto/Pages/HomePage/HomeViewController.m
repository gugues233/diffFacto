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
#import "CarouselViewController.h"
//#import "MyDesignViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong) HomeView *mainView;
@property (nonatomic, strong) HomeViewModel *viewModel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        
//        // 修复1：强制转成正确的类名（避免动态字符串写错）
//        // 替代原动态类名逻辑，先写死验证，后续可改回动态
//        UIViewController *vc = [[CarouselViewController alloc] init];
//        
//        // 修复2：校验导航控制器是否存在，避免跳转失败
//        if (strongSelf.navigationController) {
//            [strongSelf.navigationController pushViewController:vc animated:YES];
//        } else {
//            NSLog(@"⚠️ 跳转失败：当前控制器无导航控制器");
//            // 兜底：如果没有导航，直接present
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            [strongSelf presentViewController:nav animated:YES completion:nil];
//        }
    };
    [self.view addSubview:self.mainView];
}

@end
