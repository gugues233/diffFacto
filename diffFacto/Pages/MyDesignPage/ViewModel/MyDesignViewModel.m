//
//  MyDesignViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignViewModel.h"

#define kMaxSelectCount 2

@implementation MyDesignViewModel
- (void)loadLocalCacheModels {
    // 模拟加载本地缓存（实际项目从沙盒/数据库读取）
    NSMutableArray *models = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        UIImage *preview = [UIImage imageNamed:[NSString stringWithFormat:@"preview_%d", i]];
        MyDesignModel *model = [[MyDesignModel alloc] initWithModelId:[NSString stringWithFormat:@"model_%d", i] previewImage:preview data:nil];
        [models addObject:model];
    }
    _modelList = [models copy];
    _selectedList = @[];
    _isLongPressMode = NO;
}

- (void)enterLongPressMode {
    _isLongPressMode = YES;
}

- (void)exitLongPressMode {
    _isLongPressMode = NO;
    [self clearAllSelection];
}

- (BOOL)toggleSelectModelAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.modelList.count) return NO;
    
    MyDesignModel *model = self.modelList[index];
    if (model.isSelected) {
        // 取消选中
        model.isSelected = NO;
        NSMutableArray *newSelected = [NSMutableArray arrayWithArray:self.selectedList];
        [newSelected removeObject:model];
        _selectedList = [newSelected copy];
        return YES;
    } else {
        // 尝试选中
        if (self.selectedList.count >= kMaxSelectCount) {
            return NO; // 已达最大选择数
        }
        model.isSelected = YES;
        NSMutableArray *newSelected = [NSMutableArray arrayWithArray:self.selectedList];
        [newSelected addObject:model];
        _selectedList = [newSelected copy];
        return YES;
    }
}

- (void)clearAllSelection {
    for (MyDesignModel *model in self.modelList) {
        model.isSelected = NO;
    }
    _selectedList = @[];
}

- (BOOL)canSelectMore {
    return self.selectedList.count < kMaxSelectCount;
}

@end
