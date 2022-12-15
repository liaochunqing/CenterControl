//
//  APConfigureView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/15.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APConfigureView : APBaseView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)NSMutableArray *selectedDevArray;//选中的设备


@property (nonatomic,strong)UITableView *groupTableView;//
@property (nonatomic,strong)UITextField *groupField;//画面比例
@property (nonatomic,strong)UIImageView * groupExpendIm;
@property (nonatomic,strong)NSMutableArray *groupData;//画面比例的数据

@property (nonatomic,strong)UITextField *modelField;//安装方式
@property (nonatomic,strong)UITableView *modelTableView;//
@property (nonatomic,strong)UIImageView * modelExpendIm;
@property (nonatomic,strong)NSMutableArray *modelData;//安装方式的数据

-(void)setDefaultValue:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
