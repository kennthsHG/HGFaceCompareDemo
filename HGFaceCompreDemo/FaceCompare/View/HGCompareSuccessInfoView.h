//
//  HGCompareSuccessInfoView.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPersonFeatureModel.h"

@interface HGCompareSuccessInfoView : UIView

+ (void)showCompreSuccessView:(HGPersonFeatureModel *)person
                        score:(CGFloat)score
                      addView:(UIView *)addView
                dissMissBlock:(dispatch_block_t)dismissBlock;

@end

