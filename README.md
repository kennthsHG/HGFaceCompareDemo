# HGFaceCompareDemo

人脸识别，人脸特征提取，两张人脸图片对比
==============

## 主要功能

    * 摄像头实时读取视频，对比数据库的人脸数据，对比出最相似的人脸
    * 提取出人脸位置的正方形框
    * 支持两张人脸图直接对比，对比出分值按实际效果确定

## 重要
重要的方法，已经封装成了.a库，暂不开源，以后完善完活体识别会考虑开源，。实际使用中，由于姿态等问题可能会导致误识别，有什么问题可以来我的简书联系我哦

## 集成
demo中集成了ncnn，opencv，训练模型，ncnn已经集成进去了，要运行程序还需下载opencv2加入项目Frameworks文件中，需要带ios.h的版本，直接下载最新的就可以使用了，还需要加入一个mlmmodel,这里提供下下载地址，下载后拖进Frameworks文件中就可以了   
[mlmmodel地址](https://pan.baidu.com/s/1hLW1xEwkJcaOUXHXAjdRuA) 提取密码:tr0s 

## 使用方法
 1、提取人脸特征
 ```
 NSError *error;
 NSArray *nowFaceMtcnnResult = [self.tool detectPersonMaxFace:image error:&error];
  if (error) {
        UIAlertController *alterVc = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"好的" style:UIAlertActionStyleDefault handler: nil];

        [alterVc addAction:okAction];

        [self presentViewController:alterVc animated:YES completion:nil];
        return;
    }
self.personFeatureArray = [self.tool getFaceFeaturesWithPersonImage:self.personFaceImageView.image landmarks:nowFaceMtcnnResult.firstObject];
 ```
 
 2.对比人脸
 2.1 直接图片对比 速度较慢会有延时
 ```
 NSError *error;
 CGFloat score = [HGFaceCompareFeattureTool compareFaceIsSimilarity:self.nowImageView.image compareFaceImage:self.compareImageView.image error:&error];
 ```
 2.2 对比特征库特征点
 ```
 NSDictionary *simResult = [HGFaceCompareFeattureTool findMostSimilarityFeature:features inFeatureDataSource:whichFeaturesArray];
 NSInteger index = [simResult[@"maxScoreIndex"] integerValue];
 CGFloat score = [simResult[@"maxScore"] floatValue];
 ```

## 效果图

1、录入人脸   
![image](https://github.com/kennthsHG/Image/blob/master/first.gif)

2、对比人脸   
![image](https://github.com/kennthsHG/Image/blob/master/second.gif)

3、两张人脸对比   
![image](https://github.com/kennthsHG/Image/blob/master/third.gif)
![image](https://github.com/kennthsHG/Image/blob/master/four.gif)

## 我的简书
[我的简书](https://www.jianshu.com/u/5260c7f4c687 "参考")  

