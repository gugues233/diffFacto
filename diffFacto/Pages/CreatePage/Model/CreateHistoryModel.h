//
//  CreateHistoryModel.h
//  diffFacto
//
//  Created by gugues Lin on 2026/4/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CreateHistoryModel : NSObject
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger categoryIndex;
@property (nonatomic, strong) id selectedItem;
@end
