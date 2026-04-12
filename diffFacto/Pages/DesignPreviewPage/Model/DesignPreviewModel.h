//
//  DesignPreviewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CreateHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignPreviewModel : NSObject
@property (nonatomic, copy) NSString *modelId;       // 模型ID
@property (nonatomic, strong) id pointCloudData;    // 3D点云数据
@property (nonatomic, strong) UIImage *previewImage;// 预览图
@property (nonatomic, assign) BOOL isPublic;        // 是否公开
@property (nonatomic, copy) NSString *createTime;    // 创建时间
@property (nonatomic, assign) BOOL isMyModel;
@property (nonatomic, strong) NSArray<CreateHistoryModel *> *createHistoryList;

- (instancetype)initWithModelId:(NSString *)modelId data:(id)data previewImage:(UIImage *)previewImage;
@end

NS_ASSUME_NONNULL_END
