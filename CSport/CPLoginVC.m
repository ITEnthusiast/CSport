//
//  CPLoginVC.m
//  CSport
//
//  Created by MacBook Pro on 2018/4/30.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import "CPLoginVC.h"
#import "CPRegisterVC.h"
#import "CPUserModel.h"
#import "CPDBManager.h"

#define DBNAME @"UserInfo"
#define EXTENSION @"archiver"

@interface CPLoginVC ()

@property (nonatomic, strong) UIScrollView *baseView;
@property(nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) UILabel *w_label;
@property (nonatomic, strong) UILabel *t_label;
@property (nonatomic, strong) UILabel *hk_label;
@property (nonatomic, strong) UILabel *syjrn_label;

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UILabel *fmp_label;
@property (nonatomic, copy)NSString *currentNickName;
@property (nonatomic, copy)NSString *currentPassword;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIView *registerBottomLine;

@end

@implementation CPLoginVC

-(UIScrollView *)baseView {
    if (!_baseView) {
        _baseView = [[UIScrollView alloc] init];
        _baseView.backgroundColor = [UIColor clearColor];
    }
    return _baseView;
}

- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

-(UILabel *)w_label {
    if (!_w_label) {
        _w_label = [[UILabel alloc] init];
        _w_label.text = @"WELCOME";
        _w_label.font = [UIFont systemFontOfSize:40];
        _w_label.textColor = [UIColor whiteColor];
    }
    return _w_label;
}

-(UILabel *)t_label {
    if (!_t_label) {
        _t_label = [[UILabel alloc] init];
        _t_label.text = @"TO";
        _t_label.font = [UIFont systemFontOfSize:40];
        _t_label.textColor = [UIColor whiteColor];
    }
    return _t_label;
}

-(UILabel *)hk_label {
    if (!_hk_label) {
        _hk_label = [[UILabel alloc] init];
        _hk_label.text = @"HIGH KING!";
        _hk_label.font = [UIFont systemFontOfSize:40];
        _hk_label.textColor = [UIColor whiteColor];
    }
    return _hk_label;
}

-(UILabel *)syjrn_label {
    if (!_syjrn_label) {
        _syjrn_label = [[UILabel alloc] init];
        _syjrn_label.text = @"Start your journey right now!";
        _syjrn_label.textColor = [UIColor whiteColor];
    }
    return _syjrn_label;
}

-(UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        [self setTextFieldStyleFor:_accountTextField withPlaceholderStr:@"email/account No"];
        _accountTextField.keyboardType = UIKeyboardTypeAlphabet;
        _accountTextField.tag = CPLoginVCTypeNikeName;
        [_accountTextField addTarget:self action:@selector(activeTextField:) forControlEvents:UIControlEventEditingChanged];
        [_accountTextField withBlockForDidBeginEditing:^(UITextField *view) {
            
            _accountTextField.layer.borderWidth = 1;
            _accountTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        }];
        [_accountTextField withBlockForDidEndEditing:^(UITextField *view) {
            
            _accountTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        }];
    }
    return _accountTextField;
}

-(UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        [self setTextFieldStyleFor:_passwordTextField withPlaceholderStr:@"password"];
        _passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
        _passwordTextField.tag = CPRegisterVCTypePassword;
        [_passwordTextField addTarget:self action:@selector(activeTextField:) forControlEvents:UIControlEventEditingChanged];
        [_passwordTextField withBlockForDidBeginEditing:^(UITextField *view) {
            
            _passwordTextField.layer.borderWidth = 1;
            _passwordTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        }];
        [_passwordTextField withBlockForDidEndEditing:^(UITextField *view) {
            
            _passwordTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        }];
    }
    return _passwordTextField;
}

-(UIView *)leftView {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/3, 65/3)];
    leftView.backgroundColor = [UIColor clearColor];
    return leftView;
}

-(UILabel *)fmp_label {
    if (!_fmp_label) {
        _fmp_label = [[UILabel alloc] init];
        _fmp_label.text = @"forgot my password?";
        _fmp_label.textColor = [UIColor whiteColor];
    }
    return _fmp_label;
}

