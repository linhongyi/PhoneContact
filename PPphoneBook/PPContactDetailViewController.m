//
//  PPContactDetailViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/10/25.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PPContactDetailViewController.h"
#import "PPPlayerInfoTableListViewController.h"
#import "CommonVar.h"
#import "HWPhoneData.h"
#import "HWCustomCell.h"
#import "HWPhoneTitleSelectionViewController.h"
#import "HWEditPeopleBehavior.h"
#import "HWAddPeopleBehavior.h"
#import "HWReviewPeopleBehavior.h"

@interface PPContactDetailViewController ()
{
    NSIndexPath *selecteCellIndexPath_;
}
@end

@implementation PPContactDetailViewController


@synthesize root_delegate;
@synthesize cancelButton = cancelButton_;
@synthesize saveButton   = saveButton_;
@synthesize editButton   = editButton_;
@synthesize goBackButton = goBackButton_;

@synthesize HWprofileHeader = HWprofileHeader_;
@synthesize HWprofileFooter = HWprofileFooter_;

@synthesize mode         = mode_;
@synthesize playerInfoDataObj = playerInfoDataObj_;

@synthesize cellRow     = cellRow_;
@synthesize cellSection = cellSection_;
@synthesize phoneBookRef =  phoneBookRef_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
        reviewPeopleBehavior_ = [[HWReviewPeopleBehavior alloc]init];
        reviewPeopleBehavior_.parent = self;

        editBehavior_ = [[HWEditPeopleBehavior alloc]init];
        editBehavior_.parent = self;
        
        addPeopleBehavior_ = [[HWAddPeopleBehavior alloc]init];
        addPeopleBehavior_.parent = self;
        
                
        // create save button
        saveButton_ =[UIBarButtonItem alloc];
        saveButton_.title =  NSLocalizedString(@"完成", nil);
        saveButton_.style = UIBarButtonSystemItemSave;
        
        // create edit button
        editButton_ = [UIBarButtonItem alloc];
        editButton_.title =  NSLocalizedString(@"編輯", nil);
        editButton_.style = UIBarButtonSystemItemEdit;
        
        
        // create cancel button
        cancelButton_ = [UIBarButtonItem alloc];
        cancelButton_.title =  NSLocalizedString(@"取消", nil);
        cancelButton_.style = UIBarButtonSystemItemCancel;
        
        // assing goback Button
        goBackButton_ = self.navigationItem.leftBarButtonItem;
        
        // create headr;
        HWprofileHeader_ = [[HWProfileHeader alloc] initWithFrame:CGRectMake(0,0,320,100)];
        HWprofileHeader_.ppContactDetailViewControllerRef = self;
        
        // create footer
        HWprofileFooter_ = [[HWProfileFooter alloc] initWithFrame:CGRectMake(0,0,320,50)];
        HWprofileFooter_.ppContactDetailViewControllerRef = self;
        
        // add button click action in headimage
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadFun)];
        [HWprofileHeader_.imageView addGestureRecognizer:singleTap];
        [singleTap autorelease];
        
        selecteCellIndexPath_ = [[NSIndexPath alloc]init];
      
    }
    return self;
}



HWPlayerInfoDataModel *playerInfoDataObj_;

