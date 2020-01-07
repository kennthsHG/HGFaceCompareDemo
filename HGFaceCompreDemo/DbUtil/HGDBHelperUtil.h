//
//  HGDBHelperUtil.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGDBHelperUtil : NSObject


//创建单利
+ (HGDBHelperUtil *)sharedInstance;

- (LKDBHelper *)getFaceDb;

- (void)closeDb;

@end

NS_ASSUME_NONNULL_END
