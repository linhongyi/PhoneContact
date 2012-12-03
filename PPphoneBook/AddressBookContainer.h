//
//  AddressBookContainer.h
//  PPphoneBook
//
//  Created by pptai on 12/10/31.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PP_UIPeoplePickerNavigatorViewController.h"
#import "PP_NewPersonViewController.h"
#import "PP_PersonViewController.h"

@interface AddressBookContainer :NSObject
{
    UINavigationController *rootNavView_;
    PP_UIPeoplePickerNavigatorViewController *peoplePicker_;
    PP_NewPersonViewController *aNewPersonViewController_;
    PP_PersonViewController *personViewController_;
    ABAddressBookRef addressBook_;
}
@property (nonatomic,retain) UINavigationController *rootNavView;
@property (nonatomic,retain) PP_UIPeoplePickerNavigatorViewController *peoplePicker;
@property (nonatomic,retain) PP_NewPersonViewController *aNewPersonViewController;
@property (nonatomic,retain) PP_PersonViewController *personViewController;

-(void)transToNewPersonView;
-(void)transToPickerView;
-(void)transToPersonView:(ABRecordRef)person;
-(void)newPersonViewToPersonView:(ABRecordRef)person;
-(void)syncAddressBook;
@end
