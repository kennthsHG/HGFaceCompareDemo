//
//  HGSelectPhotoViewController.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HGSelectPhotoPickerBlock)(UIImage *image);

@interface HGSelectPhotoViewController : NSObject

/**
 公共方法 选择图片后的图片回掉

 @param controller 使用这个工具的控制器
 @param photoBlock 选择图片后的回掉
 */
- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(HGSelectPhotoPickerBlock)photoBlock;

@end
NS_ASSUME_NONNULL_END
