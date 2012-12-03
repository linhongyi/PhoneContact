//
//  PPPlayerInfoTableListViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PPPlayerInfoTableListViewController.h"
#include "PPContactDetailViewController.h"
#include "CommonVar.h"



@implementation PPPlayerInfoTableListViewController
@synthesize phoneBook = phoneBook_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        searchBar_ = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f) ];
        searchBar_.autocorrectionType = UITextAutocorrectionTypeNo;
        searchBar_.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchBar_.keyboardType = UIKeyboardTypeAlphabet;
        searchBar_.delegate = self;
        self.tableView.tableHeaderView = searchBar_;
        
        searchDisplayController_ = [[UISearchDisplayController alloc] initWithSearchBar:searchBar_ contentsController: self];
        searchDisplayController_.searchResultsDataSource = self;
        searchDisplayController_.searchResultsDelegate = self;
        searchDisplayController_.delegate = self;
        
        searchHastTableMutableArray_ = [[NSMutableArray alloc]init];
        
               
        bRenew_ = false;
    }
    return self;
}

- (void)dealloc
{
    [searchDisplayController_ release];
    [searchHastTableMutableArray_ release];
    [searchBar_ release];
    //[contactDetailViewController_ release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    UIBarButtonItem *addPeopleButton =
    [[[UIBarButtonItem alloc]
     initWithTitle:
     NSLocalizedString(@"新增", nil)
     style:UIBarButtonItemStylePlain
     
     target:self
     action:@selector( transToAddPeopleView ) ]autorelease];
      self.navigationItem.rightBarButtonItem = addPeopleButton;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    if( tableView == self.tableView)
    {
        //NSLog(@"how many rows:%d",[phoneBook_ numberKeyInKeyBook] );
        return [phoneBook_ numberKeyInKeyBook];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.

    if( tableView == self.tableView)
        return [phoneBook_ numberentriesInTheKey: section];
    else
    {
        //NSLog(@"numberOfRowsInSection");

        // 清除hashtable data
        [searchHastTableMutableArray_ removeAllObjects];
        
        // 沒有搜尋的字串
        if( searchBar_.text.length <=0 )
            return 0;
        
        // 獲得使用者資料
        int key = [phoneBook_ keyOrder: searchBar_.text];
        
        // 不存在此字串的姓名
        if( key < 0 )
        {
            return 0;
        }
        else
        {
            NSArray *targetArray = [phoneBook_ objectAtSectionInPPPhoneBook:key];
            
            int totalRowNumber = [targetArray count];
            
            HWPlayerInfoDataModel *userPtr;
            HWSearchLinkData *newLinkRelation;
            
            // 比對姓名字串
            for( int countUser_idx = 0 ; countUser_idx < totalRowNumber ; countUser_idx ++)
            {
                userPtr = [targetArray objectAtIndex:countUser_idx];
                
                if( [ userPtr.nameString rangeOfString: searchBar_.text].location == NSNotFound )
                {
                    // do nothing
                }
                else if( [ userPtr.nameString rangeOfString: searchBar_.text].location != 0 )
                {
                    // do nothing
                }
                else
                {
                    newLinkRelation = [[HWSearchLinkData alloc]init];
                    newLinkRelation.row = countUser_idx;
                    newLinkRelation.section = key;
                    
                    [searchHastTableMutableArray_ addObject: newLinkRelation ];
                    [newLinkRelation release];
                }
            }
            return searchHastTableMutableArray_.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    int row;
    int section;
    
    if( tableView == self.tableView )
    {
        // Configure the cell...
        row = indexPath.row;
        section = indexPath.section;
    }
    else
    {
        HWSearchLinkData *ptr = [searchHastTableMutableArray_ objectAtIndex:indexPath.row];
        
        row = ptr.row;
        section = ptr.section;
        
    }
    
     cell.textLabel.text = [phoneBook_ peopleAtSection:section atRow:row].nameString;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if( tableView == self.tableView)
    {
        NSInteger bucketCount = -1;
        
        if ( phoneBook_ == nil )
            return @"";
        else if( ( bucketCount = [phoneBook_ entries]) < 1 )
            return @"";
        else if( bucketCount <= section )
            return @"";
        
        //NSLog(@" titleForHeaderInSection: %d",section);
        return [phoneBook_ keyInPPPhoneBookAtSection:section];
    }
    else
    {
        if( [ searchHastTableMutableArray_ count] <= 0)
            return @"";
        
        HWSearchLinkData *ptr =  [searchHastTableMutableArray_ objectAtIndex:0];
        return [phoneBook_ keyInPPPhoneBookAtSection: ptr.section];

    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    // use by address book
    /*
    PersonDetailViewViewController *detailVc = [[PersonDetailViewViewController alloc]init];
    detailVc.allowsEditing = TRUE;
    [detailVc traceMyBook:phoneBook_];
    [detailVc RenewInfo: indexPath.section  : indexPath.row];
    [self.navigationController pushViewController: detailVc animated:YES];
    */
  
    // Override point for customization after application launch.
	
    PPContactDetailViewController *contactDetailViewController_ = [[[PPContactDetailViewController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
    contactDetailViewController_.root_delegate = self;

    contactDetailViewController_.phoneBookRef  = phoneBook_;
    
    if( tableView == self.tableView )
    {
        contactDetailViewController_.cellRow      = indexPath.row;
        contactDetailViewController_.cellSection  = indexPath.section;
    }
    else
    {
        HWSearchLinkData *ptr = [searchHastTableMutableArray_ objectAtIndex:indexPath.row];
        
        contactDetailViewController_.cellRow     = ptr.row;
        contactDetailViewController_.cellSection = ptr.section;
    }
    
    [contactDetailViewController_ syncPPPhoneBookDataToContacterInReviewMode];
    contactDetailViewController_.mode     = REVIEW_MODE;
    [self.navigationController pushViewController:contactDetailViewController_ animated:YES];
    [contactDetailViewController_ setContactInBrowseMode];
}

- (void) viewDidAppear:(BOOL)animated
{
    
    // 連絡人View出現時，搜尋頁面在上
    if( [searchDisplayController_ isActive] == TRUE )
    {
         if( bRenew_ == TRUE)
         {
            
             [searchDisplayController_.searchResultsTableView reloadData];
             bRenew_ = false;
         }
        // to nothing
    }
    else
    {
        if( bRenew_ == TRUE)
        {
            //NSLog(@"bRenew_ viewDidApplear");
            [self.tableView reloadData];
            bRenew_ = false;
        }
    }
}

#pragma uisearchbar
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // ... Code to refresh the Table View
    
    // Reload the Table View
    [self.tableView reloadData];
    
    // Scroll to top
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 切換新增聯絡人view
-(void) transToAddPeopleView
{
    PPContactDetailViewController *contactDetailViewController_ = [[[PPContactDetailViewController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
    
    contactDetailViewController_.phoneBookRef  = phoneBook_;
    contactDetailViewController_.root_delegate = self;
    contactDetailViewController_.tableView.allowsSelectionDuringEditing = TRUE;
   
    [contactDetailViewController_ syncPPPhoneBookDataToContacterInAddMode];
    [self.navigationController pushViewController:contactDetailViewController_ animated:YES];
    [contactDetailViewController_ setContactInAddMode];
}

// 紀錄下次此頁面要更新
-(void) renewTableContentatSection:(int)section atRow:(int)row;
{
    if( section >= 0 && row >=0 )
    {
        bRenew_ = TRUE;
        //[self.tableView reloadData];
        //[searchDisplayController_.searchResultsTableView reloadData];
    }
}

//刪除搜尋時，所紀錄的資料連結
-(void) deleteHashTableDataatSection:(HWSearchLinkData*)table
{
    for( int idx = 0 ; idx < [searchHastTableMutableArray_ count] ; idx ++)
    {
        HWSearchLinkData *ptr = [searchHastTableMutableArray_ objectAtIndex:idx];
        
        if( table.section == ptr.section && table.row == ptr.row)
        {
            [searchHastTableMutableArray_ removeObjectAtIndex: idx];
        
             NSLog(@"delete data exit. Section:%d, atRow:%d", ptr.section , ptr.row);
            return;
        }
    }
    NSLog(@"No such Data exit. Section:%d, atRow:%d", table.section, table.row);
}

-(void) transViewToPlayerList
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
