//
//  DesignCompareViewController.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/12.
//

#import <UIKit/UIKit.h>
#import "DesignCompareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignCompareViewController : UIViewController
- (instancetype)initWithFirstModel:(DesignCompareModel *)firstModel secondModel:(DesignCompareModel *)secondModel;
@end

NS_ASSUME_NONNULL_END
