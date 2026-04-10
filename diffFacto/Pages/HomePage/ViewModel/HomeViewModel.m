//
//  HomeViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (void)loadData {
    // 初始化两个按钮数据
    HomeModel *newCreate = [[HomeModel alloc] initWithTitle:@"新的创作" jumpVCName:@"NewCreateViewController"];
    HomeModel *myDesign = [[HomeModel alloc] initWithTitle:@"我的设计" jumpVCName:@"MyDesignViewController"];
    _itemList = @[newCreate, myDesign];
    _selectedIndex = -1; // 默认无选中
}

- (HomeModel *)modelAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.itemList.count) return nil;
    return self.itemList[index];
}

@end
