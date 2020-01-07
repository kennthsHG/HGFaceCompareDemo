//
//  HGFaceMtcnnTool.h
//  HGFaceComparison
//
//  Created by 黄纲 on 2019/12/26.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define FACE_EMBEDDING_SIZE 512 //取出人脸特征总数
API_AVAILABLE(ios(11.0))
@interface HGFaceMtcnnTool : NSObject

/**
获取最大人脸

@param image 人脸图片
@return array 0->5个人脸关键点 1->人脸框
*/
- (NSArray*)detectPersonMaxFace:(UIImage *)image
                          error:(NSError **)error;

/**
获取人脸特征

@param personImage 人脸图片
@param landmarks 5 个关键点
@return 512个人脸特征
*/
- (NSArray*)getFaceFeaturesWithPersonImage:(UIImage *)personImage                                                  landmarks:(NSArray *)landmarks;

@end

NS_ASSUME_NONNULL_END
