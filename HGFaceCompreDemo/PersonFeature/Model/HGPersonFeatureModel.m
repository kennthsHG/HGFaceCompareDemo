//
//  HGPersonFeatureModel.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGPersonFeatureModel.h"
#import "FMDB.h"

@implementation HGPersonFeatureModel

+ (NSString *)getPrimaryKey {
    return @"personCardid";
}

//表名
+ (NSString *)getTableName {
    return @"HG_FaceCompare_table";
}


@end
