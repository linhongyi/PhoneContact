//
//  PhoneData.h
//  PPphoneBook
//
//  Created by pptai on 12/11/21.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWPhoneData : NSObject
{
    @private
    int numKey_;
    NSString *titleNSString_;
    NSString *phoneNumberValueNSString_;
}


-(void) tracePhoneData;
@property (nonatomic,copy) NSString *titleNSString;
@property (nonatomic,copy) NSString *phoneNumberValueNSString;
@property (nonatomic,assign) int numKey;
@end
