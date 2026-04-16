//
//  DesignPreviewSCNView.m
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import "DesignPreviewSCNView.h"

@implementation DesignPreviewSCNView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 检查触摸点是否在按钮区域
    // 按钮区域大致在顶部88pt高度内
    if (point.y < 88) {
        return NO; // 不处理顶部按钮区域的触摸事件
    }
    return [super pointInside:point withEvent:event];
}

@end