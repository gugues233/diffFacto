//
//  DesignStudioViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import "DesignStudioViewModel.h"

@implementation DesignStudioViewModel
- (void)loadInitialData {
    // 模拟加载初始数据（实际项目从后端/本地读取）
    NSMutableArray *models = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        UIImage *preview = [UIImage imageNamed:[NSString stringWithFormat:@"studio_preview_%d", i]];
        DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:[NSString stringWithFormat:@"studio_%d", i] previewImage:preview data:nil];
        [models addObject:model];
    }
    _modelList = [models copy];
    _isRefreshing = NO;
}

- (void)refreshNewDataCompletion:(void(^)(BOOL success))completion {
    _isRefreshing = YES;
    // 模拟网络请求刷新（实际项目替换为真实接口）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *newModels = [NSMutableArray arrayWithArray:self.modelList];
        // 模拟新增2条数据
        for (int i=0; i<2; i++) {
            UIImage *preview = [UIImage imageNamed:[NSString stringWithFormat:@"studio_preview_%d", (int)newModels.count]];
            DesignStudioModel *model = [[DesignStudioModel alloc] initWithModelId:[NSString stringWithFormat:@"studio_%d", (int)newModels.count] previewImage:preview data:nil];
            [newModels insertObject:model atIndex:0];
        }
        self->_modelList = [newModels copy];
        self->_isRefreshing = NO;
        if (completion) completion(YES);
    });
}

@end
