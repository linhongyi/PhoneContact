//
//  AddressBookContainer.m
//  PPphoneBook
//
//  Created by pptai on 12/10/31.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "AddressBookContainer.h"
#import "CommonVar.h"

@implementation AddressBookContainer
@synthesize peoplePicker = peoplePicker_;
@synthesize rootNavView  = rootNavView_;
@synthesize personViewController  = personViewController_;
@synthesize aNewPersonViewController = aNewPersonViewController_;

- (id)init
{
    self = [super init];

    if ( self )
    {
        // Do any additional setup after loading the view.
        rootNavView_ = [[UINavigationController alloc]init];
        
        peoplePicker_ = [[PP_UIPeoplePickerNavigatorViewController alloc]init];
        
        
        CFErrorRef error;
        addressBook_ = ABAddressBookCreateWithOptions(NULL,&error);
        
        
        peoplePicker_.addressBook = addressBook_;
        peoplePicker_.delegate = peoplePicker_;
        peoplePicker_.peoplePickerDelegate = peoplePicker_;
        // Display only a person's phone, email, and birthdate
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                                   [NSNumber numberWithInt:kABPersonEmailProperty],
                                   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
        
        
        peoplePicker_.displayedProperties = displayedItems;
        
        peoplePicker_.AddressBookContainerDelegate = self;
        
        aNewPersonViewController_ = [[PP_NewPersonViewController alloc] init];
        aNewPersonViewController_.newPersonViewDelegate = aNewPersonViewController_;
        aNewPersonViewController_.AddressBookContainerDelegate = self;

    }
    return self;
}

-(void)dealloc
{
    CFRelease(addressBook_);
    [rootNavView_ release];
    [peoplePicker_ release];
    [aNewPersonViewController_ release];
    [personViewController_ release];
    [super dealloc];
}

-(void)transToNewPersonView
{
    //NSLog(@"transToNewPersonView");
    
    
    ABRecordRef aContact = ABPersonCreate();
    
    self.aNewPersonViewController.displayedPerson = aContact;
    [self.rootNavView pushViewController: aNewPersonViewController_ animated:NO];
    [self.peoplePicker presentViewController:rootNavView_ animated: YES completion:nil ];
    
    CFRelease(aContact);
}

-(void)transToPickerView
{
    peoplePicker_.layer = PICKER_VIEW;
    [aNewPersonViewController_ removeFromParentViewController];
    [self.peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)transToPersonView:(ABRecordRef)person
{
    //NSLog(@"transToPersonView");
    self.personViewController = [[[PP_PersonViewController alloc]init]autorelease];
    self.personViewController.addressBook = addressBook_;
    self.personViewController.personViewDelegate = self.personViewController;
    
    peoplePicker_.layer = DETAIL_VIEW;
    

    [personViewController_ setDisplayedPerson:person];
    
    [personViewController_ setAllowsEditing:YES];
   
  
    personViewController_.displayedProperties = [NSArray arrayWithObjects:
                                            [NSNumber numberWithInt:kABPersonPhoneProperty],
                                            [NSNumber numberWithInt:kABPersonEmailProperty],
                                            nil];
    
    [peoplePicker_ pushViewController: personViewController_ animated:YES];
}

-(void)newPersonViewToPersonView:(ABRecordRef)person
{
    //peoplePicker_.layer = PICKER_VIEW;
    [aNewPersonViewController_ removeFromParentViewController];
    [self.peoplePicker dismissViewControllerAnimated:NO completion:nil];
    [self transToPersonView:person];
}

-(void)syncAddressBook
{
}
@end
