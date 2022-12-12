//
//  APPasswordView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/12.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APPasswordView : APBaseView<UITextFieldDelegate>
@property (nonatomic,strong)UIView *baseview;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;
@property (nonatomic,strong)UITextField *nameField;
@property (nonatomic,strong)UITextField *pwField;
@property (nonatomic,strong)UITextField *confirmField;

@end

NS_ASSUME_NONNULL_END
