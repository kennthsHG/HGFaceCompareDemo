//
//  HGComparePhotosViewController.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGComparePhotosViewController.h"
#import "HGSelectPhotoViewController.h"
#import "HGFaceCompareFeattureTool.h"
#import "HGFaceMtcnnTool.h"

@interface HGComparePhotosViewController ()

@property (nonatomic, strong) UIImageView *nowImageView;
@property (nonatomic, strong) UIImageView *compareImageView;

@property (nonatomic, strong) HGSelectPhotoViewController *myPicker;
@property (nonatomic, strong) HGSelectPhotoViewController *comparePicker;

@property (nonatomic, strong) NSArray *nowfeatures;
@property (nonatomic, strong) NSArray *comparefeatures;
@property (nonatomic, strong) HGFaceMtcnnTool *tool;
@end

@implementation HGComparePhotosViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - UI
- (void)initUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tool = [[HGFaceMtcnnTool alloc]init];
    
    self.nowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2)];
    self.nowImageView.center = CGPointMake(self.view.center.x, self.nowImageView.center.y);
    self.nowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.nowImageView setImage:[UIImage imageNamed:@"jielunFace1"]];

    
    [self.view addSubview:self.nowImageView];
    
    UIButton *selectNowImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 120 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    selectNowImageButton.center = CGPointMake(self.view.center.x, selectNowImageButton.center.y);
    selectNowImageButton.backgroundColor = [UIColor lightGrayColor];
    [selectNowImageButton setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectNowImageButton addTarget:self action:@selector(nowImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectNowImageButton];
    
    self.compareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 180 + [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2)];
    self.compareImageView.center = CGPointMake(self.view.center.x, self.compareImageView.center.y);
    self.compareImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.compareImageView setImage:[UIImage imageNamed:@"jielunFace4"]];
    [self.view addSubview:self.compareImageView];
    
    UIButton *selectCompareImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 420 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    selectCompareImageButton.center = CGPointMake(self.view.center.x, selectCompareImageButton.center.y);
    selectCompareImageButton.backgroundColor = [UIColor lightGrayColor];
    [selectCompareImageButton setTitle:@"选择图片" forState:UIControlStateNormal];
    [selectCompareImageButton addTarget:self action:@selector(compareImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectCompareImageButton];
    
    UIButton *compareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 450 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    compareButton.backgroundColor = [UIColor lightGrayColor];
    [compareButton setTitle:@"对比" forState:UIControlStateNormal];
    [compareButton addTarget:self action:@selector(compareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:compareButton];
    
        self.myPicker = [[HGSelectPhotoViewController alloc]init];
        self.comparePicker = [[HGSelectPhotoViewController alloc]init];
    
//    [self getFeature];
}

#pragma mark - Methods
- (void)getFeature{
    NSError *nowFaceError;
    NSArray *nowFaceMtcnnResult = [self.tool detectPersonMaxFace:self.nowImageView.image error:&nowFaceError];
    if (!nowFaceError) {
        self.nowfeatures = [self.tool getFaceFeaturesWithPersonImage:self.nowImageView.image landmarks:nowFaceMtcnnResult.firstObject];
    }
    
    NSError *compareFaceError;
    NSArray *compareFaceMtcnnResult = [self.tool detectPersonMaxFace:self.compareImageView.image error:&compareFaceError];
    if (!compareFaceError) {
        self.comparefeatures = [self.tool getFaceFeaturesWithPersonImage:self.compareImageView.image landmarks:compareFaceMtcnnResult.firstObject];
    }

}
#pragma mark - Actions
- (void)nowImageButtonClick{

    __weak typeof(self) weakSelf = self;
    [self.myPicker getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage *image) {
        [weakSelf.nowImageView setImage:image];
        //提取图片人脸特征
//        [weakSelf getFeature];
    }];
}

- (void)compareImageButtonClick{
    __weak typeof(self) weakSelf = self;
    [self.comparePicker getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage *image) {
        [weakSelf.compareImageView setImage:image];
        //提取图片人脸特征
//        [weakSelf getFeature];
    }];
}

- (void)compareButtonClick{
   //直接图片对比 速度较慢会有延时
    NSError *error;
   CGFloat score = [HGFaceCompareFeattureTool compareFaceIsSimilarity:self.nowImageView.image compareFaceImage:self.compareImageView.image error:&error];
    
    
    //通过图片特征对比 速度较快
//    NSDictionary *dic = [HGFaceCompareFeattureTool findMostSimilarityFeature:self.nowfeatures inFeatureDataSource:@[self.comparefeatures]];
    
//    CGFloat score = [dic[@"maxScore"] floatValue];
    
    NSLog(@"%@",error.localizedDescription);
    
    UIAlertController *alterVc = [UIAlertController alertControllerWithTitle:@"对比结果" message:[NSString stringWithFormat:error ? error.localizedDescription : @"分值:%f (大于85可判定为同一人)",score] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"好的" style:UIAlertActionStyleDefault handler: nil];

    [alterVc addAction:okAction];

    [self presentViewController:alterVc animated:YES completion:nil];
}
#pragma mark - Getters

#pragma mark - Setters

@end
