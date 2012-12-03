//
//  HWPhoneTitleSelectionViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/11/27.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWPhoneTitleSelectionViewController.h"
#import "HWCustomLabelViewController.h"
@interface HWPhoneTitleSelectionViewController ()
{
    NSIndexPath *selectedIndexPath_;
}
@end

@implementation HWPhoneTitleSelectionViewController
@synthesize parentDelegate = parentDelegate_;
@synthesize selectedString = selectedString_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        // Custom initialization
        hwPhoneTitleModel_ = [[HWPhoneTitleModel alloc]init];
        selectedString_    = [[NSString alloc]init];
        selectedIndexPath_ = [[NSIndexPath alloc]init];
    }
    return self;
}

-(void) dealloc
{
    [selectedIndexPath_ release];
    [selectedString_ release];
    [hwPhoneTitleModel_ release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Label";
    //[phoneTitleNavViewController_ pushViewController:phoneTitleTableViewController_ animated:NO];
    //[self.view addSubview:phoneTitleNavViewController_.view];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //default phone title
    if( section == 0)
    {
        return hwPhoneTitleModel_.arrDefaultPhoneTitle.count;
    }
    // user define title
    else
    {
        return hwPhoneTitleModel_.arrUserDefinePhoneTitle.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //cell.tag = indexPath.row;
    
    //phone title
    if( indexPath.section == 0)
    {
        if( indexPath.row >= 0 && indexPath.row < [hwPhoneTitleModel_.arrDefaultPhoneTitle count])
        {
            cell.textLabel.text = [hwPhoneTitleModel_.arrDefaultPhoneTitle objectAtIndex:indexPath.row];
            
            if( [cell.textLabel.text isEqualToString:selectedString_ ] == TRUE )
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                selectedIndexPath_ = [indexPath retain];
            }
        }
    }
    //user define phone title
    else if( indexPath.section == 1)
    {
        if( indexPath.row >= 0 && indexPath.row < [hwPhoneTitleModel_.arrUserDefinePhoneTitle count])
        {
            cell.textLabel.text = [hwPhoneTitleModel_.arrUserDefinePhoneTitle objectAtIndex:indexPath.row];
            
            if( [cell.textLabel.text isEqualToString:selectedString_ ] == TRUE )
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                selectedIndexPath_ = [indexPath retain];
            }

        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
     [detailViewController release];
     */
    
   
    // add customLabel
    if( indexPath.section == 1 && indexPath.row == [hwPhoneTitleModel_.arrUserDefinePhoneTitle count]-1 )
    {
        HWCustomLabelViewController *customLableViewController = [[[HWCustomLabelViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        
        customLableViewController.parentDelegate = self;
        [self presentViewController:customLableViewController animated: YES completion: nil];
    }
    //select phoneTitle
    else
    {
        UITableViewCell *cell;
        
        if( selectedIndexPath_.length > 0)
        {
            // 取消上次勾選項目
            cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath_];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell = [tableView cellForRowAtIndexPath: indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if( [ parentDelegate_ respondsToSelector:@selector(userDidClickSelectedTitleCell:)])
        {
            [ parentDelegate_ performSelector:@selector(userDidClickSelectedTitleCell:) withObject:cell ];
        }
        
        if( [ parentDelegate_ respondsToSelector:@selector(userDidViewTransToContactView)])
        {
            [ parentDelegate_ performSelector:@selector(userDidViewTransToContactView)];
        }
    }
}

-(void) notifyHWPhoneAddSelectedPhoneTitleString:(NSString*)cellTitleString;
{
   int targetIdx = [hwPhoneTitleModel_ addUserDefinePhoneTitleStringAndGetIdx:cellTitleString];
    
     // 已存在
    if( targetIdx >= 0)
    {
        if( selectedIndexPath_.length > 0)
        {
            // 取消上次勾選項目
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath_];
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
               
        
        self.selectedString = cellTitleString;
        
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                         [NSIndexPath indexPathForRow:targetIdx inSection:1],
                                         nil];
        
        UITableView *tv = (UITableView *)self.view;
        [tv beginUpdates];
        [tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        [tv endUpdates];
    }
    
}
@end
