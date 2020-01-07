//
//  HGPersonListTableViewCell.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2020/1/7.
//  Copyright © 2020 Gang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPersonFeatureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGPersonListTableViewCell : UITableViewCell

- (void)configCellWithModel:(HGPersonFeatureModel *)model;

@end

NS_ASSUME_NONNULL_END
