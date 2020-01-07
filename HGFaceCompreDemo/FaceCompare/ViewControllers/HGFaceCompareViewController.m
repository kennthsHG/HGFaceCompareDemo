//
//  HGFaceCompareViewController.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGFaceCompareViewController.h"
#import "HGCameraOutput.h"
#import "FaceMaskView.h"
#import "HGDBManager.h"
#import "HGPersonFeatureModel.h"
#import "HGCompareSuccessInfoView.h"
#import "UIImage+pixelBuffer.h"
#import "HGFaceMtcnnTool.h"
#import "HGFaceCompareFeattureTool.h"

static NSInteger const faceMoveSpeed = 3;
@interface HGFaceCompareViewController ()<CameraOutputDelegate>

@property (nonatomic, strong) HGFaceMtcnnTool *tool;

@property (nonatomic, assign) float rectCenterX;
@property (nonatomic, assign) float rectCenterY;

@property (nonatomic, strong) HGCameraOutput *cameraOutput;
@property (nonatomic, strong) AVSampleBufferDisplayLayer *cameraLayer;

@property (nonatomic, copy) NSArray* faceBounds;

//mask view
@property (nonatomic, strong) FaceMaskView *faceMaskView;
@property (nonatomic, assign) BOOL isBusy;

@property (nonatomic, copy) NSArray *featurDataSource;
@property (nonatomic, strong) NSArray <HGPersonFeatureModel*>*personDataArray;

@end

@implementation HGFaceCompareViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self getPersonFeature];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.cameraOutput runCamera];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.cameraOutput stopCamera];
}

#pragma mark - UI
- (void)initUI{
    
    self.tool = [[HGFaceMtcnnTool alloc]init];
    
    self.cameraLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.cameraLayer];
    _cameraOutput = [[HGCameraOutput alloc] init];
    _cameraOutput.delegate = self;
    
    self.faceMaskView = [[FaceMaskView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.faceMaskView];
    
    [_cameraOutput runCamera];
}

#pragma mark - CameraOutput
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer faces:(NSArray <NSValue *>*)faces{
    
    if (self.cameraLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            [self.cameraLayer flush];
        }
        CVImageBufferRef buffer;
        buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        size_t width, height;
        width = CVPixelBufferGetWidth(buffer);
        height = CVPixelBufferGetHeight(buffer);
        _faceBounds = [NSArray arrayWithArray:faces];
        
        NSValue *maxRect;
        CGFloat maxArea = 0;
        //画图
        if (_faceBounds.count) {
           
            for (NSInteger i = 0; i < _faceBounds.count; i++) {
                NSValue *faceRect = _faceBounds[i];
                float tmpArea = [faceRect CGRectValue].size.width * [faceRect CGRectValue].size.height;
                if (tmpArea > maxArea) {
                    maxRect =  faceRect;
                    maxArea = tmpArea;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.faceMaskView.picSize = CGSizeMake(width, height);
                self.faceMaskView.faces = @[maxRect];
            });
        }else{
            [self clearMask];
        }
        
        CGRect re = [maxRect CGRectValue];
        
        BOOL overPostion = [self checkFaceInDetectionRect:[maxRect CGRectValue] imageSize:CGSizeMake(width, height)];
        BOOL moveFast = NO;
        BOOL faceTooSmall = NO;
        
        //鼻子点
        float rectCenterX = re.origin.x + (re.size.width / 2);
        float rectCenterY = re.origin.y + (re.size.height / 2);
        float distance = !self.rectCenterX ? 0 : (fabsf(rectCenterX - self.rectCenterX) + fabsf(rectCenterY - _rectCenterY)) / 2;
        
        moveFast = (distance > faceMoveSpeed) ? YES : NO;
        self.rectCenterX = rectCenterX;
        self.rectCenterY = rectCenterY;
        //facesize
        CGFloat faceSize = re.size.width * re.size.width;
        
        faceTooSmall = faceSize < 4000;

        if (!self.isBusy && !overPostion && !moveFast && !faceTooSmall) {
            self.isBusy = YES;
            CFAllocatorRef allocator = CFAllocatorGetDefault();
            CMSampleBufferRef sbufCopyOut;
            CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
            [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:) withObject:CFBridgingRelease(sbufCopyOut)];
        }
    
     [self.cameraLayer enqueueSampleBuffer:sampleBuffer];
}

- (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    UIImage  *image = [UIImage imageFromPixelBuffer:sampleBuffer];
    if (image == nil) {
        self.isBusy = NO;
        return;
    }
    
     __weak typeof(self) wealSelf = self;
    if (_faceBounds.count) {
            CVImageBufferRef buffer;
            buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            size_t width, height;
            width = CVPixelBufferGetWidth(buffer);
            height = CVPixelBufferGetHeight(buffer);
            
            NSError *error;
            //找出最大人脸 index 0 关键点。index 1 人脸框
            NSArray *mtcnnResult = [wealSelf.tool detectPersonMaxFace:image error:&error];
        
            NSArray *whichFeatures = nil;
            NSString *facePostion = @"";
            NSInteger postion = [self postion:mtcnnResult.firstObject];
            
            switch (postion) {
                case 0:{
                    facePostion = @"front";
                    whichFeatures = self.featurDataSource;
                }
                    break;
                default:
                    break;
            }
           
            
            if (mtcnnResult.count == 2 && whichFeatures.count) {
                
                NSArray *features = [wealSelf.tool getFaceFeaturesWithPersonImage:image landmarks:mtcnnResult.firstObject];
                NSDictionary *simResult = [HGFaceCompareFeattureTool findMostSimilarityFeature:features inFeatureDataSource:whichFeatures];
                NSInteger index = [simResult[@"maxScoreIndex"] integerValue];
                CGFloat score = [simResult[@"maxScore"] floatValue];

                NSLog(@"分数----%f",score);
                
                if (score >= 85) {
                    HGPersonFeatureModel *model = self.personDataArray[index];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HGCompareSuccessInfoView showCompreSuccessView:model score:score addView:self.view dissMissBlock:^{
                            self.isBusy = NO;
                        }];
                    });
 
                }
                else{
                     self.isBusy = NO;
                }
            }
            else{
                self.isBusy = NO;
            }
           
        }
    else{
       self.isBusy = NO;
    }
       
}

