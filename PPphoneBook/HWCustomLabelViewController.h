//
//  HWCustomLabelViewController.h
//  PPphoneBook
//
//  Created by pptai on 12/11/27.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWCustomLabelViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    UITableViewController *customLabelTableViewController_;
    UINavigationController *customLabelNavViewController_;
    UIBarButtonItem *customLabelSaveBtn_;
    UIBarButtonItem *customLabelCancelBtn_;
    id parentDelegate_;
    
}
- (id)initWithStyle:(UITableViewStyle)style;
@property (nonatomic,assign) id parentDelegate;
@end
