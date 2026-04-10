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
    // 1. 创建所有页面
   CarouselViewController *carousel = [[CarouselViewController alloc] init];
   HomeViewController *home = [[HomeViewController alloc] init];
    
    // 2. 设置tab内容
   carousel.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"创作" image:nil tag:0];
   home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设计室" image:nil tag:1];
    
    // 3. 把自己的子页面 赋值给自己
    self.viewControllers = @[carousel, home];
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

