//
//  APNewDeviceView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/5.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APNewDeviceView : APBaseView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UIView *baseview;

@property (nonatomic,strong)UITableView *groupTableView;//
@property (nonatomic,strong)UITextField *groupField;
@property (nonatomic,strong)UIImageView * groupExpendIm;
@property (nonatomic,strong)NSMutableArray *groupData;//分组的数据

@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
