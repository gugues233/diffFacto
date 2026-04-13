//
//  DesignCompare3DView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

typedef void(^CameraDidChangeBlock)(SCNView *scnView);

NS_ASSUME_NONNULL_BEGIN

@interface DesignCompare3DView : UIView
@property (nonatomic, strong) SCNView *scnView;
@property (nonatomic, copy) CameraDidChangeBlock cameraChangeBlock; // 相机变化回调
@property (nonatomic, assign) BOOL isSyncing; // 是否正在同步相机（防止循环调用）

- (void)loadPointCloudData:(id)pointCloudData;
- (void)syncCameraFromView:(SCNView *)sourceView;
@end

NS_ASSUME_NONNULL_END
