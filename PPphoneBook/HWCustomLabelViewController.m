//
//  HWCustomLabelViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/11/27.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWCustomLabelViewController.h"

@interface HWCustomLabelViewController ()
{
    UITextField *titleTextField_;
}
-(void) m_clickCancelBtn;
-(void) m_clickSaveBtn;
@end

@implementation HWCustomLabelViewController
@synthesize parentDelegate = parentDelegate_;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        
        // Custom initialization
        customLabelTableViewController_ = [[UITableViewController alloc]initWithStyle:style];
        customLabelTableViewController_.title = @"TitleLabel";
        customLabelTableViewController_.tableView.delegate = self;
        customLabelTableViewController_.tableView.dataSource = self;
        
        customLabelNavViewController_ = [[UINavigationController alloc]initWithRootViewController:customLabelTableViewController_];
        customLabelNavViewController_.view.frame =  CGRectOffset(customLabelNavViewController_.view.frame, 0.0, -20.0);
        
        customLabelSaveBtn_ = [[UIBarButtonItem alloc]init];
        customLabelSaveBtn_.title =  NSLocalizedString(@"確定", nil);
        customLabelSaveBtn_.style = UIBarButtonSystemItemAdd;
        customLabelSaveBtn_.target = self;
        customLabelSaveBtn_.action = @selector(m_clickSaveBtn);
       
        
        customLabelCancelBtn_ = [[UIBarButtonItem alloc]init];
        customLabelCancelBtn_.title =  NSLocalizedString(@"取消", nil);
        customLabelCancelBtn_.style = UIBarButtonSystemItemCancel;
        customLabelCancelBtn_.target = self;
        customLabelCancelBtn_.action = @selector(m_clickCancelBtn);
     
        titleTextField_ = [[UITextField alloc]init];
        titleTextField_.delegate = self;
    }
    return self;
}

-(void)dealloc
{
    [titleTextField_ release];
    [customLabelCancelBtn_ release];
    [customLabelSaveBtn_ release];
    [customLabelTableViewController_ release];
    [customLabelNavViewController_ release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    customLabelSaveBtn_.enabled = NO;
    customLabelTableViewController_.navigationItem.rightBarButtonItem = customLabelSaveBtn_;
    customLabelTableViewController_.navigationItem.leftBarButtonItem = customLabelCancelBtn_;
    [self.view addSubview:customLabelNavViewController_.view];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect textFieldRect = CGRectMake(5, cell.contentView.center.y/2, cell.contentView.bounds.size.width-5, cell.contentView.bounds.size.height);
    
    titleTextField_.frame = textFieldRect;
    
    titleTextField_.placeholder = @"your title";
    
    [cell.contentView addSubview:titleTextField_];
    
    // Configure the cell...
    
    return cell ;
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // add word
    if( string.length > 0)
    {
        customLabelSaveBtn_.enabled = YES;
    }
    else
    {
       if( textField.text.length > 1)
       {
           customLabelSaveBtn_.enabled = YES;
       }
       else
       {
           customLabelSaveBtn_.enabled = NO;
       }
    }
    
    return TRUE;
}

-(void) m_clickCancelBtn
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void) m_clickSaveBtn
{
    if ([parentDelegate_ respondsToSelector:@selector(notifyHWPhoneAddSelectedPhoneTitleString:)])
    {
        [parentDelegate_ performSelector:@selector(notifyHWPhoneAddSelectedPhoneTitleString:) withObject:titleTextField_.text];
    }
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
}

@end
