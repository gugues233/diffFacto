//
//  DesignPreview3DView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignPreview3DView : UIView
@property (nonatomic, strong) SCNView *scnView; // 3D点云展示视图

- (void)loadPointCloudData:(id)pointCloudData;
- (UIImage *)captureScreenshot; // 截取当前视图（用于另存为图片）
@end

NS_ASSUME_NONNULL_END
