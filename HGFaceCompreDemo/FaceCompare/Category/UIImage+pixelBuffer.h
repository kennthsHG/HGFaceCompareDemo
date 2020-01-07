//
//  UIImage+pixelBuffer.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (pixelBuffer)

+ (UIImage *)imageFromPixelBuffer:(CMSampleBufferRef)bufferRef;
+ (UIImage *)imageConvert:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
