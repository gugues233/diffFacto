//
//  MainTabController.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "MainTabController.h"

#import "CarouselViewController.h"
#import "HomeViewController.h"

@interface MainTabController ()

@end

@implementation MainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     // 1. 创建所有页面
    CarouselViewController *carousel = [[CarouselViewController alloc] init];
    HomeViewController *home = [[HomeViewController alloc] init];
     
     // 2. 设置tab内容
    carousel.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"创作" image:nil tag:0];
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设计室" image:nil tag:1];
     
     // 3. 把自己的子页面 赋值给自己
     self.viewControllers = @[carousel, home];

}


@end
