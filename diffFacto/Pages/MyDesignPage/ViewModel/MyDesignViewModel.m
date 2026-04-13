//
//  MyDesignViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "MyDesignViewModel.h"
#import "CreateHistoryModel.h"
#import "CreatePageViewModel.h"

#define kMaxSelectCount 2

@implementation MyDesignViewModel
- (void)loadLocalCacheModels {
    // 从缓存读取CreateHistoryModel
    CreatePageViewModel *createViewModel = [[CreatePageViewModel alloc] init];
    NSMutableArray<CreateHistoryModel *> *historyList = [createViewModel getGenerateHistory];
    
    // 转换为MyDesignModel
    NSMutableArray *models = [NSMutableArray array];
    for (CreateHistoryModel *history in historyList) {
        // 生成预览图片
        UIImage *previewImage = [self generatePreviewImage];
        
        MyDesignModel *model = [[MyDesignModel alloc] initWithModelId:history.productName previewImage:previewImage data:history.pointCloudModel];
        model.createTime = [self formatDate:history.createdDate];
        [models addObject:model];
    }
    
    _modelList = [models copy];
    _selectedList = @[];
    _isLongPressMode = NO;
}

- (UIImage *)generatePreviewImage {
    // 生成一个简单的占位图
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 背景色
    [[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // 绘制模拟点云
    for (int i = 0; i < 200; i++) {
        CGFloat x = arc4random() % 180 + 10;
        CGFloat y = arc4random() % 180 + 10;
        CGFloat radius = arc4random() % 3 + 1;
        
        UIColor *color = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(x, y, radius, radius));
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
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
