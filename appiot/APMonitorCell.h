//
//  APMonitorCell.h
//  appiot
//
//  Created by App-Iot02 on 2022/11/23.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "APMonitorModel.h"
#import "APGroupNote.h"

NS_ASSUME_NONNULL_BEGIN

@interface APMonitorCell : UITableViewCell
@property (strong, nonatomic) UIImageView *expendImageView;
@property (strong, nonatomic) UIImageView *im;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIButton *selectBtn;
//@property (nonatomic) BOOL haveChild;

//@property (nonatomic, copy) ClickBlock btnClickBlock;


-(void)updateCellWithData:(APGroupNote*)node;
@end

NS_ASSUME_NONNULL_END
