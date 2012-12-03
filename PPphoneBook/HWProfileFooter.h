//
//  HWProfileFooter.h
//  PPphoneBook
//  目地: 單一連絡人詳細資料頁面的footView結尾
//  Created by pptai on 12/11/6.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPhoneBook.h"
#import <MessageUI/MessageUI.h>

@class PPContactDetailViewController;

@interface HWProfileFooter : UIView <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{

    UIButton      *faceTimeBtn_;
    UIButton      *mailBtn_;
    UIButton      *deleteBtn_;
    
    PPContactDetailViewController* ppContactDetailViewControllerRef_;
}
-(id)initWithFrame:(CGRect)frame;
-(void)wakeDeleteActionSheet;
-(void)viewTransToEdit;
-(void)viewTransToBrowse;

@property (nonatomic,assign) PPContactDetailViewController* ppContactDetailViewControllerRef;

@end
