 //
//  PPPhoneBook.h
//  PPphoneBook
//  Purpose: data save Model. it is a key-value (key-array)dictionary.
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWPlayerInfoDataModel.h"
#import "PPDataCenter.h"

@interface PPPhoneBook : NSObject
{
    @private
    PPDataCenter *dataCenter_;
    NSMutableDictionary *ppHoneBook_;
    NSString *bookName_;
}

-(void) addPlayerDataInfo: (HWPlayerInfoDataModel *) theNewPlayer;
-(void) deletePlayer:(int)section atRow:(int)row;
-(BOOL) modifyPlayerData:(HWPlayerInfoDataModel*)people atSection:(int)section atRow:(int)row;

-(HWPlayerInfoDataModel*) peopleAtSection:(int)section atRow:(int)row;
-(NSString*) keyInPPPhoneBookAtSection:(int) section;
-(NSArray*) lookUpThePlayerIndex:(HWPlayerInfoDataModel*)people;

-(int)  numberentriesInTheKey:(int) section;
-(int)  numberKeyInKeyBook;
-(int)  keyOrder:(NSString*)name;

-(id)   objectAtSectionInPPPhoneBook:(int) section;

-(int)  entries;
-(void) traceMyBook;
@end
