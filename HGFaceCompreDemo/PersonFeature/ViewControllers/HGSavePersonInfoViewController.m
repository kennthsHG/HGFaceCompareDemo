//
//  HGSavePersonInfoViewController.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGSavePersonInfoViewController.h"
#import "HGDBManager.h"
#import "HGSelectPhotoViewController.h"
#import "HGFaceMtcnnTool.h"

@interface HGSavePersonInfoViewController ()

@property (nonatomic, strong) HGFaceMtcnnTool *tool;
@property (nonatomic, strong) HGSelectPhotoViewController *myPicker;

@property (nonatomic, strong) UIImageView *personFaceImageView;
@property (nonatomic, strong) UITextField *personNameTextField;
@property (nonatomic, strong) UITextField *personCardidTextField;
@property (nonatomic, strong) UITextField *personPositionTextField;

@property (nonatomic, strong) NSArray *personFeatureArray;

@end

@implementation HGSavePersonInfoViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - UI
- (void)initUI{
    self.title = @"保存人脸信息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tool = [[HGFaceMtcnnTool alloc]init];
    self.myPicker = [[HGSelectPhotoViewController alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    UIButton *rigthSaveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rigthSaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [rigthSaveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rigthSaveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rigthSaveButton];
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.personFaceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2)];
    self.personFaceImageView.center = CGPointMake(self.view.center.x, self.personFaceImageView.center.y);
    self.personFaceImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.personFaceImageView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.personFaceImageView];
    
    UIButton *inPutFaceButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 120 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    inPutFaceButton.center = CGPointMake(self.view.center.x, inPutFaceButton.center.y);
    inPutFaceButton.backgroundColor = [UIColor lightGrayColor];
    [inPutFaceButton setTitle:@"录入人脸" forState:UIControlStateNormal];
    [inPutFaceButton addTarget:self action:@selector(inPutFaceButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inPutFaceButton];
    
    UILabel *personNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 180 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    [personNameLabel setText:@"姓名:"];
    [personNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:personNameLabel];
    
    self.personNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
    self.personNameTextField.center = CGPointMake(self.personNameTextField.center.x, personNameLabel.center.y);
    self.personNameTextField.layer.cornerRadius = 5;
    self.personNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.personNameTextField.layer.borderWidth = 1;
    self.personNameTextField.layer.masksToBounds = YES;
    [self.personNameTextField setPlaceholder:@"请输入姓名"];
    [self.view addSubview:self.personNameTextField];
 
    UILabel *personCardidLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 240 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    [personCardidLabel setText:@"身份证:"];
    [personCardidLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:personCardidLabel];
    
    self.personCardidTextField = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
    self.personCardidTextField.center = CGPointMake(self.personCardidTextField.center.x, personCardidLabel.center.y);
    self.personCardidTextField.layer.cornerRadius = 5;
    self.personCardidTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.personCardidTextField.layer.borderWidth = 1;
    self.personCardidTextField.layer.masksToBounds = YES;
    [self.personCardidTextField setPlaceholder:@"请输入身份证"];
    [self.view addSubview:self.personCardidTextField];
    
    UILabel *personPositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 290 + [UIScreen mainScreen].bounds.size.width/2, 100, 40)];
    [personPositionLabel setText:@"职位:"];
    [personPositionLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:personPositionLabel];
    
    self.personPositionTextField = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
    self.personPositionTextField.center = CGPointMake(self.personPositionTextField.center.x, personPositionLabel.center.y);
    self.personPositionTextField.layer.cornerRadius = 5;
    self.personPositionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.personPositionTextField.layer.borderWidth = 1;
    self.personPositionTextField.layer.masksToBounds = YES;
    [self.personPositionTextField setPlaceholder:@"请输入职位"];
    [self.view addSubview:self.personPositionTextField];
}

#pragma mark - Methods
- (void)hideKeyBoard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (void)getFeature:(UIImage *)image{
    
    NSError *error;
    NSArray *nowFaceMtcnnResult = [self.tool detectPersonMaxFace:image error:&error];
    NSLog(@"%@",nowFaceMtcnnResult);
    
    if (error) {
        UIAlertController *alterVc = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"好的" style:UIAlertActionStyleDefault handler: nil];

        [alterVc addAction:okAction];

        [self presentViewController:alterVc animated:YES completion:nil];
        return;
    }
    [self.personFaceImageView setImage:image];
    self.personFeatureArray = [self.tool getFaceFeaturesWithPersonImage:self.personFaceImageView.image landmarks:nowFaceMtcnnResult.firstObject];
}

#pragma mark - Actions
- (void)saveButtonAction{
    NSString *errorText;
    if (self.personFeatureArray.count == 0) {
        errorText = @"请录入人脸信息";
    }
    else if (self.personNameTextField.text.length == 0){
        errorText = @"请录入姓名";
    }
    else if (self.personCardidTextField.text.length == 0){
        errorText = @"请录入身份证";
    }
    else if (self.personPositionTextField.text.length == 0){
        errorText = @"请录入职位";
    }
    
    if (errorText.length > 0) {
        UIAlertController *alterVc = [UIAlertController alertControllerWithTitle:@"提示" message:errorText preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"好的" style:UIAlertActionStyleDefault handler: nil];

        [alterVc addAction:okAction];

        [self presentViewController:alterVc animated:YES completion:nil];
        return;
    }
    else{
        HGPersonFeatureModel *model = [[HGPersonFeatureModel alloc]init];
        model.name = self.personNameTextField.text;
        model.personCardid = self.personCardidTextField.text;
        model.position = self.personPositionTextField.text;
        model.faceFeatureData = self.personFeatureArray;
        model.personImage = self.personFaceImageView.image;
        
       BOOL result = [[HGDBManager sharedInstance]savePersonModel:model];
        if (result) {
            UIAlertController *alterVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存人脸成功" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];

            [alterVc addAction:okAction];

            [self presentViewController:alterVc animated:YES completion:nil];
        }
        else{
            UIAlertController *alterVc = [UIAlertController alertControllerWithTitle:@"提示" message:errorText preferredStyle:UIAlertControllerStyleAlert];

              UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"保存人脸失败" style:UIAlertActionStyleDefault handler:nil];

              [alterVc addAction:okAction];

              [self presentViewController:alterVc animated:YES completion:nil];
        }
    }
    
}

- (void)inPutFaceButtonButtonClick{
     __weak typeof(self) weakSelf = self;
    [self.myPicker getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage *image) {
            //提取图片人脸特征
        [weakSelf getFeature:image];
    }];
}

#pragma mark - Getters

#pragma mark - Setters

@end
