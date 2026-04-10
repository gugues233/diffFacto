//
//  MyDesignModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDesignModel : NSObject
@property (nonatomic, copy) NSString *modelId;       // 模型唯一ID
@property (nonatomic, copy) NSString *createTime;    // 创建时间
@property (nonatomic, strong) UIImage *previewImage;// 预览图
@property (nonatomic, strong) id pointCloudData;    // 点云数据
@property (nonatomic, assign) BOOL isSelected;      // 是否选中

- (instancetype)initWithModelId:(NSString *)modelId previewImage:(UIImage *)previewImage data:(id)data;
@end

NS_ASSUME_NONNULL_END
