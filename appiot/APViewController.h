//
//  APViewController.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/14.
//

#import "APBaseViewController.h"
#import "APLeftView.h"
#import "APCenterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APViewController : APBaseViewController<UITextFieldDelegate>
@property(nonatomic,strong)APLeftView *leftView;
@property(nonatomic,strong)APCenterView *centerView;

@property(nonatomic,strong)UIView *loginView;

@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *pwField;

@end

NS_ASSUME_NONNULL_END
