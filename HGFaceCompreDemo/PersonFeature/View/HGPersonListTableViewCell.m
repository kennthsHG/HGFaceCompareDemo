//
//  HGPersonListTableViewCell.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2020/1/7.
//  Copyright © 2020 Gang. All rights reserved.
//

#import "HGPersonListTableViewCell.h"

@interface HGPersonListTableViewCell()

@property (nonatomic, strong) UIImageView *personHeaderImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idCardLabel;
@property (nonatomic, strong) UILabel *positionLabel;

@end

@implementation HGPersonListTableViewCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self initUI];
    }
    return self;
}

#pragma mark - UI
- (void)initUI{
    UIImageView *personHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 60, 60)];
    personHeaderImageView.center = CGPointMake(personHeaderImageView.center.x, 50);
    personHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    personHeaderImageView.layer.cornerRadius = 30.f;
    personHeaderImageView.clipsToBounds = YES;
    [self.contentView addSubview:personHeaderImageView];
    self.personHeaderImageView = personHeaderImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView  addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    idCardLabel.textAlignment = NSTextAlignmentLeft;
    idCardLabel.textColor = [UIColor blackColor];
    idCardLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView  addSubview:idCardLabel];
    self.idCardLabel = idCardLabel;
    
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, [UIScreen mainScreen].bounds.size.width/3*2, 20)];
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = [UIColor blackColor];
    positionLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView  addSubview:positionLabel];
    self.positionLabel = positionLabel;
}

#pragma mark - Methods
- (void)configCellWithModel:(HGPersonFeatureModel *)model{
    [self.personHeaderImageView setImage:model.personImage];
    [self.nameLabel setText:[NSString stringWithFormat:@"姓名：%@",model.name]];
    [self.idCardLabel setText:[NSString stringWithFormat:@"身份证：%@",model.personCardid]];
    [self.positionLabel setText:[NSString stringWithFormat:@"职位：%@",model.position]];
}

#pragma mark - Actions

#pragma mark - Getters


@end
