//
//  DesignStudioModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignStudioModel : NSObject
@property (nonatomic, copy) NSString *modelId;       // 模型唯一ID
@property (nonatomic, strong) UIImage *previewImage;// 预览图
@property (nonatomic, strong) id pointCloudData;    // 3D点云数据
@property (nonatomic, assign) CGFloat itemHeight;  // Cell高度（瀑布流用）
@property (nonatomic, copy) NSString *createTime;    // 创建时间

- (instancetype)initWithModelId:(NSString *)modelId previewImage:(UIImage *)previewImage data:(id)data;
@end

NS_ASSUME_NONNULL_END
