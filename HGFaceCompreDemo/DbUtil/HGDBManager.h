//
//  HGDBManager.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGPersonFeatureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGDBManager : NSObject

//创建单利
+ (HGDBManager *)sharedInstance;

/**
保存人员数据

@param personModel 人员数据
@return 是否成功
*/
- (BOOL)savePersonModel:(HGPersonFeatureModel *)personModel;


/** 获取人脸数据人员
 */
- (NSArray *)getPersonList;

/** 获取人脸数据人员
 @param personCardid 人员身份证
*/
- (void)deletePerson:(NSString *)personCardid;

@end

NS_ASSUME_NONNULL_END
