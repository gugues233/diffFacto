//
//  MainTabController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "MainTabController.h"
#import "CarouselViewController.h"
#import "HomeViewController.h"

#define TextSize 20

@interface MainTabController () <UITabBarControllerDelegate>

@end

@implementation MainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewControllers];
    [self setUpTabItemTextStyle];
    [self setupUnderlineObserver];
}

// 创建页面并加入tabbar
- (void)setUpViewControllers {
    // 1. 创建业务控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    CarouselViewController *carousel = [[CarouselViewController alloc] init];
    
    // 2. 包裹导航控制器（核心步骤）
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    UINavigationController *carouselNav = [[UINavigationController alloc] initWithRootViewController:carousel];
    
    // 3. 给导航控制器设置TabBarItem（而非直接给业务控制器）
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"创作" image:nil tag:0];
    carouselNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设计室" image:nil tag:1];
    
    // 4. TabBar的子控制器改为导航控制器数组
    self.viewControllers = @[homeNav, carouselNav];
}

// 设置tabbar中文字样式
- (void)setUpTabItemTextStyle {
    NSDictionary *normal = @{
        NSFontAttributeName: [UIFont systemFontOfSize:TextSize],
        NSForegroundColorAttributeName: [UIColor blackColor]
    };
    NSDictionary *selected = @{
        NSFontAttributeName: [UIFont systemFontOfSize:TextSize],
        NSForegroundColorAttributeName: [UIColor blueColor]
    };
    
    [UITabBarItem.appearance setTitleTextAttributes:normal forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:selected forState:UIControlStateSelected];
}

- (void) setupUnderlineObserver {
    self.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self updateUnderline];
}


// 更新下划线
- (void)updateUnderline {
    for (UIView *view in self.tabBar.subviews) {
        if (view.tag == 9999) [view removeFromSuperview];
    }
    
    NSInteger count = self.viewControllers.count;
    CGFloat w = self.tabBar.bounds.size.width / count;
    CGFloat x = self.selectedIndex * w;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, self.tabBar.bounds.size.height - 2, w, 2)];
    line.backgroundColor = [UIColor blueColor];
    line.tag = 9999;
    [self.tabBar addSubview:line];
}

// 页面刷新时
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUnderline];
}

@end

