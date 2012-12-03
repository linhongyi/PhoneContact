//
//  ReviewPeopleBehavior.h
//  PPphoneBook
//
//  Created by pptai on 12/11/20.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PPContactDetailViewController.h"

@class PPContactDetailViewController;

@interface HWReviewPeopleBehavior : NSObject <UITableViewDataSource>
{
    PPContactDetailViewController* parent_;
}
@property (nonatomic,assign) PPContactDetailViewController* parent;
-(void) editBtnClicked;
@end
