//
//  DesignStudioViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <Foundation/Foundation.h>
#import "DesignStudioModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignStudioViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray<DesignStudioModel *> *modelList; // 瀑布流数据
@property (nonatomic, assign, readonly) BOOL isRefreshing; // 是否正在刷新

- (void)loadInitialData; // 加载初始数据
- (void)refreshNewDataCompletion:(void(^)(BOOL success))completion; // 下拉刷新
@end

NS_ASSUME_NONNULL_END
