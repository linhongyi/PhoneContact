//
//  PP_NewPersonViewController.h
//  PPphoneBook
//
//  Created by pptai on 12/10/31.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@interface PP_NewPersonViewController : ABNewPersonViewController <ABNewPersonViewControllerDelegate>
{
    id parent_;
}
@property (nonatomic,assign) id AddressBookContainerDelegate;
@end
