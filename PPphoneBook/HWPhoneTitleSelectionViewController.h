//
//  HWPhoneTitleSelectionViewController.h
//  PPphoneBook
//
//  Created by pptai on 12/11/27.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWPhoneTitleModel.h"

@interface HWPhoneTitleSelectionViewController:UITableViewController
{
    HWPhoneTitleModel *hwPhoneTitleModel_;
    id parentDelegate_;
    
    NSString *selectedString_;
}
- (id)initWithStyle:(UITableViewStyle)style;
-(void) notifyHWPhoneAddSelectedPhoneTitleString:(NSString*)cellTitleString;
@property (nonatomic,copy)  NSString *selectedString;
@property (nonatomic,assign) id parentDelegate;
@end