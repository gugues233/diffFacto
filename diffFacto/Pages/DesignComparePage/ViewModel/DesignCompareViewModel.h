//
//  DesignCompareViewModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <Foundation/Foundation.h>
#import "DesignCompareModel.h"
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignCompareViewModel : NSObject
@property (nonatomic, strong) DesignCompareModel *firstModel;
@property (nonatomic, strong) DesignCompareModel *secondModel;
@property (nonatomic, assign) SCNVector3 cameraPosition; // 同步相机位置
@property (nonatomic, assign) SCNVector3 cameraEulerAngles; // 同步相机角度
@property (nonatomic, assign) CGFloat cameraZoom; // 同步缩放

- (void)updateCameraState:(SCNView *)scnView; // 更新相机状态
- (void)syncCameraToView:(SCNView *)targetView; // 同步相机到目标视图
@end

NS_ASSUME_NONNULL_END
