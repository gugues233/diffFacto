//
//  CreateCategoryModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CreateCategoryModel.h"

@implementation CreateCategoryModel
- (instancetype)initWithName:(NSString *)name items:(NSArray<CreateItemModel *> *)items {
    self = [super init];
    if (self) {
        _categoryName = name;
        _itemList = items;
        _selectedIndex = -1;
    }
    return self;
}
@end
