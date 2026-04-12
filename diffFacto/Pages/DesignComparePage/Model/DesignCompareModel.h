//
//  DesignCompareModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignCompareModel : NSObject
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, strong) id pointCloudData;
@property (nonatomic, strong) UIImage *previewImage;

- (instancetype)initWithModelId:(NSString *)modelId data:(id)data previewImage:(UIImage *)previewImage;
@end

NS_ASSUME_NONNULL_END
