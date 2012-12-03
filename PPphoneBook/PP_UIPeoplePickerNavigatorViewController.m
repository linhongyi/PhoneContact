//
//  PP_UIPeoplePickerNavigatorViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/10/30.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PP_UIPeoplePickerNavigatorViewController.h"
#import "CommonVar.h"

@implementation PP_UIPeoplePickerNavigatorViewController
@synthesize layer = layer_;
@synthesize AddressBookContainerDelegate = parent_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"PP_UIPeoplePickerNavigatorViewController viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if( layer_ == PICKER_VIEW )
    {
        [self addPeopleBtnToView:viewController];
    }
    else if( layer_ == DETAIL_VIEW )
    {
         //[self addPeopleBtnToView:viewController];
    }
}

#pragma mark - Table view data source for ABPeoplePickerNavigationControllerDelegate
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
   
    if([ self.AddressBookContainerDelegate respondsToSelector:@selector(transToPersonView:)])
    {
        [self.AddressBookContainerDelegate performSelector:@selector(transToPersonView:) withObject:person];
    }
    else
    {
        NSLog(@"id AddressBookContainerDelegate couldn't call transToPersonView");
    }

    return NO;
    
  //  return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
   
    if([ self.AddressBookContainerDelegate respondsToSelector:@selector(transToPersonView:)])
    {
        [ self.AddressBookContainerDelegate performSelector:@selector(transToPersonView)withObject:CFBridgingRelease(person)];
    }
    else
    {
        NSLog(@"id AddressBookContainerDelegate couldn't call transToPersonView");
    }
    
    return NO;
     
   // return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    NSLog(@"peoplePickerNavigationControllerDidCancel");
}

- (void) notifyParentTransToAddView
{
    if([ self.AddressBookContainerDelegate respondsToSelector:@selector(transToNewPersonView)])
    {
        layer_ = ADD_VIEW;
        [ self.AddressBookContainerDelegate performSelector:@selector(transToNewPersonView)];
    }
    else
    {
        NSLog(@"id AddressBookContainerDelegate couldn't call tranToNewPersonView");
    }
}

-(void) addPeopleBtnToView:(UIViewController *)viewController
{
    if([ self respondsToSelector:@selector(notifyParentTransToAddView)])
    {
               
        UIBarButtonItem *addPeopleButton =
        [[[UIBarButtonItem alloc]
         initWithTitle:
         NSLocalizedString(@"新增", nil)
         style:UIBarButtonSystemItemAdd
         
         target:self
         action:@selector( notifyParentTransToAddView ) ]autorelease];
        
        addPeopleButton.enabled = TRUE;
        
        viewController.navigationItem.rightBarButtonItem = addPeopleButton;
      
    }
}
@end
