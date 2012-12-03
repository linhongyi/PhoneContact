//
//  PPPlayerInfoTableListViewController.h
//  PPphoneBook
//  Purpose: it controls the friends list.
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPhoneBook.h"
#import "HWSearchLinkData.h"
#import "PPContactDetailViewController.h"

@interface PPPlayerInfoTableListViewController : UITableViewController <UISearchBarDelegate,UISearchDisplayDelegate>
{
    PPPhoneBook *phoneBook_;
    
    NSMutableArray *searchHastTableMutableArray_;
    UISearchBar *searchBar_;
    UISearchDisplayController *searchDisplayController_;
    BOOL bRenew_;
}

@property (nonatomic,assign) PPPhoneBook *phoneBook;
// reload data..
-(void) renewTableContentatSection:(int)section atRow:(int)row;
// it removes all subview , and shows the rootview
-(void) transViewToPlayerList;

@end
