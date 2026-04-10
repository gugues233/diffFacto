//
//  MyDesignViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import "MyDesignModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDesignViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray<MyDesignModel *> *modelList; // 所有模型
@property (nonatomic, strong, readonly) NSArray<MyDesignModel *> *selectedList; // 已选模型（最多2个）
@property (nonatomic, assign, readonly) BOOL isLongPressMode; // 是否处于长按选择模式
@property (nonatomic, assign, readonly) BOOL canSelectMore; // 是否还能选择

- (void)loadLocalCacheModels; // 加载本地缓存的点云模型
- (void)enterLongPressMode;  // 进入长按选择模式
- (void)exitLongPressMode;   // 退出长按选择模式
- (BOOL)toggleSelectModelAtIndex:(NSInteger)index; // 切换选中状态，返回是否成功
- (void)clearAllSelection;   // 清空所有选择
@end

NS_ASSUME_NONNULL_END
