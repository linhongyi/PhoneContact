//
//  ReviewPeopleBehavior.m
//  PPphoneBook
//
//  Created by pptai on 12/11/20.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWReviewPeopleBehavior.h"
#import "PPContactDetailViewController.h"
#import "CommonVar.h"
#import "HWCustomCell.h"

@implementation HWReviewPeopleBehavior

@synthesize parent = parent_;

-(id)init
{
    self = [super init];
    
    if( self )
    {

    }
    
    return self;
}

-(void)editBtnClicked
{
    parent_.mode = EDIT_MODE;
    
    
    // add save button
    parent_.navigationItem.rightBarButtonItem = parent_.saveButton ;
    // add cancel button
    parent_.navigationItem.leftBarButtonItem  = parent_.cancelButton;
    
    // modify table foot
    [parent_.HWprofileFooter viewTransToEdit];
    
    parent_.HWprofileHeader.imageView.userInteractionEnabled = YES;
    
    [parent_.playerInfoDataObj removeAllEmptyPhoneValueData];
   
    // set table header
    [parent_ syncPPPhoneBookDataToContacterInEditMode];
    
    [parent_.HWprofileHeader showEditContact];
    
    [parent_.tableView setEditing:YES];
    parent_.tableView.allowsSelectionDuringEditing = YES;
    [parent_.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //PPContactDetailViewController *parent_;
    
    static NSString *CellIdentifier = @"reviewCell";
    HWCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell = [[HWCustomCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
        cell.delegate = parent_;
        
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.tag = indexPath.row;
    
    
    if( indexPath.section == 0)
    {
     
        //NSLog(@"title %@",[parent_.playerInfoData phoneDataAtIdx:indexPath.row].titleNSString_);
            
        // 拿cell的標題
        cell.textLabel.text = [self.parent.playerInfoDataObj phoneDataAtIdx:indexPath.row].titleNSString;
            
        //拿相對應此標題的值
        cell.cellTextField.text = [self.parent.playerInfoDataObj phoneDataAtIdx:indexPath.row].phoneNumberValueNSString;
        
        cell.cellTextField.tag = indexPath.row;
        
        cell.tag = [self.parent.playerInfoDataObj phoneDataAtIdx:indexPath.row].numKey;
        
        cell.cellTextField.keyboardType =  UIKeyboardTypePhonePad;
        cell.cellTextField.userInteractionEnabled = NO;
    }
    else if( indexPath.section == 1)
    {
        
        cell.cellTextField.text = self.parent.playerInfoDataObj.emailString;
        
        cell.textLabel.text = @"信箱";
        cell.cellTextField.tag = indexPath.section;
        cell.cellTextField.userInteractionEnabled = NO;
    }
    else{
        
        cell.cellTextField.text = self.parent.playerInfoDataObj.addressString;
        
        cell.textLabel.text = @"地址";
        cell.cellTextField.tag = indexPath.section;
        cell.cellTextField.userInteractionEnabled = NO;
        
        
    }
    return cell;
}
@end
