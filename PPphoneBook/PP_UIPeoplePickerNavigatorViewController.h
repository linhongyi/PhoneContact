//
//  PP_UIPeoplePickerNavigatorViewController.h
//  PPphoneBook
//
//  Created by pptai on 12/10/30.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>

@interface PP_UIPeoplePickerNavigatorViewController : ABPeoplePickerNavigationController   <UINavigationControllerDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    int layer_;
    id  parent_;
}
@property (nonatomic) int layer;
@property (nonatomic,assign) id AddressBookContainerDelegate;
@end
