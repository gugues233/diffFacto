//
//  CreateSelectedItemModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import "CreateSelectedItemModel.h"

@implementation CreateSelectedItemModel
- (instancetype)initWithCategory:(NSString *)category image:(UIImage *)image index:(NSInteger)index {
    self = [super init];
    if (self) {
        _categoryName = category;
        _selectedImage = image;
        _categoryIndex = index;
    }
    return self;
}
@end
