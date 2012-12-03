//
//  HWCustomCell.h
//  PPphoneBook
//
//  Created by pptai on 12/11/20.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWCustomCell : UITableViewCell <UITextFieldDelegate>
{
    UIView      *grayLineView_;
    UITextField *cellTextField_;
    id delegate_;
}
-(NSNumber*) cellTextFieldLength;
@property (nonatomic,assign) id  delegate;
@property (nonatomic,readonly)UITextField *cellTextField;
@end
