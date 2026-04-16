//
//  CreatePageViewController.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "CreateHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreatePageViewController : UIViewController

@property (nonatomic, copy, nullable) NSString *modelType; //模型类别
@property (nonatomic, strong) NSArray *selectedItems; //选中的各个分类的样式
@property (nonatomic, strong) id pointCloudModel; // 点云模型

// TODO: zxy-需要，点云模型、物品种类、选项
- (instancetype)initWithModelType:(NSString *)modelType history:(nullable NSArray<CreateHistoryModel *> *)history;
- (instancetype)initWithModelType:(NSString *)modelType selectedItems:(NSArray *)selectedItems pointCloudModel:(id)pointCloudModel;

@end

NS_ASSUME_NONNULL_END
