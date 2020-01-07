//
//  FaceMaskView.h
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/30.
//  Copyright © 2019 Gang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceMaskView : UIView

@property (nonatomic,copy) NSArray <NSValue *>*faces;
@property (nonatomic,assign) CGSize picSize;
@property (nonatomic,copy) void(^tap)(void);

@end

NS_ASSUME_NONNULL_END
