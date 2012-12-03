//
//  HWPlayerInfoDataModel.m
//  PPphoneBook
//  
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWPlayerInfoDataModel.h"
#import "CommonVar.h"

@interface HWPlayerInfoDataModel()
{
   
}

@end

@implementation HWPlayerInfoDataModel

@synthesize nameString                = nameString_;

@synthesize addressString             = addressString_;
@synthesize emailString               = emailString_;
@synthesize imgURL                    = imgURL_;
@synthesize arrPhoneData              = arrPhoneData_;

-(id) init
{
    self = [super init];
    
    if( self )
    {
        arrPhoneData_  = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(void)dealloc
{
    [arrPhoneData_ release];
    [nameString_ release];
    [addressString_ release];
    [emailString_ release];
    [imgURL_ release];
    [super dealloc];
}

-(HWPlayerInfoDataModel*) copyHWPlayerInfoDataModel;
{
    HWPlayerInfoDataModel *copyPeople = [[HWPlayerInfoDataModel alloc]init];
    
    copyPeople.nameString = [NSString stringWithString: self.nameString];
    copyPeople.addressString   = [NSString stringWithString: self.addressString];
    copyPeople.emailString     = [NSString stringWithString: self.emailString];
    
    if( [self phoneNumberEntries] > 0 )
    {
        NSMutableArray *newPhoneData = [self copyPhoneData];
        
        int totalPhoneDataCount = [newPhoneData count];
        
        for( int phoneDataIdx = 0 ; phoneDataIdx < totalPhoneDataCount ; phoneDataIdx++)
        {
            [copyPeople.arrPhoneData addObject:[ newPhoneData objectAtIndex: phoneDataIdx]];
        }
        [newPhoneData release];
    }
    return copyPeople;
}




-(int)phoneNumberEntries
{
    return [arrPhoneData_ count];
}

-(HWPhoneData*) phoneDataAtIdx:(int)idx
{
   if( idx >= 0 && idx < [arrPhoneData_ count])
   {
        return [arrPhoneData_ objectAtIndex:idx];
   }
   else
       return nil;
}

-(void) addPhoneData:(HWPhoneData*)newPhoneData
{
    [arrPhoneData_ addObject:newPhoneData];
}

-(void) updatePhoneData:(HWPhoneData*)newPhoneData withKey:(int)key;
{
    int targetIdx = [self phoneDataIdxWithKey:key];
    
    if( targetIdx >= 0 && targetIdx <= [arrPhoneData_ count])
    {
        [arrPhoneData_ replaceObjectAtIndex:targetIdx withObject:newPhoneData];
    }
    else
    {
        // to do something
    }

}

-(int)  findNullPhoneValueDataAtIdxExclusiveKey:(int)key
{
    int totalNum = [arrPhoneData_ count];
    
    int totalIdx   = totalNum - 1;
    int protectIdx = [self phoneDataIdxWithKey:key];
    
    //NSLog(@"currrent row %d, total row %d", protectIdx,totalNum);
    
    int bTargetIdx = -1;
    
    HWPhoneData *exitPhoneData;
    
    for( int idx = 0 ; idx < totalIdx ; idx ++ )
    {
        exitPhoneData = [self phoneDataAtIdx:idx];
        
        if( idx == protectIdx )
            continue;
        
        if( exitPhoneData.phoneNumberValueNSString.length <=0 )
        {
            bTargetIdx = idx;
            break;
        }
    }
    return bTargetIdx;
}

-(void) deletePhoneDataAtIdx:(int)idx
{
    if( idx >= 0 && idx < [arrPhoneData_ count])
    {
        [arrPhoneData_ removeObjectAtIndex: idx];
    }
    else
    {
        //to do something
    }
}

-(int) phoneDataIdxWithKey:(int)key
{
    int totalCount = [arrPhoneData_ count];
    int targetIdx = -1;
    
    HWPhoneData *queryPtr;
    
    for(int phoneDataIdx = 0 ; phoneDataIdx < totalCount ; phoneDataIdx++)
    {
        queryPtr = [arrPhoneData_ objectAtIndex:phoneDataIdx];
        
        if( queryPtr != nil && queryPtr.numKey == key)
        {
            targetIdx = phoneDataIdx;
        }
    }
    return targetIdx;
}

-(NSMutableArray*) copyPhoneData
{
    NSMutableArray *phonearray = [[NSMutableArray alloc]init];
    int totalPhoneNum = [self phoneNumberEntries];
    
    for( int phoneId = 0; phoneId < totalPhoneNum ; phoneId++)
    {
        id phoneData = [arrPhoneData_ objectAtIndex:phoneId];
        [phonearray addObject: phoneData];
    }
    return phonearray;
}

-(void)removeAllEmptyPhoneValueData
{
    for( int idx = 0 ; idx < [arrPhoneData_ count] ; idx ++ )
    {
        HWPhoneData *exitPhoneData = [self phoneDataAtIdx:idx];
      
        if( exitPhoneData.phoneNumberValueNSString.length <=0 )
        {
            [arrPhoneData_ removeObjectAtIndex: idx];
            idx --;
            
        }
    }
}

-(BOOL) isEqualToPhoneDataCompareWithHWPlayerInfoDataModel:(HWPlayerInfoDataModel*)people
{
    if( [self phoneNumberEntries] != [people phoneNumberEntries])
        return FALSE;
    else
    {
        BOOL bEqual = FALSE;
        
        int totalPhoneNum = [self phoneNumberEntries];
        
        for( int phoneIdx = 0 ; phoneIdx <totalPhoneNum ; phoneIdx++)
        {
            NSString *selfTitleString = [self phoneDataAtIdx: phoneIdx ].titleNSString;
            NSString *selfPhoneValueString =  [self phoneDataAtIdx: phoneIdx ].phoneNumberValueNSString;
            
            NSString *otherTitleString = [people phoneDataAtIdx: phoneIdx].titleNSString;
            NSString *otherPhoneValueString = [people phoneDataAtIdx: phoneIdx].phoneNumberValueNSString;
            
            if( [selfTitleString isEqualToString: otherTitleString] != TRUE)
            {
                break;
            }
            else if( [selfPhoneValueString isEqualToString: otherPhoneValueString] != TRUE)
            {
                break;
            }
        }
        
        return bEqual;
    }
}

-(void)traceAllPhoneData
{
    int totalPhoneNum = [self phoneNumberEntries];
    
    for( int phoneId = 0; phoneId < totalPhoneNum ; phoneId++)
    {
        id phoneData = [arrPhoneData_ objectAtIndex:phoneId];
        
        if( [phoneData respondsToSelector:@selector(tracePhoneData)] == TRUE)
        {
            [phoneData performSelector:@selector(tracePhoneData)];
        }
    }
}
@end