-(void) dealloc
{
    [selecteCellIndexPath_ release];
    
    [editBehavior_ release];
    [addPeopleBehavior_ release];
    [reviewPeopleBehavior_ release];
    
    [editButton_ release];
    [cancelButton_ release];
    [saveButton_ release];
    //[goBackButton_ release];
    
    [HWprofileHeader_ release];
    [HWprofileFooter_ release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setContactInBrowseMode
{
    //set show name
    [HWprofileHeader_ showBrowseContact];
    
    
    HWprofileHeader_.nameLabel.text =  [phoneBookRef_ peopleAtSection: self.cellSection atRow: self.cellRow].nameString;
    HWprofileHeader_.nameTextField.text = [phoneBookRef_ peopleAtSection: self.cellSection atRow: self.cellRow].nameString;
    
    // set imageHead
    HWprofileHeader_.imgURL = [phoneBookRef_ peopleAtSection: self.cellSection atRow: self.cellRow].imgURL;
    [HWprofileHeader_ loadImageFromAsserURL:  HWprofileHeader_.imgURL];
    [HWprofileHeader_.imageLabel removeFromSuperview];
    
    //set button target and action
    editButton_.target = reviewPeopleBehavior_;
    editButton_.action = @selector( editBtnClicked ) ;
    self.saveButton.target = editBehavior_;
    self.saveButton.action = @selector( saveBtnClicked ) ;
    cancelButton_.target = editBehavior_;
    cancelButton_.action = @selector( cancelBtnClicked ) ;
    
    editButton_.enabled = TRUE;
    saveButton_.enabled = TRUE;
    cancelButton_.enabled = TRUE;
    
    self.navigationItem.rightBarButtonItem = editButton_;
    
    // set tableHeaderView and tableFooterVier
	self.tableView.tableHeaderView = HWprofileHeader_;
    self.tableView.tableFooterView = HWprofileFooter_;
    
    [HWprofileFooter_ viewTransToBrowse];
    self.HWprofileHeader.imageView.userInteractionEnabled = NO;
}

-(void) setContactInAddMode
{
    mode_ = ADD_MODE;
   
    [HWprofileHeader_ showAddPeopleContact];
	
    self.tableView.tableHeaderView = HWprofileHeader_;
    self.tableView.tableFooterView = nil;
    [self.tableView setEditing:YES];
    
    saveButton_.target = addPeopleBehavior_;
    saveButton_.action = @selector(saveBtnClicked);
    self.navigationItem.rightBarButtonItem = saveButton_;
    
    self.HWprofileHeader.imageView.userInteractionEnabled = YES;
}


-(void) syncPPPhoneBookDataToContacterInReviewMode
{
    if( phoneBookRef_ != nil &&  [ phoneBookRef_ entries] > 0)
    {
        HWPlayerInfoDataModel *exitPeople = [phoneBookRef_ peopleAtSection: self.cellSection atRow: self.cellRow];
        
        if( playerInfoDataObj_ != Nil )
        {
            [playerInfoDataObj_ release];
        }
        
        playerInfoDataObj_ = [exitPeople copyHWPlayerInfoDataModel];
        
        
        if( [playerInfoDataObj_ phoneNumberEntries] <= 0)
        {
            HWPhoneData *newPhoneData;
            newPhoneData = [[HWPhoneData alloc]init];
            newPhoneData.phoneNumberValueNSString = @"";
            newPhoneData.titleNSString  = CELLPHONE_NSSTRING;
            newPhoneData.numKey         = [playerInfoDataObj_ phoneNumberEntries];
            [playerInfoDataObj_ addPhoneData:newPhoneData];
            [newPhoneData release];
        }
        
        //[playerInfoDataObj_ traceAllPhoneData];
        
        phoneDataKey_ = [self phoneEntries];
    }
    // 電話簿沒資料
    else
    {
      [playerInfoDataObj_ release];
       playerInfoDataObj_ = [[ HWPlayerInfoDataModel alloc]init];
    }
}

-(void)syncPPPhoneBookDataToContacterInEditMode
{
       
    if( phoneBookRef_ != nil )
    {
        if( playerInfoDataObj_ != Nil )
        {
            [playerInfoDataObj_ release];
        }

        HWPlayerInfoDataModel *exitPeople = [phoneBookRef_ peopleAtSection: self.cellSection atRow: self.cellRow];
        
        playerInfoDataObj_ = [exitPeople copyHWPlayerInfoDataModel];
        
        phoneDataKey_ = [self phoneEntries];

        // 最多十筆電話
        if( phoneDataKey_ < 10)
        {
            HWPhoneData *newPhoneData = [[HWPhoneData alloc]init];
            newPhoneData.titleNSString = [self getPhoneTitle];
            newPhoneData.phoneNumberValueNSString = @"";
            newPhoneData.numKey         = phoneDataKey_++;
            
            [playerInfoDataObj_ addPhoneData:newPhoneData];
            [newPhoneData release];
        }
      
    }
    // 電話簿沒資料
    else
    {
        [playerInfoDataObj_ release];
        playerInfoDataObj_ = [[ HWPlayerInfoDataModel alloc]init];
    }
}

//增加使用者，新增預設電話資料
-(void)syncPPPhoneBookDataToContacterInAddMode
{
    phoneDataKey_ = 0;
    
    if( playerInfoDataObj_ != nil)
        [playerInfoDataObj_ release];
    
    playerInfoDataObj_ = [[ HWPlayerInfoDataModel alloc]init];
    
    HWPhoneData *newPhoneData = [[HWPhoneData alloc]init];
    newPhoneData.titleNSString = CELLPHONE_NSSTRING;
    newPhoneData.phoneNumberValueNSString = @"";
    newPhoneData.numKey         = phoneDataKey_++;
    
    [playerInfoDataObj_ addPhoneData:newPhoneData];
    [newPhoneData release];

}

-(void) changeHeadFun
{
    if( self.HWprofileHeader.imgURL == nil)
    {
        [HWprofileHeader_ showImagePickControllerView ];
    }
    else
    {
        [HWprofileHeader_ wakeImgSettingActionSheet];

    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.sjoujous
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if( section == PHONE_SECTION)
    {
        return [playerInfoDataObj_ phoneNumberEntries];
    }
    else if( section == MAIL_SECTION )
    {
        return 1;
    }
    else if( section == ADDRESS_SECTION)
    {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if( mode_ == ADD_MODE )
    {
        cell =[addPeopleBehavior_ tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if ( mode_ == EDIT_MODE)
    {
        cell =[editBehavior_ tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        cell =[reviewPeopleBehavior_ tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - uitableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if( indexPath.section == 0)
    {
        int totalRow = [self phoneEntries];
        int iTotalRowIdx = totalRow-1;
        

        if( indexPath.row < iTotalRowIdx)
        {
            return UITableViewCellEditingStyleDelete;
        }
        else 
        {
                  
            HWPhoneData *exitPhoneData = [self.playerInfoDataObj  phoneDataAtIdx: indexPath.row];
            
            if( exitPhoneData.phoneNumberValueNSString.length > 0)
            {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    // mail
    else if( indexPath.section == 1)
    {
        return UITableViewCellEditingStyleNone;
    }
    // address
    else if( indexPath.section == 2)
    {
        return UITableViewCellEditingStyleNone;
    }
    return   UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      if (editingStyle == UITableViewCellEditingStyleDelete)
      {
          if( indexPath.section == 0)
          {
              // Delete the row from the data source
              [playerInfoDataObj_ deletePhoneDataAtIdx:indexPath.row];
              
             
              NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                           [NSIndexPath indexPathForRow: indexPath.row inSection: indexPath.section],
                                           nil];
              
              [self notifyHWcontactViewToDeleteTableViewCellWithIndexPath:deleteIndexPaths];
          }
          
    
      }
      else if (editingStyle == UITableViewCellEditingStyleInsert)
      {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }
    
}




#pragma mark - textField 


//click return key
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void) notifyRootViewRenewContentatSection:(int) section atRow:(int) row;
{
    PPPlayerInfoTableListViewController *ptr = root_delegate;
    
    [ptr renewTableContentatSection:section atRow:row];
}

-(void) notifyGoToRootView
{
    PPPlayerInfoTableListViewController *ptr = root_delegate;
    
    [ptr transViewToPlayerList];

}

-(void) userDidViewTransToContactView
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


//改變title
-(void) userDidClickSelectedTitleCell:(UITableViewCell*)cell;
{
    UITableViewCell *changeCell = [self.tableView cellForRowAtIndexPath:selecteCellIndexPath_];
    int targetIdx = [playerInfoDataObj_ phoneDataIdxWithKey:changeCell.tag];
   
    changeCell.textLabel.text = cell.textLabel.text;
    HWPhoneData *phoneData = [playerInfoDataObj_ phoneDataAtIdx: targetIdx];
    phoneData.titleNSString = changeCell.textLabel.text;
}




-(NSString*) getPhoneTitle
{
    int totalNum = [playerInfoDataObj_ phoneNumberEntries];
    
    bool bUseCellPhone = false;
    bool bUseHomePhone = false;
    bool bUseCompanyPhone = false;
    
    NSString *cmpStr;
   
    for( int idx = 0 ; idx < totalNum ; idx++ )
    {
        cmpStr = [NSString stringWithString:[playerInfoDataObj_ phoneDataAtIdx:idx].titleNSString];
        
        if( bUseCellPhone == TRUE && bUseHomePhone == TRUE && bUseCompanyPhone == TRUE)
        {
            break;
        }
        else if( bUseCellPhone == false && [cmpStr isEqualToString:CELLPHONE_NSSTRING])
        {
            bUseCellPhone = TRUE;
        }
        else if( bUseHomePhone == false && [cmpStr isEqualToString:HOME_PHONE_NSSTRING])
        {
            bUseHomePhone = TRUE;
        }
        else if( bUseCompanyPhone == false && [cmpStr isEqualToString:COMPANY_PHONE_NSSTRING])
        {
            bUseCompanyPhone = TRUE;
        }
    }
    
    if( bUseCellPhone == false)
        return CELLPHONE_NSSTRING;
    else if( bUseHomePhone == false)
        return HOME_PHONE_NSSTRING;
    else if( bUseCompanyPhone == false)
        return COMPANY_PHONE_NSSTRING;
    else
        return OTHER_PHONE_NSSTRING;
}

-(int)phoneEntries
{
    return [playerInfoDataObj_ phoneNumberEntries];
}


-(void)textFieldDidTextBeginEdittingAtIndexPath:(NSIndexPath*) indexPath
{
    //
   
    
    //UITableViewCell *changeCell = [self.tableView cellForRowAtIndexPath:selecteCellIndexPath_];
    //int targetIdx = [playerInfoDataObj_ phoneDataIdxWithKey:changeCell.tag];
    
    //changeCell.textLabel.text = cell.textLabel.text;
    //HWPhoneData *phoneData = [playerInfoDataObj_ phoneDataAtIdx: targetIdx];
    //phoneData.titleNSString = changeCell.textLabel.text;
    
    //非電話欄位
    if( indexPath.section != 0)
    {
         NSLog(@"indexPath.section: %d, indexPath.row: %d", indexPath.section, indexPath.row);
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        // indexPaht.row as key
       
        int mappingRow = [self.playerInfoDataObj phoneDataIdxWithKey:indexPath.row];
        
        [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:mappingRow inSection: indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(NSNumber*) notifyHWcontactViewShouldAddCellInChangingWordWithIndexPath:(NSIndexPath*)indexPath;
{
    int totalRow = [self phoneEntries];
    int currentRowIdx = [self.playerInfoDataObj phoneDataIdxWithKey:indexPath.row];
    int totalRowIdx   = totalRow -1;
   
   
    
    //最多十筆
    if( totalRow >= 10)
    {
        return [NSNumber numberWithBool:FALSE];
    }
    else if( currentRowIdx >= totalRowIdx)
    {
        return [NSNumber numberWithBool:TRUE];
    }
    else
    {
        return [NSNumber numberWithBool:FALSE];
    }
   
}

-(void) notifyHWcontactViewShouldUpdateContacterPhoneData:(HWPhoneData *) phoneData withKey:(NSNumber*)key
{
    
    [playerInfoDataObj_ updatePhoneData:phoneData withKey: [key intValue]];
}

-(void) notifyHWcontactViewShouldUpdateContacterAddressString:(NSString *) address withKey:(NSNumber*)key;
{
    playerInfoDataObj_.addressString = address;
}

-(void) notifyHWcontactViewShouldUpdateContacterMailString:(NSString *) mail withKey:(NSNumber*)key;
{
    playerInfoDataObj_.emailString = mail;
}

-(NSNumber*)hwContactViewWillReturnRowIndex
{
    NSString *newTitle = [self getPhoneTitle];
    
    HWPhoneData *newPhoneData = [[HWPhoneData alloc]init];
    newPhoneData.titleNSString = newTitle;
    newPhoneData.phoneNumberValueNSString = @"";
    newPhoneData.numKey         = phoneDataKey_++;
    [playerInfoDataObj_ addPhoneData:newPhoneData];
    [newPhoneData release];
    
    int rowIndx = [self phoneEntries];
    
    return [[[NSNumber alloc] initWithInt: rowIndx ]autorelease];
}

-(void) notifyHWcontactViewToAddTableViewCellWithIndexPath:(NSArray*)indexPath;
{
    UITableView *tv = (UITableView *)self.view;
    [tv beginUpdates];
    [tv insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationRight];
    [tv endUpdates];
}

-(NSNumber*) notifyHWcontactViewShouldRemoveNullPhoneValueAndReturnDeleteRowButTheKey:(NSNumber*)key
{
    int targetDeleteIdx = [playerInfoDataObj_ findNullPhoneValueDataAtIdxExclusiveKey:[key intValue]];
    
    if( targetDeleteIdx >=0 )
        [playerInfoDataObj_ deletePhoneDataAtIdx:targetDeleteIdx];
    
    return [[[NSNumber alloc]initWithInt:targetDeleteIdx]autorelease];

}


-(void) notifyHWcontactViewToDeleteTableViewCellWithIndexPath:(NSArray *)indexPath
{
    UITableView *tv = (UITableView *)self.view;
    [tv beginUpdates];
    [tv deleteRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationFade];
    [tv endUpdates];
}

-(void )notifyHWcontactViewToRenewTableViewCellEdittMode
{
    self.tableView.editing = NO;
    self.tableView.editing = YES;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    if( mode_ == REVIEW_MODE)
        return;
    
    
    //phone
    if( indexPath.section == 0)
    {
        
        //implement @property setter retain
        if( selecteCellIndexPath_ != indexPath)
        {
           [selecteCellIndexPath_ release];
            selecteCellIndexPath_ = [indexPath retain];
            
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        HWPhoneTitleSelectionViewController *hWPhoneTitleSelectionViewController = [[[HWPhoneTitleSelectionViewController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
        hWPhoneTitleSelectionViewController.parentDelegate = self;
        hWPhoneTitleSelectionViewController.selectedString = cell.textLabel.text;
        
        [self.navigationController pushViewController:hWPhoneTitleSelectionViewController animated:YES];
        //[self presentViewController:hWPhoneTitleSelectionTableViewController animated:YES completion:Nil];
    }
}

/*
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSLog(@"height:%f",self.tableView.tableFooterView.bounds.size.height);
    if( section == 2)
       return 50.f;
    else
        return 10.0f;
}*/
@end
