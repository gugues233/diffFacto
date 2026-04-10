//
//  CreateCategoryModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import "CreateItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateCategoryModel : NSObject
@property (nonatomic, copy) NSString *categoryName;  // 分类名称（如：背景、腿）
@property (nonatomic, strong) NSArray<CreateItemModel *> *itemList; // 分类内选项
@property (nonatomic, assign) NSInteger selectedIndex; // 当前选中索引

- (instancetype)initWithName:(NSString *)name items:(NSArray<CreateItemModel *> *)items;
@end

NS_ASSUME_NONNULL_END
