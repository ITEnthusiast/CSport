//
//  CPInfoView.m
//  CSport
//
//  Created by MacBook Pro on 2018/4/28.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import "CPInfoView.h"
@interface CPInfoView ()

@property (nonatomic, strong) UIButton *logOutButton;
@property (nonatomic, strong) UIButton *avatarImage;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *yht_Label;
@property (nonatomic, strong) UILabel *data1_Label;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) UILabel *km_Label;
@property (nonatomic, strong) UILabel *ot_Label;
@property (nonatomic, strong) UILabel *data2_Label;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, strong) UILabel *t_Label;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) UIButton *restButton;

@property (nonatomic, assign) BOOL isOnLine;

@end

@implementation CPInfoView

-(UIButton *)logOutButton {
    if (!_logOutButton) {
        _logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutButton.backgroundColor = k_COLOR_THEME;
        [_logOutButton setTitle:@"LogOut" forState:UIControlStateNormal];
        _logOutButton.hidden = !_isOnLine;
        _logOutButton.tag = CPActionTypeLogOut;
        [_logOutButton addTarget:self action:@selector(actionTypeCallBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutButton;
}

-(UIButton *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarImage.backgroundColor = k_COLOR_THEME;
        [_avatarImage setBackgroundImage:[UIImage imageNamed:@"avarDefault"] forState:UIControlStateNormal];
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.cornerRadius = 30;
        _avatarImage.tag = CPActionTypeLogin;
        [_avatarImage addTarget:self action:@selector(actionTypeCallBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarImage;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        _nameLabel.text = self.isOnLine? [userInfo objectForKey:k_CurrentUser]: @"Please Login";
        _nameLabel.textColor = k_COLOR_THEME;
    }
    return _nameLabel;
}

-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = k_COLOR_THEME;
    }
    return _contentView;
}

-(UILabel *)yht_Label {
    if (!_yht_Label) {
        _yht_Label = [[UILabel alloc] init];
        _yht_Label.text = @"You have traveled";
        _yht_Label.textColor = [UIColor whiteColor];
        _yht_Label.font = [UIFont systemFontOfSize:25];
    }
    return _yht_Label;
}

-(UILabel *)data1_Label {
    if (!_data1_Label) {
        _data1_Label = [[UILabel alloc] init];
        _data1_Label.text = @"0";
        _data1_Label.textColor = [UIColor whiteColor];
        _data1_Label.textAlignment = NSTextAlignmentCenter;
        _data1_Label.font = [UIFont systemFontOfSize:30];
        _data1_Label.backgroundColor = k_COLOR_THEME;
    }
    return _data1_Label;
}

-(UILabel *)km_Label {
    if (!_km_Label) {
        _km_Label = [[UILabel alloc] init];
        _km_Label.text = @"KM";
        _km_Label.textColor = [UIColor whiteColor];
        _km_Label.font = [UIFont systemFontOfSize:30];
    }
    return _km_Label;
}

-(UILabel *)ot_Label {
    if (!_ot_Label) {
        _ot_Label = [[UILabel alloc] init];
        _ot_Label.text = @"You already walked";
        _ot_Label.textColor = [UIColor whiteColor];
    }
    return _ot_Label;
}

-(UILabel *)data2_Label {
    if (!_data2_Label) {
        _data2_Label = [[UILabel alloc] init];
        _data2_Label.text = @"0";
        _data2_Label.textColor = [UIColor whiteColor];
    }
    return _data2_Label;
}

-(UILabel *)t_Label {
    if (!_t_Label) {
        _t_Label = [[UILabel alloc] init];
        _t_Label.text = @"steps.";
        _t_Label.textColor = [UIColor whiteColor];
    }
    return _t_Label;
}

-(UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = [UIColor redColor];
        _startButton.layer.cornerRadius = 50;
        _startButton.tag = CPActionTypeStart;
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(actionTypeCallBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

-(UIButton *)endButton {
    if (!_endButton) {
        _endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _endButton.backgroundColor = k_COLOR_THEME;
        _endButton.hidden = YES;
        _endButton.tag = CPActionTypeEnd;
        [_endButton setTitle:@"End" forState:UIControlStateNormal];
        [_endButton addTarget:self action:@selector(actionTypeCallBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endButton;
}

-(UIButton *)restButton {
    if (!_restButton) {
        _restButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _restButton.backgroundColor = k_COLOR_THEME;
        _restButton.hidden = YES;
        _restButton.tag = CPActionTypeRest;
        [_restButton setTitle:@"Rest" forState:UIControlStateNormal];
        [_restButton addTarget:self action:@selector(actionTypeCallBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restButton;
}

-(instancetype)initWithFrame:(CGRect)frame callBack:(actionTypeCallBack)actionTypeCallback{
    if (self = [super initWithFrame:frame]) {
        self.actionTypeCallback = actionTypeCallback;
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSString *nickName = [userInfo objectForKey:k_CurrentUser];
        self.isOnLine = nickName? YES: NO;
        
        [self addSubview:self.logOutButton];
        
        [self addSubview:self.avatarImage];
        [self addSubview:self.nameLabel];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.yht_Label];
        [self.contentView addSubview:self.data1_Label];
        [self.contentView addSubview:self.km_Label];
        [self.contentView addSubview:self.ot_Label];
        [self.contentView addSubview:self.data2_Label];
        [self.contentView addSubview:self.t_Label];
        
        [self addSubview:self.startButton];
        [self addSubview:self.endButton];
        [self addSubview:self.restButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints {
    [super updateConstraints];
    
    [self.logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(30);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarImage);
        make.top.equalTo(self.avatarImage.mas_bottom).offset(10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(k_Layout_Screen_Width*0.4);
    }];
    
    [self.yht_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.contentView).offset(10);
    }];
    
    [self.km_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yht_Label.mas_bottom).offset(10);
        make.right.equalTo(self.yht_Label).offset(-20);
    }];
    
    [self.data1_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yht_Label.mas_bottom).offset(10);
        make.left.equalTo(self.yht_Label).offset(20);
    }];
    
    [self.ot_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.data1_Label.mas_bottom).offset(10);
        make.left.equalTo(self.yht_Label);
    }];
    
    [self.data2_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ot_Label);
        make.left.equalTo(self.ot_Label.mas_right).offset(10);
    }];
    
    [self.t_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.data2_Label);
        make.left.equalTo(self.data2_Label.mas_right).offset(10);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
    }];
    
    [self.restButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.endButton);
        make.width.height.equalTo(self.endButton);
        make.top.equalTo(self.endButton.mas_bottom).offset(10);
    }];
}

