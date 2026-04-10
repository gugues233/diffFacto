//
//  GoodsModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/9.
//

#import "GoodsModel.h"

@implementation GoodsModel
+ (NSArray<GoodsModel *> *)demoData {
    return @[
        [self modelWithTitle:@"物品 1"],
        [self modelWithTitle:@"物品 2"],
        [self modelWithTitle:@"物品 3"],
        [self modelWithTitle:@"物品 4"],
        [self modelWithTitle:@"物品 5"],
        [self modelWithTitle:@"物品 6"],
    ];
}

+ (instancetype)modelWithTitle:(NSString *)title {
    GoodsModel *m = [[GoodsModel alloc] init];
    m.title = title;
    return m;
}
@end
