//
//  HGDBHelperUtil.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGDBHelperUtil.h"

@interface HGDBHelperUtil()

@property (nonatomic, strong) LKDBHelper *projectPersonFaceDb;

@end

@implementation HGDBHelperUtil

+ (HGDBHelperUtil *)sharedInstance{
    static HGDBHelperUtil *shareinstance;
    static dispatch_once_t onceTocken;
    
    dispatch_once(&onceTocken, ^{
        shareinstance = [[HGDBHelperUtil alloc]init];
    });
    return shareinstance;
}

- (LKDBHelper *)getFaceDb{
    
    if (!_projectPersonFaceDb) {
        NSString *path = [self DBPath];
        NSLog(@"filePath----%@",path);
        self.projectPersonFaceDb = [[LKDBHelper alloc] initWithDBPath:path];
        [self.projectPersonFaceDb getTableCreatedWithClass:NSClassFromString(@"HGPersonFeatureModel")];
    }
    
    return self.projectPersonFaceDb;
}


- (NSString *)DBPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];
    NSString* dbPath = [path stringByAppendingPathComponent:@"dbFace"];
    dbPath = [dbPath stringByAppendingPathComponent:@"dbFace.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path])//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dbPath;
}

- (void)closeDb{
    [self.projectPersonFaceDb closeDB];
    self.projectPersonFaceDb = nil;
}
@end
