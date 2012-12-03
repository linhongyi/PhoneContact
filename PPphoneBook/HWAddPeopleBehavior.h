//
//  HWAddPeopleBehavior.h
//  PPphoneBook
//  Purpose: handle cancel, save action in AddPeopleView
//  Created by pptai on 12/10/26.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PPContactDetailViewController;
@interface HWAddPeopleBehavior: NSObject <UITableViewDataSource>
{
    PPContactDetailViewController* parent_;
}
@property (nonatomic,assign) PPContactDetailViewController* parent;
-(void) saveBtnClicked;
@end
