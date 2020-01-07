//
//  HGCameraOutput.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CameraOutputDelegate <NSObject>

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer faces:(NSArray <NSValue *>*)faces;

@end

@interface HGCameraOutput : NSObject

@property (nonatomic,weak) id <CameraOutputDelegate>delegate;
@property (nonatomic,strong) AVCaptureSession *cameraSession;

@property (nonatomic,strong) NSNumber *outPutSetting;

- (void)runCamera;
- (void)stopCamera;

@end

NS_ASSUME_NONNULL_END
