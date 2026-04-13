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
        _itemIndex = -1;
    }
    return self;
}

- (instancetype)initWithCategory:(NSString *)category itemName:(NSString *)itemName image:(UIImage *)image categoryIndex:(NSInteger)categoryIndex itemIndex:(NSInteger)itemIndex {
    self = [super init];
    if (self) {
        _categoryName = category;
        _itemName = itemName;
        _selectedImage = image;
        _categoryIndex = categoryIndex;
        _itemIndex = itemIndex;
    }
    return self;
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _categoryName = [coder decodeObjectForKey:@"categoryName"];
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _selectedImage = [coder decodeObjectForKey:@"selectedImage"];
        _categoryIndex = [coder decodeIntegerForKey:@"categoryIndex"];
        _itemIndex = [coder decodeIntegerForKey:@"itemIndex"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.categoryName forKey:@"categoryName"];
    [coder encodeObject:self.itemName forKey:@"itemName"];
    [coder encodeObject:self.selectedImage forKey:@"selectedImage"];
    [coder encodeInteger:self.categoryIndex forKey:@"categoryIndex"];
    [coder encodeInteger:self.itemIndex forKey:@"itemIndex"];
}
@end
