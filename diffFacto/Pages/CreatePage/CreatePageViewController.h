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

@property (nonatomic, copy, nullable) NSString *modelType;

- (instancetype)initWithHistory:(NSArray<CreateHistoryModel *> *)history;
- (instancetype)initWithModelType:(NSString *)modelType history:(nullable NSArray<CreateHistoryModel *> *)history;

@end

NS_ASSUME_NONNULL_END
