//
//  APMoveDevAndGroupView.h
//  appiot
//
//  Created by App-Iot02 on 2022/12/9.
//

#import "APBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL index);

@interface APMoveDevAndGroupView : APBaseView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *baseview;

@property (nonatomic,strong)UITableView *groupTableView;//
@property (nonatomic,strong)NSMutableArray *selectedData;//需要移动的数据
@property (nonatomic,strong)NSMutableArray *groupData;//需要移动的数据
@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)NSIndexPath *lastPath;

@property (nonatomic,strong)APGroupNote *movetoGroupNode;

@property (nonatomic, copy) ClickBlock okBtnClickBlock;
@property (nonatomic, copy) ClickBlock cancelBtnClickBlock;
-(void)setDefaultValue;

@end

NS_ASSUME_NONNULL_END
