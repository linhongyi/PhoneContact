//
//  HWEditPeopleBehavior.h
//  PPphoneBook
//  Purpose: handle edit, save, cancel action in contact view
//  Created by pptai on 12/10/26.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//


#import <Foundation/Foundation.h>


@class PPContactDetailViewController;

@interface HWEditPeopleBehavior : NSObject <UITableViewDataSource>
{
    PPContactDetailViewController *parent_;
}
@property (nonatomic,assign) PPContactDetailViewController* parent;
-(void) cancelBtnClicked;
-(void) saveBtnClicked;
@end
