//
//  PPContactDetailViewController.h
//  PPphoneBook
//  Purpose: 管理單一連絡人詳細資訊的view
//  Created by pptai on 12/10/25.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPhoneBook.h"
#import "HWProfileHeader.h"
#import "HWProfileFooter.h"


/*
#import "HWEditPeopleBehavior.h"
#import "HWAddPeopleBehavior.h"
#import "HWReviewPeopleBehavior.h"
*/
@class HWEditPeopleBehavior;
@class HWAddPeopleBehavior;
@class HWReviewPeopleBehavior;

@interface PPContactDetailViewController : UITableViewController <UITextFieldDelegate,UITextViewDelegate,UITextInputTraits>

{
    int mode_;
    int phoneDataKey_;
    int cellSection_;
    int cellRow_;
    
    
    PPPhoneBook *phoneBookRef_;
    
    HWEditPeopleBehavior     *editBehavior_;
    HWAddPeopleBehavior      *addPeopleBehavior_;
    HWReviewPeopleBehavior   *reviewPeopleBehavior_;
    
    UIBarButtonItem * editButton_;
    UIBarButtonItem * cancelButton_;
    UIBarButtonItem * saveButton_;
    UIBarButtonItem * goBackButton_;
    
    HWProfileHeader *HWprofileHeader_;
    HWProfileFooter *HWprofileFooter_;
   
    HWPlayerInfoDataModel *playerInfoDataObj_;

    
}


@property (nonatomic,assign) id root_delegate;
@property (nonatomic,assign) PPPhoneBook *phoneBookRef;

@property (nonatomic,assign) int cellSection;
@property (nonatomic,assign) int cellRow;
@property (nonatomic,assign) int mode;


@property (nonatomic,readonly) UIBarButtonItem *editButton;
@property (nonatomic,readonly) UIBarButtonItem *cancelButton;
@property (nonatomic,readonly) UIBarButtonItem *saveButton;
@property (nonatomic,readonly) UIBarButtonItem *goBackButton;


@property (nonatomic,readonly) HWPlayerInfoDataModel *playerInfoDataObj;

@property (nonatomic,readonly) HWProfileHeader *HWprofileHeader;
@property (nonatomic,readonly) HWProfileFooter *HWprofileFooter;

// Brose mode...
-(void) setContactInBrowseMode;
// Add mode...
-(void) setContactInAddMode;

// 同步資料層與此次顯示資料同步
-(void) syncPPPhoneBookDataToContacterInReviewMode;
-(void) syncPPPhoneBookDataToContacterInEditMode;
// 新增使用者，顯示資料創建
-(void) syncPPPhoneBookDataToContacterInAddMode;


// view 切換
-(void) notifyRootViewRenewContentatSection:(int)section atRow:(int)section;
-(void) notifyGoToRootView;


/*****************
 *Delegate Method
 ****************/
-(void) userDidClickSelectedTitleCell:(UITableViewCell*)cell;
-(void) userDidViewTransToContactView;
-(NSNumber*) hwContactViewWillReturnRowIndex;
-(void) notifyHWcontactViewToAddTableViewCellWithIndexPath:(NSArray*)indexPath;
-(void) notifyHWcontactViewToRenewTableViewCellEdittMode;
-(void) notifyHWcontactViewToDeleteTableViewCellWithIndexPath:(NSArray*)indexPath;
-(NSNumber*) notifyHWcontactViewShouldRemoveNullPhoneValueAndReturnDeleteRowButTheKey:(NSNumber*)key;
-(NSNumber*) notifyHWcontactViewShouldAddCellInChangingWordWithIndexPath:(NSIndexPath*)indexPath;
-(void)textFieldDidTextBeginEdittingAtIndexPath:(NSIndexPath*) indexPath;

///////////////////////////////gmail
-(NSString*) getPhoneTitle;
-(int) phoneEntries;
// addressData
-(void) notifyHWcontactViewShouldUpdateContacterAddressString:(NSString *) address withKey:(NSNumber*)key;
// mailData
-(void) notifyHWcontactViewShouldUpdateContacterMailString:(NSString *) mail withKey:(NSNumber*)key;
// phone data
-(void) notifyHWcontactViewShouldUpdateContacterPhoneData:(HWPhoneData *) phoneData withKey:(NSNumber*)key;






@end
