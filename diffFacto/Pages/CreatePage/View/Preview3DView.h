//
//  Preview3DView.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Preview3DView : UIView
@property (nonatomic, strong) SCNView *scnView; // 3D视图
@property (nonatomic, strong) UIProgressView *progressView; // 进度条

- (void)startGenerateProgress:(CGFloat)progress;
- (void)show3DPointCloud:(id)pointCloudData;
- (void)resetPreview;
@end

NS_ASSUME_NONNULL_END