-(UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = k_COLOR_THEME;
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.backgroundColor = [UIColor clearColor];
        [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(showRegisterVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(UIView *)registerBottomLine {
    if (!_registerBottomLine) {
        _registerBottomLine = [[UIView alloc] init];
        _registerBottomLine.backgroundColor = [UIColor whiteColor];
    }
    return _registerBottomLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.contentView];
    [self.contentView addSubview:self.w_label];
    [self.contentView addSubview:self.t_label];
    [self.contentView addSubview:self.hk_label];
    [self.contentView addSubview:self.syjrn_label];
    
    [self.contentView addSubview:self.accountTextField];
    [self.contentView addSubview:self.passwordTextField];
    [self.contentView addSubview:self.fmp_label];
    
    [self.contentView addSubview:self.loginButton];
    [self.contentView addSubview:self.registerButton];
    [self.contentView addSubview:self.registerBottomLine];
    
    
    [self.view setNeedsUpdateConstraints];
    
    [self.baseView handleKeyboard];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(k_Layout_Screen_Height-20);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseView);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(k_Layout_Screen_Height-20);
    }];
    
    [self.w_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(20);
        make.top.equalTo(self.baseView).offset(64);
    }];
    
    [self.t_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.w_label);
        make.top.equalTo(self.w_label.mas_bottom).offset(10);
    }];
    
    [self.hk_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.t_label);
        make.top.equalTo(self.t_label.mas_bottom).offset(10);
    }];
    
    [self.syjrn_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hk_label);
        make.top.equalTo(self.hk_label.mas_bottom).offset(40);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.syjrn_label.mas_bottom).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(40);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTextField);
        make.top.equalTo(self.accountTextField.mas_bottom).offset(10);
    }];
    
    [self.fmp_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
        make.right.equalTo(self.passwordTextField);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.equalTo(self.passwordTextField);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(40);
        make.width.mas_equalTo(100);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.loginButton);
        make.top.equalTo(self.loginButton.mas_bottom).offset(10);
    }];
    
    [self.registerBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registerButton).offset(10);
        make.right.equalTo(self.registerButton).offset(-10);
        make.top.equalTo(self.registerButton.mas_bottom);
        make.height.mas_equalTo(5);
    }];
}

-(void)setTextFieldStyleFor:(UITextField *)textField withPlaceholderStr:(NSString *)placeholderStr {
    textField.placeholder = placeholderStr;
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.textColor = [UIColor whiteColor];
    textField.leftView = [self leftView];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void)activeTextField:(UITextField *)textField {
    NSString *string = [textField text];
    switch (textField.tag) {
        case CPLoginVCTypeNikeName:
            _currentNickName = string;
            break;
        case CPLoginVCTypePassword:
            _currentPassword = string;
            break;
    }
}

-(void)showRegisterVC:(UIButton *)sender {
    CPRegisterVC *registerVC = [[CPRegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 登陆\注册
- (void)loginAction {
    NSLog(@"用户名:%@， 密码:%@", _currentNickName, _currentPassword);
    
    // 生成数据库文件路径
    NSString *filePath = [self pathOfDBWithName:DBNAME andExtension:EXTENSION];
    
    CPDBManager *dbManager = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!dbManager) {
        [MBProgressHUD showErrorWithMessage:@"Account Or Password Disable"];
        return;
    }
    for (CPUserModel *userModel in dbManager.mArray) {
        if ([_currentNickName isEqualToString:userModel.nickName]) {
            if ([_currentPassword isEqualToString:userModel.password]) {
                [MBProgressHUD showSuccessWithMessage:@"Login Success"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:k_NotificationUserLoginSuccess object:userModel];
                return;
            }
        }
        [MBProgressHUD showErrorWithMessage:@"Account Or Password Disable"];
    }
}

- (NSString *)pathOfDBWithName:(NSString *)name andExtension:(NSString *)extension{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath objectAtIndex:0];
    NSString *filePath = [[path stringByAppendingPathComponent:name] stringByAppendingPathExtension:extension];
    return filePath;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
