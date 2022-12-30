//
//  APRenameView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/30.
//

#import "APBaseView.h"

typedef void(^ClickBlock)(BOOL index);

NS_ASSUME_NONNULL_BEGIN

@interface APRenameView : APBaseView<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *nameField;

@property (nonatomic,strong)APGroupNote *groupInfo;

@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;
@property (nonatomic,strong)APGroupNote *deviceInfo;

-(void)setDefaultValue:(id)node;
@end

NS_ASSUME_NONNULL_END
