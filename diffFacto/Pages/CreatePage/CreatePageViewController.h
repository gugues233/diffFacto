//
//  CreatePageViewController.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/10.
//

#import <UIKit/UIKit.h>
#import "CreateHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreatePageViewController : UIViewController

- (instancetype)initWithHistory:(NSArray<CreateHistoryModel *> *)history;

@end

NS_ASSUME_NONNULL_END