- (void)clearMask{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.faceMaskView.faces) {
            self.faceMaskView.faces = nil;
        }
    });
}

#pragma mark - Methods
//检测脸部是否在 检测的区域内 是否出了检测的区域
- (BOOL)checkFaceInDetectionRect:(CGRect)re imageSize:(CGSize)size
{
    CGFloat threshold = 10;
    
    CGFloat x1 = re.origin.x;
    CGFloat y1 = re.origin.y;
    CGFloat x2 = re.origin.x + re.size.width;
    CGFloat y2 = re.origin.y + re.size.height;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    BOOL overX1 = NO;
    BOOL overY1 = NO;
    BOOL overX2 = NO;
    BOOL overY2 = NO;
    
    if (x1 < threshold) {
        overX1 = YES;
    }
    if (y1 < threshold) {
        overY1 = YES;
    }
    if ((width - x2) < threshold) {
        overX2 = YES;
    }
    if ((height - y2) < threshold) {
        overY2 = YES;
    }
    return (overX1 || overX2 || overY1 || overY2);
}

- (NSInteger)postion:(NSArray *)landmarks
{
    CGFloat top = [self CalDis:[landmarks[0] CGPointValue] p2:[landmarks[1] CGPointValue] x:[landmarks[2] CGPointValue]];
    CGFloat bottom = [self CalDis:[landmarks[3] CGPointValue] p2:[landmarks[4] CGPointValue] x:[landmarks[2] CGPointValue]];
    
    CGFloat left = [self CalDis:[landmarks[0] CGPointValue] p2:[landmarks[3] CGPointValue] x:[landmarks[2] CGPointValue]];
    CGFloat right =[self CalDis:[landmarks[1] CGPointValue] p2:[landmarks[4] CGPointValue] x:[landmarks[2] CGPointValue]];
    
    CGFloat leftRight = left / right;
    CGFloat upDown = top / bottom;
    
    
    //按比例计算 最好
    if ((leftRight < 0.7) && upDown < 0.7) {
        //左上
        return 1;
    }
    
    //左右眼 距离 差不多的时候
    if (leftRight >= 0.9 && leftRight <= 1.1 && upDown < 0.4) {
        //正上
        return 2;
    }
    
    if (leftRight > 1.3 && upDown < 0.8) {
        //右上
        return 3;
    }
    
    if (leftRight >= 1.3 && upDown >= 0.7 && upDown <= 1.3) {
        //正右
        return 4;
    }
    
    //上部多 下方很少
    if (leftRight > 1.3 && upDown > 1.3) {
        //右下角
        return 5;
    }
    
    //左右眼 距离 差不多的时候
    if (leftRight > 0.9 && leftRight <= 1.1 && upDown> 2.0) {
        //正下
        return 6;
    }
    
    //上部多 下方很少
    if (leftRight < 0.8 && upDown > 1.3) {
        //左下
       return 7;
    }
    
    
    if (leftRight <= 0.5 && upDown >= 0.7 && upDown <= 1.3) {
        //正左
        return 8;
    }
    
    //越界情况
    if (upDown >= 0.7 && upDown <= 1.3) {
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 4;
        }
        
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 8;
        }
    }

    if (upDown < 0.7) {
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 3;
        }
        
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 1;
        }
    }
    
    if (upDown > 1.8) {
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 5;
        }
        
        if (([landmarks[0] CGPointValue].x > [landmarks[2] CGPointValue].x)) {
            return 7;
        }
    }
    
    return 0;
}

- (CGFloat)CalDis:(CGPoint)p1 p2:(CGPoint)p2 x:(CGPoint)p3
{
    CGFloat px = p2.x - p1.x;
    CGFloat py = p2.y - p1.y;
    CGFloat som = px * px + py * py;
    CGFloat u = ((p3.x - p1.x) * px + (p3.y - p1.y) * py) / som;
    if (u > 1) {
        u = 1;
    }
    if (u < 0) {
        u = 0;
    }
    //the closest point
    CGFloat x = p1.x + u * px;
    CGFloat y = p1.y + u * py;
    CGFloat dx = x - p3.x;
    CGFloat dy = y - p3.y;
    CGFloat dist = sqrt(dx*dx + dy*dy);
    
    return dist;
}


- (void)getPersonFeature{
    self.personDataArray = [[HGDBManager sharedInstance]getPersonList];
    NSMutableArray *faceDataArray = @[].mutableCopy;
    for (int i = 0; i < self.personDataArray.count; i++) {
        HGPersonFeatureModel *model = self.personDataArray[i];
        [faceDataArray addObject:model.faceFeatureData];
    }
    self.featurDataSource = faceDataArray;
}
#pragma mark - Actions

#pragma mark - Getters
- (AVSampleBufferDisplayLayer *)cameraLayer{
    if (!_cameraLayer) {
        _cameraLayer = [[AVSampleBufferDisplayLayer alloc] init];
    }
    return _cameraLayer;
}

#pragma mark - Setters

@end
