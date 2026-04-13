//
//  DesignCompareViewModel.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignCompareViewModel.h"

@implementation DesignCompareViewModel
- (void)updateCameraState:(SCNView *)scnView {
    SCNNode *cameraNode = scnView.pointOfView;
    if (!cameraNode || !cameraNode.camera) return;
    
    // 同步相机位置、角度、缩放
    _cameraPosition = cameraNode.position;
    _cameraEulerAngles = cameraNode.eulerAngles;
    _cameraZoom = cameraNode.camera.zFar;
}

- (void)syncCameraToView:(SCNView *)targetView {
    SCNNode *cameraNode = targetView.pointOfView;
    if (!cameraNode || !cameraNode.camera) return;
    
    // 应用同步状态
    cameraNode.position = self.cameraPosition;
    cameraNode.eulerAngles = self.cameraEulerAngles;
    cameraNode.camera.zFar = self.cameraZoom;
}
@end
