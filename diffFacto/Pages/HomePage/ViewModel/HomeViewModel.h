//
//  HomeViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray<HomeModel *> *itemList; // 按钮数据
@property (nonatomic, assign) NSInteger selectedIndex; // 当前选中索引

- (void)loadData; // 加载数据
- (HomeViewModel *)modelAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
