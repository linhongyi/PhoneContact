//
//  AppDelegate.h
//  PPphoneBook
//  
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPContactViewContainer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PPContactViewContainer *ppContactViewContainer_;
}

@property (strong, nonatomic) UIWindow *window;

@end
