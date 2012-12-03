//
//  PPDataCenter.h
//  PPphoneBook
//  Purpose: it's a Bridge between FMDB( sqlite wrapper ) and default data-format ( my ) 
//  Created by pptai on 12/11/7.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "HWPlayerInfoDataModel.h"

@interface PPDataCenter : NSObject
{
    @private
    NSString *writableDBPathNsstring_;
    id       phonebookDelegate_;
}
//@property (nonatomic,copy) NSString *writableDBPathNsstring_;
@property (nonatomic,assign) id phonebookDelegate;

-(void) openDB;
//get data from db , and put it into default data model
-(void) syncDBtoPPPhoneBook;
-(void) insertDataToDB:(HWPlayerInfoDataModel *)people;
-(BOOL) updateDataToDB:(HWPlayerInfoDataModel *)people primaryKey:(NSString*) pri_name;
-(void) deleteDataInDB:(HWPlayerInfoDataModel *)people;
-(void) clearDB;
@end
