//
//  HWAddPeopleBehavior.m
//  PPphoneBook
//
//  Created by pptai on 12/10/26.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWAddPeopleBehavior.h"
#import "PPContactDetailViewController.h"
#import "CommonVar.h"
#import "HWCustomCell.h"

@implementation HWAddPeopleBehavior
@synthesize parent = parent_;

-(id)init
{
    self = [super init];
    
    if( self )
    {
        
    }
    
    return self;
}



-(void)saveBtnClicked
{
    
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
    
    [parent_.phoneBookRef addPlayerDataInfo: newPeopleData];
    NSArray *arridx = [parent_.phoneBookRef lookUpThePlayerIndex: newPeopleData];
    [newPeopleData release];
    
    
    NSNumber *row = [arridx objectAtIndex:1];
    parent_.cellRow = [row intValue];
    
    NSNumber *section = [arridx objectAtIndex:0];
    
    parent_.cellSection = [section intValue];
    parent_.mode = REVIEW_MODE;
    
    [parent_ syncPPPhoneBookDataToContacterInReviewMode];
    [parent_ setContactInBrowseMode];
    [parent_ notifyRootViewRenewContentatSection:parent_.cellSection atRow:parent_.cellRow];
    
    [parent_.tableView setEditing: NO];
    // reload data.
    [parent_.tableView reloadData];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //PPContactDetailViewController *ptr;
    
    static NSString *CellIdentifier = @"AddCell";
    HWCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell = [[HWCustomCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
        cell.delegate = parent_;
    
    }
    
    // Configure the cell...
     
    
    if( indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        //NSLog(@"title %@",[parent_.playerInfoData phoneDataAtIdx:indexPath.row].titleNSString_);
        
        // 拿cell的標題
        cell.textLabel.text = [parent_.playerInfoDataObj phoneDataAtIdx:indexPath.row].titleNSString;
        
        //拿相對應此標題的值
        cell.cellTextField.text = [parent_.playerInfoDataObj phoneDataAtIdx:indexPath.row].phoneNumberValueNSString;
 
        cell.cellTextField.tag = indexPath.row;
               
        cell.cellTextField.keyboardType =  UIKeyboardTypePhonePad;
        cell.cellTextField.placeholder = cell.textLabel.text;
        cell.cellTextField.userInteractionEnabled = YES;
        
        cell.tag = [parent_.playerInfoDataObj phoneDataAtIdx:indexPath.row].numKey;
    }
    else if( indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"信箱";
        cell.tag = 0;
        
        cell.cellTextField.keyboardType =  UIKeyboardTypeEmailAddress;
        cell.cellTextField.placeholder = @"信箱";
        //拿相對應此標題的值
        cell.cellTextField.text = @"";
        cell.cellTextField.tag = indexPath.section;
        cell.cellTextField.userInteractionEnabled = YES;
        
       
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"地址";
        cell.tag = 0;
        
        cell.cellTextField.keyboardType =  UIKeyboardTypeDefault;
        cell.cellTextField.placeholder = @"地址";
        //拿相對應此標題的值
        cell.cellTextField.text = @"";
        cell.cellTextField.tag = indexPath.section;
        cell.cellTextField.userInteractionEnabled = YES;
    }
    return cell;
}


@end
