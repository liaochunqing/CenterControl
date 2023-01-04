//
//  APRenameGroupView.h
//  appiot
//
//  Created by App-Iot02 on 2023/1/4.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APRenameGroupView :  APBaseView<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *nameField;

@property (nonatomic,strong)APGroupNote *groupInfo;

@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;
@property (nonatomic,strong)APGroupNote *deviceInfo;

-(void)setDefaultValue:(id)node;
@end

NS_ASSUME_NONNULL_END
