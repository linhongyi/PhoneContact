//
//  PhoneData.m
//  PPphoneBook
//
//  Created by pptai on 12/11/21.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWPhoneData.h"

@implementation HWPhoneData
@synthesize phoneNumberValueNSString = phoneNumberValueNSString_;
@synthesize titleNSString = titleNSString_;
@synthesize numKey = numKey_;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        numKey_ = 0;
        phoneNumberValueNSString_ = [[NSString alloc]initWithString:@""];
        
        titleNSString_ = [[NSString alloc]initWithString:@""];
    }
    return self;
}

-(void)dealloc
{
    [phoneNumberValueNSString_ release];
    [titleNSString_ release];
    [super dealloc];
}

-(void) tracePhoneData
{
    NSLog(@"the key:%d",self.numKey);
    NSLog(@"the title:%@",self.titleNSString);
    NSLog(@"the value:%@",self.phoneNumberValueNSString);
    NSLog(@"===========================");
}


/*
-(void) copyValueFrom:(PhoneData*)data
{
    phoneNumberValueNSString =[NSString stringWithString:data.phoneNumberValueNSString];
    titleNSString_ =[NSString stringWithString:data.titleNSString_];
    //[titleNSString_ setString:data.titleNSString_];
}*/
@end
