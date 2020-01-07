//
//  HGFaceCompareFeattureTool.h
//  HGFaceComparison
//
//  Created by 黄纲 on 2019/12/26.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGFaceCompareFeattureTool : NSObject

/**
对比出最相似人脸

@param compareFeature 当前要对比的人脸
@param featureDataSource 当前要对比的人脸
@return 字典 maxScoreIndex:最相似的Index maxScore:最高分数 自行判断 大于90分可判定同一人
 **/
+ (NSDictionary *)findMostSimilarityFeature:(NSArray *)compareFeature                                     inFeatureDataSource:(NSArray *)featureDataSource;

/**
对比两张人脸图是否相似

@param nowFaceImage 当前的人脸
@param compareFaceImage 当前要对比的人脸
@return score 相似分值 大于85分可判定同一人
 **/
+ (CGFloat)compareFaceIsSimilarity:(UIImage *)nowFaceImage                                          compareFaceImage:(UIImage *)compareFaceImage
                             error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
