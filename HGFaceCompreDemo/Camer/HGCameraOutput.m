//
//  HGCameraOutput.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGCameraOutput.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HGCameraOutput ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) dispatch_queue_t sampleBufferQueue;
@property (nonatomic, strong) dispatch_queue_t faceQueue;
@property (nonatomic, copy) NSArray *currentMetadata;
@property (nonatomic, strong) AVCaptureDevice *device;

@end

@implementation HGCameraOutput

- (instancetype)init{
    self = [super init];
    if (self) {
        _sampleBufferQueue = dispatch_queue_create("com.hfkj.wwww.sample", NULL);
        _faceQueue = dispatch_queue_create("com.hfkj.wwww.face", NULL);
        
        AVCaptureDeviceInput*input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        output.alwaysDiscardsLateVideoFrames = YES;
        [output setSampleBufferDelegate:self queue:_sampleBufferQueue];
        
        AVCaptureMetadataOutput *metaout = [[AVCaptureMetadataOutput alloc] init];
        [metaout setMetadataObjectsDelegate:self queue:_faceQueue];
        self.cameraSession = [[AVCaptureSession alloc] init];
        [self.cameraSession beginConfiguration];
        if ([self.cameraSession canAddInput:input]) {
            [self.cameraSession addInput:input];
        }
        
        if ([self.cameraSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            _cameraSession.sessionPreset = AVCaptureSessionPreset640x480;
        }
        if ([self.cameraSession canAddOutput:output]) {
            [self.cameraSession addOutput:output];
        }
        
        if ([self.cameraSession canAddOutput:metaout]) {
            [self.cameraSession addOutput:metaout];
        }
        [self.cameraSession commitConfiguration];
        
        NSString     *key           = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber     *value         =  @(kCVPixelFormatType_32BGRA);
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        
        [output setVideoSettings:videoSettings];
        [metaout setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
        
        [self videoMirored];

    }
    return self;
}

- (void)runCamera{
    [self.cameraSession startRunning];
}

- (void)stopCamera{
    [self.cameraSession stopRunning];
}

#pragma mark - AVCapturecameraSession Delegate -

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if ([self.delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:faces:)]) {
        NSMutableArray *bounds = [NSMutableArray arrayWithCapacity:0];
        for (AVMetadataFaceObject *faceobject in self.currentMetadata) {
            AVMetadataObject *face = [output transformedMetadataObjectForMetadataObject:faceobject connection:connection];
            [bounds addObject:[NSValue valueWithCGRect:face.bounds]];
        }
        
        [self.delegate captureOutput:output didOutputSampleBuffer:sampleBuffer faces:bounds];

    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //当检测到了人脸会走这个回调
    _currentMetadata = metadataObjects;
}


- (void)videoMirored {
    AVCaptureSession* cameraSession = (AVCaptureSession *)self.cameraSession;
    for (AVCaptureVideoDataOutput* output in cameraSession.outputs) {
        for (AVCaptureConnection * av in output.connections) {
            //判断是否是前置摄像头状态
            if (av.supportsVideoMirroring) {
                //镜像设置
                av.videoOrientation = AVCaptureVideoOrientationPortrait;
                av.videoMirrored = YES;
            }
        }
    }
}


-(AVCaptureDevice *)device {
    if (_device == nil) {
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices )
        {
            if ( device.position == AVCaptureDevicePositionFront )
            {
                _device = device;
                break;
            }
        }
        
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            if ([_device isSmoothAutoFocusSupported]) {// 平滑对焦
                _device.smoothAutoFocusEnabled = YES;
            }
            
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {// 自动持续对焦
                _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) {// 自动持续曝光
                _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }
            
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {// 自动持续白平衡
                _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            }
            
            [_device unlockForConfiguration];
        }
    }
    return _device;
}


-(NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_32BGRA);
    }
    return _outPutSetting;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end

