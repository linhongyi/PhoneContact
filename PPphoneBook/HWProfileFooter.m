//
//  HWProfileFooter.m
//  PPphoneBook
//
//  Created by pptai on 12/11/6.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWProfileFooter.h"
#import "PPContactDetailViewController.h"
#import "CommonVar.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTType.h>
#import <MessageUI/MessageUI.h>
#import "HWSearchLinkData.h"

@implementation HWProfileFooter


@synthesize ppContactDetailViewControllerRef = ppContactDetailViewControllerRef_;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        // create footer;
        
        mailBtn_     = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
        [mailBtn_ setTitle:@"傳送訊息"forState:UIControlStateNormal];
        mailBtn_.frame     = CGRectMake(10, 0,145,45);
        [mailBtn_ addTarget: self action:@selector(wakeMailController) forControlEvents:UIControlEventTouchUpInside];
        mailBtn_.userInteractionEnabled = TRUE;
        
        faceTimeBtn_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
        [faceTimeBtn_ setTitle:@"FaceTime" forState:UIControlStateNormal];
        faceTimeBtn_.frame = CGRectMake(165, 0,145, 45);
        
      
        deleteBtn_ = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        deleteBtn_.clipsToBounds = YES;
        deleteBtn_.layer.cornerRadius = 10.0f;
        deleteBtn_.frame = CGRectMake(10, 0,300,45);
        
        [deleteBtn_ setTitle:@"Delete Account" forState:UIControlStateNormal];
      
        [deleteBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         deleteBtn_.backgroundColor = [UIColor redColor];
        [deleteBtn_ addTarget: self action:@selector(wakeDeleteActionSheet) forControlEvents:UIControlEventTouchUpInside];
         deleteBtn_.userInteractionEnabled = TRUE;

    }
      
    return self;
}

-(void)dealloc
{
    [faceTimeBtn_ release];
    [mailBtn_ release];
    [deleteBtn_ release];
    [super dealloc];
}

-(void)viewTransToEdit;
{
    [faceTimeBtn_ removeFromSuperview];
    [mailBtn_ removeFromSuperview];
    [self addSubview: deleteBtn_];
}

-(void)viewTransToBrowse;
{
    [deleteBtn_ removeFromSuperview];
    
    [self addSubview: mailBtn_];
    [self addSubview: faceTimeBtn_];
}

#pragma mail
- (void) wakeMailController
{
    MFMailComposeViewController *mailComposeViewController = [[[ MFMailComposeViewController alloc]init]autorelease];
    
  
    if( self.ppContactDetailViewControllerRef != nil)
    {
        
        NSString *email = [self.ppContactDetailViewControllerRef.phoneBookRef peopleAtSection:self.ppContactDetailViewControllerRef.cellSection atRow:self.ppContactDetailViewControllerRef.cellRow].emailString;

        mailComposeViewController.delegate = self;
        mailComposeViewController.mailComposeDelegate = self;
        [self.ppContactDetailViewControllerRef presentViewController:mailComposeViewController animated:YES completion:nil];
        
        
        [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:email, nil]];
        [mailComposeViewController setSubject:@"Nice to meet You"];
         
    }
}

#pragma MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
      
    if( [MFMailComposeViewController canSendMail] == TRUE)
    {
        if( error == nil)
        {
            if( self.ppContactDetailViewControllerRef != nil)
            {
                [self.ppContactDetailViewControllerRef dismissViewControllerAnimated:TRUE completion:nil];
            }
        }
        else
        {
            UIAlertView *alertView =[[[ UIAlertView alloc] init ] autorelease];
            alertView.title = @"sendMail fail";
            [alertView addButtonWithTitle: @"ok" ];
            [alertView show];
         
        }

    }
         
  
}

#pragma UIAlerViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex");
    NSLog(@"User select button %d\n",buttonIndex);
    
    if( self.ppContactDetailViewControllerRef != nil)
    {
        [self.ppContactDetailViewControllerRef dismissViewControllerAnimated:TRUE completion:nil];
    }
}



#pragma delete account
- (void) wakeDeleteActionSheet
{
    if( self.ppContactDetailViewControllerRef == nil)
        return;
    
    UIActionSheet *actionSheet = [[[UIActionSheet alloc]
                                  initWithTitle:@"是否刪除連絡人" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Account" otherButtonTitles: nil]autorelease];
    
    [actionSheet showInView: self.ppContactDetailViewControllerRef.tableView ];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( self.ppContactDetailViewControllerRef == nil)
        return;

    // click delete account
    if( buttonIndex == 0)
    {
        [self.ppContactDetailViewControllerRef.phoneBookRef deletePlayer: self.ppContactDetailViewControllerRef.cellSection atRow: self.ppContactDetailViewControllerRef.cellRow];
        
        if([self.ppContactDetailViewControllerRef.root_delegate respondsToSelector:@selector(deleteHashTableDataatSection:)] == TRUE)
        {
            HWSearchLinkData *deleteHWSearchLinkData = [[HWSearchLinkData alloc]init];
            deleteHWSearchLinkData.row     = self.ppContactDetailViewControllerRef.cellRow;
            deleteHWSearchLinkData.section = self.ppContactDetailViewControllerRef.cellSection;
            
            [self.ppContactDetailViewControllerRef.root_delegate performSelector:@selector(deleteHashTableDataatSection:) withObject:deleteHWSearchLinkData];
            
            [deleteHWSearchLinkData release];
        }
       
      
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0)
    {
        if( self.ppContactDetailViewControllerRef == nil)
            return;
        
        self.ppContactDetailViewControllerRef.mode = REVIEW_MODE;
             
       
        self.ppContactDetailViewControllerRef.HWprofileHeader.imageView.userInteractionEnabled = NO;
        
        // add edit button
        self.ppContactDetailViewControllerRef.navigationItem.rightBarButtonItem = self.ppContactDetailViewControllerRef.editButton ;
        self.ppContactDetailViewControllerRef.navigationItem.leftBarButtonItem  = self.ppContactDetailViewControllerRef.goBackButton;
        
        [self.ppContactDetailViewControllerRef notifyRootViewRenewContentatSection: self.ppContactDetailViewControllerRef.cellSection atRow: self.ppContactDetailViewControllerRef.cellRow];
      
        [self.ppContactDetailViewControllerRef notifyGoToRootView];
    }
    
    
}
@end
