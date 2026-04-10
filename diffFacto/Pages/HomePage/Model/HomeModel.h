//
//  HomeModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject
@property (nonatomic, copy) NSString *title;       // 按钮文字
@property (nonatomic, copy) NSString *jumpVCName;  // 跳转的控制器名
@property (nonatomic, assign) BOOL isSelected;    // 是否选中

- (instancetype)initWithTitle:(NSString *)title jumpVCName:(NSString *)vcName;

@end

NS_ASSUME_NONNULL_END
