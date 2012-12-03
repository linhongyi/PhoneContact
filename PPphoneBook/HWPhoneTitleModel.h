//
//  HWPhoneTitleModel.h
//  PPphoneBook
//
//  Created by pptai on 12/11/27.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWPhoneTitleModel : NSObject
{
    @private
    NSArray *arrDefaultPhoneTitle_;
    NSMutableArray *arrUserDefinePhoneTitle_;

}

-(int) addUserDefinePhoneTitleStringAndGetIdx:(NSString*) phoneTitleString;

@property (nonatomic,readonly) NSArray *arrDefaultPhoneTitle;
@property (nonatomic,readonly) NSArray *arrUserDefinePhoneTitle;
@property (nonatomic,copy) NSString* selectedString;

@end