//
//  CreateBaseModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/14.
//

#import "CreateBaseModel.h"

@implementation CreateBaseModel

- (instancetype)initWithProductName:(NSString *)productName selectedItems:(NSArray *)selectedItems pointCloudModel:(id)pointCloudModel {
    self = [super init];
    if (self) {
        _productName = productName;
        _selectedItems = selectedItems;
        _pointCloudModel = pointCloudModel;
        _createdDate = [NSDate date];
    }
    return self;
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _productName = [coder decodeObjectForKey:@"productName"];
        _selectedItems = [coder decodeObjectForKey:@"selectedItems"];
        _pointCloudModel = [coder decodeObjectForKey:@"pointCloudModel"];
        _createdDate = [coder decodeObjectForKey:@"createdDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.productName forKey:@"productName"];
    [coder encodeObject:self.selectedItems forKey:@"selectedItems"];
    [coder encodeObject:self.pointCloudModel forKey:@"pointCloudModel"];
    [coder encodeObject:self.createdDate forKey:@"createdDate"];
}

@end