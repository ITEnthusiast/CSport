//
//  CPRegisterVC.m
//  CSport
//
//  Created by MacBook Pro on 2018/4/30.
//  Copyright © 2018年 caopei. All rights reserved.
//

#import "CPRegisterVC.h"
#import "CPUserModel.h"
#import "CPDBManager.h"

#define DBNAME @"UserInfo"
#define EXTENSION @"archiver"

@interface CPRegisterVC ()

@property (nonatomic, strong) UIScrollView *baseView;
@property(nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) UILabel *w_label;
@property (nonatomic, strong) UILabel *t_label;
@property (nonatomic, strong) UILabel *hk_label;
@property (nonatomic, strong) UILabel *syjrn_label;

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *re_PasswordTextField;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, copy)NSString *currentNickName;
@property (nonatomic, copy)NSString *currentPassword;
@property (nonatomic, copy)NSString *currentRePassword;

@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation CPRegisterVC

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
        _w_label.text = @"REGISTER";
        _w_label.font = [UIFont systemFontOfSize:40];
        _w_label.textColor = [UIColor whiteColor];
    }
    return _w_label;
}

-(UILabel *)t_label {
    if (!_t_label) {
        _t_label = [[UILabel alloc] init];
        _t_label.text = @"YOUR";
        _t_label.font = [UIFont systemFontOfSize:40];
        _t_label.textColor = [UIColor whiteColor];
    }
    return _t_label;
}

-(UILabel *)hk_label {
    if (!_hk_label) {
        _hk_label = [[UILabel alloc] init];
        _hk_label.text = @"ACCOUNT!";
        _hk_label.font = [UIFont systemFontOfSize:40];
        _hk_label.textColor = [UIColor whiteColor];
    }
    return _hk_label;
}

-(UILabel *)syjrn_label {
    if (!_syjrn_label) {
        _syjrn_label = [[UILabel alloc] init];
        _syjrn_label.text = @"Ready for your journey right now!";
        _syjrn_label.textColor = [UIColor whiteColor];
    }
    return _syjrn_label;
}

-(UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        [self setTextFieldStyleFor:_accountTextField withPlaceholderStr:@"email/account No"];
        _accountTextField.keyboardType = UIKeyboardTypeAlphabet;
        _accountTextField.tag = CPRegisterVCTypeNikeName;
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

-(UITextField *)re_PasswordTextField {
    if (!_re_PasswordTextField) {
        _re_PasswordTextField = [[UITextField alloc] init];
        [self setTextFieldStyleFor:_re_PasswordTextField withPlaceholderStr:@"verify your password"];
        _re_PasswordTextField.keyboardType = UIKeyboardTypeAlphabet;
        _re_PasswordTextField.tag = CPRegisterVCTypeRePassword;
        [_re_PasswordTextField addTarget:self action:@selector(activeTextField:) forControlEvents:UIControlEventEditingChanged];
        [_re_PasswordTextField withBlockForDidBeginEditing:^(UITextField *view) {
            
            _re_PasswordTextField.layer.borderWidth = 1;
            _re_PasswordTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        }];
        [_re_PasswordTextField withBlockForDidEndEditing:^(UITextField *view) {
            
            _re_PasswordTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        }];
    }
    return _re_PasswordTextField;
}

-(UIView *)leftView {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/3, 65/3)];
    leftView.backgroundColor = [UIColor clearColor];
    return leftView;
}

-(UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.backgroundColor = k_COLOR_THEME;
        [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
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
    [self.contentView addSubview:self.re_PasswordTextField];
    
    [self.contentView addSubview:self.registerButton];
    
    [self.baseView handleKeyboard];
    
    [self.view setNeedsUpdateConstraints];
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
    
    [self.re_PasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.passwordTextField);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.equalTo(self.re_PasswordTextField);
        make.top.equalTo(self.re_PasswordTextField.mas_bottom).offset(40);
        make.width.mas_equalTo(100);
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
        case CPRegisterVCTypeNikeName:
            _currentNickName = string;
            break;
        case CPRegisterVCTypePassword:
            _currentPassword = string;
            break;
        case CPRegisterVCTypeRePassword:
            _currentRePassword = string;
            break;
    }
}
- (void)registerAction {
    
    NSLog(@"用户名:%@， 密码:%@，确认密码:%@", _currentNickName, _currentPassword, _currentRePassword);
    BOOL isNull = [_currentNickName isEqualToString:@""];
    if (isNull) {
        [MBProgressHUD showErrorWithMessage:@"Account is NULL"];
        return;
    }
    BOOL isSame = [_currentPassword isEqualToString:_currentRePassword];
    if (!isSame) {
        [MBProgressHUD showErrorWithMessage:@"Password Dissimilar"];
        return;
    }
    
//    // 生成文件路径
    NSString *filePath = [self pathOfDBWithName:DBNAME andExtension:EXTENSION];
//
//    // 根据路径创建数据库
//    [self createDatabaseWithPath:filePath];
    
    CPDBManager *dbManager = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!dbManager) {
        dbManager = [[CPDBManager alloc] init];
    }
    for (CPUserModel *userModel in dbManager.mArray) {
        if ([userModel.nickName isEqualToString:_currentNickName]) {
            [MBProgressHUD showErrorWithMessage:@"Account Not Exist"];
            return;
        }
    }
    
    CPUserModel *userModel = [[CPUserModel alloc] init];
    userModel.nickName = _currentNickName;
    userModel.password = _currentPassword;
    
    [dbManager.mArray addObject:userModel];
    
    [NSKeyedArchiver archiveRootObject:dbManager toFile:filePath];
  
    [MBProgressHUD showSuccessWithMessage:@"Register Success"];
    [self.navigationController popViewControllerAnimated:YES];
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
