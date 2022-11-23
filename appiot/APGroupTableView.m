//
//  APGroupTableView.m
//  appiot
//
//  Created by App-Iot02 on 2022/11/17.
//

#import "APGroupTableView.h"
#import "AppDelegate.h"
@implementation APGroupTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        //        self.dataSource = self;
        //        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)deleteSelectedNode
{
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];//临时容器，存储将要删除的节点
    
    //收集删除节点
    for (int i = 0; i < _data.count; i++)
    {
        APGroupNote *first = _data[i];
        if (first.selected)//第一层
        {
            if(first.expand == YES)
            {
                for (int k = 0; k < _data.count; k++)
                {
                    APGroupNote *second = _data[k];
                    if (second.parentId == first.nodeId)//第二层
                    {
                        for (int j = 0; j < _data.count; j++)
                        {
                            APGroupNote *third = _data[j];
                            if (third.parentId == second.nodeId)//第三层
                            {
                                [set addIndex:j];

                            }
                        }
                        [set addIndex:k];

                    }
                }
            }
            
            [set addIndex:i];
        }
    }

    
    //删除节点刷新列表
    if (set.count > 0)
    {
        WS(weakSelf);
        UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            
            [weakSelf.data removeObjectsAtIndexes:set];
            [weakSelf reloadData];
        }];
                
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];

        [alert addAction:action1];
        [alert addAction:action2];
        AppDelegate *appDelegate = kAppDelegate;
    //    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController *vc = appDelegate.mainVC;
        [vc presentViewController:alert animated:YES completion:nil];  //显示对话框
    }
}

@end
