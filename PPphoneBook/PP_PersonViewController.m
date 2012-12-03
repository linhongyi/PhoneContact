//
//  PP_PersonViewController.m
//  PPphoneBook
//
//  Created by pptai on 12/10/30.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PP_PersonViewController.h"

/*
@implementation ABPersonViewController (Delete)




- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    
    return YES;
}
*/


@implementation PP_PersonViewController
@synthesize AddressBookContainerDelegate = parent_;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        @try
        {
            // Display the "Delete" and "Cancel" action sheet
            [self setValue:[NSNumber numberWithBool:YES] forKey:@"allowsDeletion"];
        }
        @catch (NSException * e)
        {
            // Ignore any exception
        }
    }
    
    return self;
}

- (void) dealloc
{
    
    [super dealloc];
}
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
    defaultRightBarButtonItem_ = self.navigationItem.rightBarButtonItem;
    
    UIBarButtonItem *editBtn = [[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                    target:self
                                    action:@selector(actionEdit:)]autorelease];
    self.navigationItem.rightBarButtonItem = editBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    NSLog(@"shouldPerformDefaultActionForPerson");
    return YES;
}



- (void)actionEdit:(UIBarButtonItem *)sender
{
    if( [defaultRightBarButtonItem_.target respondsToSelector: defaultRightBarButtonItem_.action] == TRUE )
    {
        [defaultRightBarButtonItem_.target
         performSelector:defaultRightBarButtonItem_.action
         withObject:defaultRightBarButtonItem_.target];
        
        defaultRightBarButtonItem_ = self.navigationItem.rightBarButtonItem;
       
        UIBarButtonItem *saveBtn = [[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                    target:self
                                    action:@selector(actionSave:)]autorelease];
        self.navigationItem.rightBarButtonItem = saveBtn;

    }
}


- (void)actionSave:(UIBarButtonItem *)sender {
    
    // Do what you want to do before the data is saved
    // ....
    // ....
    /*
    CFErrorRef error;
    
    ABAddressBookSave(self.displayedPerson,  &error);
    
    if( error != nil )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Could not find Appleseed in the Contacts application"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
    }*/
    
    // Trigger the default action
   // CFErrorRef error;
    
        if( [defaultRightBarButtonItem_.target respondsToSelector: defaultRightBarButtonItem_.action] == TRUE )
    {
        [defaultRightBarButtonItem_.target
         performSelector:defaultRightBarButtonItem_.action
         withObject:defaultRightBarButtonItem_.target];
    
    }
}
@end