-(void)actionTypeCallBack:(UIButton *)sender {
    switch (sender.tag) {
        case CPActionTypeLogin: {
            if (self.isOnLine) return;
            self.actionTypeCallback(CPActionTypeLogin);
        }
            break;
            
        case CPActionTypeLogOut: {
            self.actionTypeCallback(CPActionTypeLogOut);
        }
            break;
        case CPActionTypeStart: {
            if (!self.isOnLine) {
                self.actionTypeCallback(CPActionTypeLogin);
                return;
            }
            self.startButton.hidden = YES;
            self.restButton.hidden = NO;
            self.endButton.hidden = NO;
            self.actionTypeCallback(CPActionTypeStart);
            
        }
            break;
        case CPActionTypeRest: {
            self.startButton.hidden = NO;
            self.restButton.hidden = YES;
            self.endButton.hidden = YES;
            [self.startButton setTitle:@"ReStart" forState:UIControlStateNormal];
            self.actionTypeCallback(CPActionTypeRest);
        }
            break;
        case CPActionTypeEnd: {
            self.startButton.hidden = NO;
            self.restButton.hidden = YES;
            self.endButton.hidden = YES;
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
            self.actionTypeCallback(CPActionTypeEnd);
        }
            break;
    }
}

-(void)updateUserInfo:(NSString *)nickName password:(NSString *)password {
    if (!nickName) {
        self.isOnLine = NO;
        self.startButton.hidden = NO;
        self.restButton.hidden = YES;
        self.endButton.hidden = YES;
        self.logOutButton.hidden = YES;
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        self.nameLabel.text = @"Please Login";
    }
    else {
        self.isOnLine = YES;
        self.logOutButton.hidden = NO;
        self.nameLabel.text = nickName;
    }
}

-(void)updateDistance:(CGFloat)distance {
    _distance = distance;
    self.data1_Label.text = [NSString stringWithFormat:@"%.3f", distance];
}

-(void)updateStepCount:(NSInteger)stepCount {
    _stepCount = stepCount;
    self.data2_Label.text = [NSString stringWithFormat:@"%ld", stepCount];
}

@end
