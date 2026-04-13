//
//  CreateBaseModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateBaseModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *productName; // 物品名称
@property (nonatomic, strong) NSArray *selectedItems; // 选中的各个分类的样式
@property (nonatomic, strong) id pointCloudModel; // 生成的点云模型
@property (nonatomic, strong) NSDate *createdDate; // 创建时间

- (instancetype)initWithProductName:(NSString *)productName selectedItems:(NSArray *)selectedItems pointCloudModel:(id)pointCloudModel;
@end

NS_ASSUME_NONNULL_END