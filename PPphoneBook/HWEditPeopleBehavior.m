//
//  HWEditPeopleBehavior.m
//  PPphoneBook
//
//  Created by pptai on 12/10/26.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWEditPeopleBehavior.h"
#import "PPContactDetailViewController.h"
#import "HWPlayerInfoDataModel.h"
#import "CommonVar.h"
#import "HWCustomCell.h"

@implementation HWEditPeopleBehavior
@synthesize parent = parent_;

-(id)init
{
    self = [super init];
    
    if(self)
    {
    }
    return self;
}


-(void) cancelBtnClicked
{
 
    parent_.mode = REVIEW_MODE;
    // reload data.
    [parent_.tableView reloadData];
    

    //set head
    [parent_.HWprofileHeader loadImageFromAsserURL:[parent_.phoneBookRef peopleAtSection:parent_.cellSection atRow:parent_.cellRow].imgURL];

  
    // modify table foot
    [parent_.HWprofileFooter viewTransToBrowse];
    
    // add save button
    parent_.navigationItem.rightBarButtonItem = parent_.editButton;
    
    // add cancel button
    parent_.navigationItem.leftBarButtonItem = parent_.goBackButton;
    
    
    parent_.HWprofileHeader.imageView.userInteractionEnabled = NO;
   
    //set table header
    [parent_ syncPPPhoneBookDataToContacterInReviewMode];
    [parent_.HWprofileHeader showBrowseContact];
 
    [parent_.tableView setEditing:NO];
    
    // reload data.
    [parent_.tableView reloadData];
}

-(void) saveBtnClicked
{
    if ( [parent_ isKindOfClass: [PPContactDetailViewController class] ] != TRUE )
        return;
    
    parent_.mode = REVIEW_MODE;
    
    HWPlayerInfoDataModel* newPeopleData = [[HWPlayerInfoDataModel alloc]init];
    
    // head
    newPeopleData.nameString   = parent_.HWprofileHeader.nameTextField.text;
    newPeopleData.imgURL = parent_.HWprofileHeader.imgURL;
    
    // address
    newPeopleData.addressString = parent_.playerInfoDataObj.addressString;
    
    // mail
    newPeopleData.emailString   = parent_.playerInfoDataObj.emailString;
    
    // phone
    [parent_.playerInfoDataObj removeAllEmptyPhoneValueData];
    NSMutableArray *phoneDataArray = [parent_.playerInfoDataObj copyPhoneData];
    int totalPhoneNumber = [phoneDataArray count];
    
    for( int phoneIdx = 0 ; phoneIdx < totalPhoneNumber ; phoneIdx++)
    {
        [newPeopleData addPhoneData: [phoneDataArray objectAtIndex:phoneIdx]];
    }
    [phoneDataArray release];
    
    //更新成功
    if ( [parent_.phoneBookRef modifyPlayerData: newPeopleData atSection:parent_.cellSection atRow:parent_.cellRow] == TRUE )
    {
        
        if ( [ parent_.HWprofileHeader.nameLabel.text isEqualToString: parent_.HWprofileHeader.nameTextField.text ] == FALSE )
        {
            parent_.HWprofileHeader.nameLabel.text = parent_.HWprofileHeader.nameTextField.text;
            
            //姓名變動，連絡人清單更新。
            [parent_ notifyRootViewRenewContentatSection:parent_.cellSection atRow:parent_.cellRow];
        }
        
        // 個人顯示資料更新
        //[parent_.tableView reloadData];
        
    }
  
    [newPeopleData release];
    // modify table foot
    [parent_.HWprofileFooter viewTransToBrowse];
    
    // add edit button
    parent_.navigationItem.rightBarButtonItem = parent_.editButton ;
    parent_.navigationItem.leftBarButtonItem  = parent_.goBackButton;
    
    //set table header
    [parent_.HWprofileHeader showBrowseContact];
    
    [parent_.tableView setEditing:NO];
    
    // reload data.
    [parent_.tableView reloadData];
   

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"editCell";
    HWCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HWCustomCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.delegate = parent_;
        
    }
        
    // Configure the cell...
    
    if( indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if ( [parent_ isKindOfClass: [PPContactDetailViewController class] ]== TRUE )
        {
            // 拿cell的標題
            cell.textLabel.text = [parent_.playerInfoDataObj phoneDataAtIdx:indexPath.row].titleNSString;
            
            
            //拿相對應此標題的值
            cell.cellTextField.text = [parent_.playerInfoDataObj phoneDataAtIdx:indexPath.row].phoneNumberValueNSString;
            
            cell.cellTextField.placeholder =  cell.textLabel.text;
            
            cell.cellTextField.tag = indexPath.section;
            cell.tag = [parent_.playerInfoDataObj phoneDataAtIdx:indexPath.row].numKey;
            
           //NSLog(@"cellForRowAtIndexPath memorySpace:%p, tag:%d, title:%@ text:%@",cell ,cell.tag,cell.textLabel.text, cell.cellTextField.text);
        }
        
        cell.cellTextField.keyboardType =  UIKeyboardTypePhonePad;
        cell.cellTextField.userInteractionEnabled = YES;
    }
    else if( indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ( [parent_ isKindOfClass: [PPContactDetailViewController class] ]== TRUE )
        {
            cell.cellTextField.text = parent_.playerInfoDataObj.emailString;
        }
        
        cell.textLabel.text = @"信箱";
        cell.cellTextField.placeholder = @"信箱";
        cell.cellTextField.tag = indexPath.section;
        cell.cellTextField.userInteractionEnabled = YES;
        cell.tag = 0;
        
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ( [parent_ isKindOfClass: [PPContactDetailViewController class] ]== TRUE )
        {
            cell.cellTextField.text = parent_.playerInfoDataObj.addressString;
        }
        
        cell.textLabel.text = @"地址";
        cell.cellTextField.placeholder = @"地址";
        cell.cellTextField.tag = indexPath.section;
        cell.cellTextField.userInteractionEnabled = YES;
        cell.tag = 0;
        
    }
    return cell;
}


@end
