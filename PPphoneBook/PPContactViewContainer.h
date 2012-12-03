//
//  PPCContactViewContainer.h
//  PPphoneBook
//
//  Created by pptai on 12/11/29.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPhoneBook.h"
#import "PPPlayerInfoTableListViewController.h"
#import "PPRootViewController.h"
#import "AddressBookContainer.h"
#import <AddressBook/AddressBook.h>

@interface PPContactViewContainer : NSObject
{
    AddressBookContainer   *addressBookViewContainer_;
    PPRootViewController   *phoneBookNavigatorViewController_;
    PPPlayerInfoTableListViewController *playerInfoListTableViewController_;
    PPPhoneBook            *phoneBook_;
}
@property (nonatomic,readonly) PPPhoneBook *phoneBook;
@property (nonatomic,readonly) PPRootViewController *phoneBookNavigatorViewController;
@end
