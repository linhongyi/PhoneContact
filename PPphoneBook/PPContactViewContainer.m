//
//  PPCContactViewContainer.m
//  PPphoneBook
//
//  Created by pptai on 12/11/29.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PPContactViewContainer.h"

@implementation PPContactViewContainer
@synthesize phoneBookNavigatorViewController = phoneBookNavigatorViewController_;

-(id)init
{
    self = [super init];
    
    if( self )
    {
        phoneBook_ = [[PPPhoneBook alloc] init] ;
        
        
        playerInfoListTableViewController_ = [[PPPlayerInfoTableListViewController alloc]initWithStyle:UITableViewStyleGrouped];
        playerInfoListTableViewController_.phoneBook = phoneBook_;
        playerInfoListTableViewController_.title = @"所有聯絡資訊";
        
        
        phoneBookNavigatorViewController_ = [[PPRootViewController alloc]init];
        [phoneBookNavigatorViewController_ pushViewController: playerInfoListTableViewController_ animated:NO];
        
        //addressbook
        /*
         self.addressBookViewContainer_ = [[AddressBookContainer alloc]init];
         [self.addressBookViewContainer_ ini];
         self.addressBookViewContainer_.peoplePicker_.layer = PICKER_VIEW;
         
         //[self.addressBookViewContainer_.rootNavView_ presentViewController: self.addressBookViewContainer_.peoplePicker_ animated:YES completion:nil];
         
         [self.window addSubview: self.addressBookViewContainer_.peoplePicker_.view];
         */

    }
    return self;
}

-(void)dealloc
{
    [addressBookViewContainer_ release];
    [phoneBookNavigatorViewController_ release];
    [playerInfoListTableViewController_ release];
    
    [phoneBook_ release];
    [super dealloc];
}

@end
