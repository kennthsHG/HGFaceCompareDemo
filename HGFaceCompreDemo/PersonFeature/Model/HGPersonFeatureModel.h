//
//  HGPersonFeatureModel.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGPersonFeatureModel : NSObject

/**身份证 */
@property (nonatomic, strong) NSString *personCardid;
/**姓名 */
@property (nonatomic, strong) NSString *name;
/**职位 */
@property (nonatomic, strong) NSString *position;
/**人脸照片 */
@property (nonatomic, strong) UIImage *personImage;
/**人脸数据 */
@property (nonatomic, strong) NSArray *faceFeatureData;

@end

NS_ASSUME_NONNULL_END
