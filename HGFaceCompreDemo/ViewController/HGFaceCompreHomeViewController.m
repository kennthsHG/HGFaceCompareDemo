//
//  HGFaceCompreHomeViewController.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGFaceCompreHomeViewController.h"
#import "HGComparePhotosViewController.h"
#import "HGFaceCompareViewController.h"
#import "HGSavePersonInfoViewController.h"
#import "HGPersonListViewController.h"

@interface HGFaceCompreHomeViewController ()

@end

@implementation HGFaceCompreHomeViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - UI
- (void)initUI{
    self.title = @"人脸识别";
    
     UIButton *faceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 150, 50)];
     faceButton.backgroundColor = [UIColor lightGrayColor];
     [faceButton setTitle:@"人脸识别" forState:UIControlStateNormal];
     [faceButton addTarget:self action:@selector(faceButtonClick) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:faceButton];
    
    UIButton *saveFeatureButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 180, 150, 50)];
    saveFeatureButton.backgroundColor = [UIColor lightGrayColor];
    [saveFeatureButton setTitle:@"人脸保存" forState:UIControlStateNormal];
    [saveFeatureButton addTarget:self action:@selector(saveFaceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveFeatureButton];
    
    UIButton *personFeatureListButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 260, 150, 50)];
    personFeatureListButton.backgroundColor = [UIColor lightGrayColor];
    [personFeatureListButton setTitle:@"人脸列表" forState:UIControlStateNormal];
    [personFeatureListButton addTarget:self action:@selector(personFeatureListButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personFeatureListButton];
    
    
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 340, 150, 50)];
    imageButton.backgroundColor = [UIColor lightGrayColor];
    [imageButton setTitle:@"人脸图片对比" forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageButton];
}

#pragma mark - Methods

#pragma mark - Actions
- (void)faceButtonClick{
    HGFaceCompareViewController *VC = [[HGFaceCompareViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)saveFaceButtonClick{
    HGSavePersonInfoViewController *VC = [[HGSavePersonInfoViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)imageButtonClick{
    HGComparePhotosViewController *VC = [[HGComparePhotosViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)personFeatureListButtonClick{
    HGPersonListViewController *VC = [[HGPersonListViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Getters

#pragma mark - Setters



@end
