//
//  APAPEditDeviceView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/5.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APAPEditDeviceView : APBaseView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UIView *baseview;
@property (nonatomic,strong)UIButton *baseBtn;


@property (nonatomic,strong)UITableView *groupTableView;//
@property (nonatomic,strong)UITextField *groupField;//分组
@property (nonatomic,strong)UIImageView * groupExpendIm;
@property (nonatomic,strong)NSMutableArray *groupData;//分组的数据

@property (nonatomic,strong)UITextField *nameField;
@property (nonatomic,strong)UITextField *idField;
@property (nonatomic,strong)UITextField *ipField;
@property (nonatomic,strong)UITextField *portField;


@property (nonatomic,strong)UITextField *modelField;//机型
@property (nonatomic,strong)UITableView *modelTableView;//
@property (nonatomic,strong)UIImageView * modelExpendIm;
@property (nonatomic,strong)NSMutableArray *modelData;//机型的数据

@property (nonatomic,strong)UITextField *protocolField;//接入协议  tcp udp mqtt
@property (nonatomic,strong)UITableView *protocolTableView;//
@property (nonatomic,strong)UIImageView * protocolExpendIm;
@property (nonatomic,strong)NSMutableArray *protocolData;//接入协议的数据

@property (nonatomic,strong)APGroupNote *deviceInfo;

@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;

-(void)setDefaultValue;
@end

NS_ASSUME_NONNULL_END
