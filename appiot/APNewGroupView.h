//
//  APNewGroupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/8.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APNewGroupView : APBaseView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UIView *baseview;
//@property (nonatomic,strong)UIButton *baseBtn;


@property (nonatomic,strong)UITableView *groupTableView;//
@property (nonatomic,strong)UITextField *groupField;//分组
@property (nonatomic,strong)UIImageView * groupExpendIm;
@property (nonatomic,strong)NSMutableArray *groupData;//分组的数据

@property (nonatomic,strong)UITextField *nameField;

@property (nonatomic,strong)APGroupNote *groupInfo;

@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
