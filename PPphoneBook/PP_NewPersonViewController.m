//
//  PP_NewPersonViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/10/31.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PP_NewPersonViewController.h"


@implementation PP_NewPersonViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person)
    {
        //save data
        NSLog(@"save");
        if([ self.AddressBookContainerDelegate respondsToSelector:@selector(newPersonViewToPersonView:)])
        {
            [self.AddressBookContainerDelegate performSelector:@selector(newPersonViewToPersonView:) withObject: person];
            
            
        }
        else
        {
            NSLog(@"id AddressBookContainerDelegate couldn't call newPersonViewToPersonView");
        }
    }
    else
    {
        NSLog(@"取消");
        if([ self.AddressBookContainerDelegate respondsToSelector:@selector(transToPickerView)])
        {
            [ self.AddressBookContainerDelegate performSelector:@selector(transToPickerView)];
        }
        else
        {
            NSLog(@"id AddressBookContainerDelegate couldn't call transToPickerView");
        }
    }
    
   
    //[self popViewControllerAnimated:YES];
}

@end
