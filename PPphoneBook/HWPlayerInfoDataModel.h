//
//  HWPlayerInfoDataModel.h
//  PPphoneBook
//  Purpose: basis data format
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWPhoneData.h"
@interface HWPlayerInfoDataModel : NSObject
{
    @private
    NSMutableArray *arrPhoneData_;
}

-(HWPlayerInfoDataModel*) copyHWPlayerInfoDataModel;
-(NSMutableArray*) copyPhoneData;

// 電話結構
-(int) phoneNumberEntries;
-(HWPhoneData*) phoneDataAtIdx:(int)idx;
-(void) addPhoneData:(HWPhoneData*)newPhoneData;
-(void) deletePhoneDataAtIdx:(int)idx;
-(void) updatePhoneData:(HWPhoneData*)newPhoneData withKey:(int)key;
-(int)  phoneDataIdxWithKey:(int)key;

-(int)  findNullPhoneValueDataAtIdxExclusiveKey:(int)key;
-(void) removeAllEmptyPhoneValueData;

-(BOOL) isEqualToPhoneDataCompareWithHWPlayerInfoDataModel:(HWPlayerInfoDataModel*)people;
-(void) traceAllPhoneData;

@property (copy,nonatomic) NSString *nameString;
@property (copy,nonatomic) NSString *addressString;
@property (copy,nonatomic) NSString *emailString;
@property (retain,nonatomic) NSURL  *imgURL;
@property (readonly,nonatomic) NSMutableArray *arrPhoneData;

@end
