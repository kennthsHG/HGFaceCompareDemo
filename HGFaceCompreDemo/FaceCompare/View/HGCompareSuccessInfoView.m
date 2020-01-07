//
//  HGCompareSuccessInfoView.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2019/12/31.
//  Copyright © 2019 Gang. All rights reserved.
//

#import "HGCompareSuccessInfoView.h"

@interface HGCompareSuccessInfoView()

@property(nonatomic, strong) HGPersonFeatureModel *person;
@property(nonatomic, assign) CGFloat score;
@property(nonatomic, copy) dispatch_block_t dismissBlock;

@end

@implementation HGCompareSuccessInfoView

+ (void)showCompreSuccessView:(HGPersonFeatureModel *)person
                        score:(CGFloat)score
                      addView:(UIView *)addView
                dissMissBlock:(dispatch_block_t)dismissBlock{
    
    HGCompareSuccessInfoView *view = [[HGCompareSuccessInfoView alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 30, 120) score:score person:person dissMissBlock:dismissBlock];
    [addView addSubview:view];
    
}

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame
                        score:(CGFloat)score
                       person:(HGPersonFeatureModel *)person
                dissMissBlock:(dispatch_block_t)dismissBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.person = person;
        self.score = score;
        self.dismissBlock = dismissBlock;
        [self initCommonUI];
    }
    return self;
}

#pragma mark - UI
- (void)initCommonUI{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self animateIn];
    
    UIImageView *personHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 60, 60)];
    personHeaderImageView.center = CGPointMake(personHeaderImageView.center.x, 65);
    [personHeaderImageView setImage:self.person.personImage];
    personHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    personHeaderImageView.layer.cornerRadius = 30.f;
    personHeaderImageView.clipsToBounds = YES;
    [self addSubview:personHeaderImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    [nameLabel setText:[NSString stringWithFormat:@"姓名：%@",self.person.name]];
    [self addSubview:nameLabel];
    
    
    UILabel *idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    idCardLabel.textAlignment = NSTextAlignmentLeft;
    idCardLabel.textColor = [UIColor blackColor];
    idCardLabel.font = [UIFont systemFontOfSize:16];
    [idCardLabel setText:[NSString stringWithFormat:@"身份证：%@",self.person.personCardid]];
    [self addSubview:idCardLabel];
    
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = [UIColor blackColor];
    positionLabel.font = [UIFont systemFontOfSize:16];
    [positionLabel setText:[NSString stringWithFormat:@"职位：%@",self.person.position]];
    [self addSubview:positionLabel];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 85, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    scoreLabel.textColor = [UIColor systemBlueColor];
    scoreLabel.font = [UIFont systemFontOfSize:16];
    [scoreLabel setText:[NSString stringWithFormat:@"分值:%.1f",self.score]];
    [self addSubview:scoreLabel];
    
    [self performSelector:@selector(animateOut) withObject:nil afterDelay:3.f];
}

#pragma mark - Methods
- (void)animateIn{
    [UIView animateWithDuration:0.4f animations:^{
        self.frame = CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 130, [UIScreen mainScreen].bounds.size.width - 30, 120);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animateOut{
    [self endEditing:YES];
    [UIView animateWithDuration:0.4f animations:^{
        self.frame = CGRectMake(15, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 30, 120);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.dismissBlock ? self.dismissBlock() : nil;
    }];
}

@end
