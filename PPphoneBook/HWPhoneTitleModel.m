//
//  HWPhoneTitleModel.m
//  PPphoneBook
//
//  Created by pptai on 12/11/27.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWPhoneTitleModel.h"
#import "CommonVar.h"

@interface HWPhoneTitleModel()
{
    
}
-(int) findPhoneTitleStringIdx:(NSString*) phoneTitleString;
@end

@implementation HWPhoneTitleModel
@synthesize arrDefaultPhoneTitle = arrDefaultPhoneTitle_;
@synthesize arrUserDefinePhoneTitle = arrUserDefinePhoneTitle_;

-(id)init
{
    self = [ super init];
    
    if( self )
    {
        arrDefaultPhoneTitle_ = [[ NSArray alloc] initWithObjects: CELLPHONE_NSSTRING, HOME_PHONE_NSSTRING, COMPANY_PHONE_NSSTRING, OTHER_PHONE_NSSTRING, nil];
        
        arrUserDefinePhoneTitle_ = [[NSMutableArray alloc]init];
        [arrUserDefinePhoneTitle_ addObject:@"add Custom Label"];
    }
    return self;
}

-(void)dealloc
{
    [arrDefaultPhoneTitle_ release];
    [arrUserDefinePhoneTitle_ release];
    [super dealloc];
}

-(int) findPhoneTitleStringIdx:(NSString*) phoneTitleString;
{
    int allCount = [arrUserDefinePhoneTitle_ count];
    int targetIdx = -1;
    
    for( int stringIdx = 0 ; stringIdx < allCount ; stringIdx ++)
    {
        if( [phoneTitleString isEqualToString: [arrUserDefinePhoneTitle_ objectAtIndex:stringIdx] ] == TRUE )
        {
            targetIdx = stringIdx;
            break;
        }
    }
    return targetIdx;
}

-(int) addUserDefinePhoneTitleStringAndGetIdx:(NSString*) phoneTitleString
{
    int tagetIdx = [self findPhoneTitleStringIdx:phoneTitleString];
    
    // 字串已存在，不用在存
    if( tagetIdx >= 0)
    {
        return tagetIdx;
    }
    else
    {
        [arrUserDefinePhoneTitle_ insertObject:phoneTitleString atIndex:0];
        return 0;
    }
}
@end
