//
//  HGDBManager.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGDBManager.h"
#import "HGDBHelperUtil.h"

static NSString *faceDbName = @"HG_FaceCompare_table";

@implementation HGDBManager

+ (HGDBManager *)sharedInstance{
    static HGDBManager *shareinstance;
    static dispatch_once_t onceTocken;
    
    dispatch_once(&onceTocken, ^{
        shareinstance = [[HGDBManager alloc]init];
    });
    return shareinstance;
}

- (BOOL)savePersonModel:(HGPersonFeatureModel *)personModel{
    return [[[HGDBHelperUtil sharedInstance]getFaceDb] insertToDB:personModel];
}

- (NSArray *)getPersonList{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",faceDbName];
    NSMutableArray *searchResultArray = [[[HGDBHelperUtil sharedInstance]getFaceDb] searchWithSQL:sql toClass:[HGPersonFeatureModel class]];
    return searchResultArray;
}

- (void)deletePerson:(NSString *)personCardid{
    [[[HGDBHelperUtil sharedInstance]getFaceDb] deleteWithTableName:faceDbName where:@{@"personCardid" : personCardid}];
}

@end
