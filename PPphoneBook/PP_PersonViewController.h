//
//  PP_PersonViewController.h
//  PPphoneBook
//
//  Created by pptai on 12/10/30.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>



@interface PP_PersonViewController:ABPersonViewController  <ABPersonViewControllerDelegate>
{
    UIBarButtonItem *defaultRightBarButtonItem_;
    id parent_;
}
@property (nonatomic,assign) id AddressBookContainerDelegate;

@end
