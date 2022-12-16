//
//  APChooseItem.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/16.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APChooseItem : APBaseView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

//@property (nonatomic,strong)NSMutableArray *selectedArray;//选中的设备

@property(nonatomic,strong)UILabel* label;
@property (nonatomic,strong)UITableView *tableView;//
@property (nonatomic,strong)UITextField *field;//
@property (nonatomic,strong)UIImageView * expendIm;
@property (nonatomic,strong)NSMutableArray *dataArray;//

-(void)setDefaultValue:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
