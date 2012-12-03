//
//  PPDataCenter.m
//  PPphoneBook
//
//  Created by pptai on 12/11/7.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PPDataCenter.h"
#import "MacroUtils.h"
#import "HWPhoneData.h"

@interface PPDataCenter()
{
    NSMutableString *phoneValueDBMutableString_;
    NSMutableString *phoneTitleDBMutableString_;
}

-(void) transToPhoneDBString:(HWPlayerInfoDataModel*) people;
-(NSMutableArray*) newPhoneValueArray:(NSString*)phoneValueString;
-(NSMutableArray*) newPhoneTitleArray:(NSString*)phoneTitleString;
@end


@implementation PPDataCenter

@synthesize phonebookDelegate = phonebookDelegate_;

-(id)init
{
    self = [super init];
    if( self)
    {
        NSString * doc = PATH_OF_DOCUMENT;
        NSString * path = [doc stringByAppendingPathComponent:@"ppAddressBook1.sqlite"];
        writableDBPathNsstring_ = [[NSString alloc]initWithString: path];
    }
    return self;
}

-(void) dealloc
{
    if( phoneTitleDBMutableString_ != nil)
        [phoneTitleDBMutableString_ release];
    
    if( phoneValueDBMutableString_ != nil)
        [phoneValueDBMutableString_ release];
    
    [writableDBPathNsstring_ release];
    [super dealloc];
}

-(void)openDB
{
    debugMethod();
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:writableDBPathNsstring_] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:writableDBPathNsstring_];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'phoneTitle' VARCHAR(100),'phone' VARCHAR(100),'mail' VARCHAR(30), 'address' VARCHAR(100), 'imgUrl' VARCHAR(30) )";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                debugLog(@"error when creating db table");
            } else {
                debugLog(@"succ to creating db table");
            }
            [db close];
        } else {
            debugLog(@"error when open db");
        }
    }

}


-(void) insertDataToDB:(HWPlayerInfoDataModel *)people
{
    FMDatabase * db = [FMDatabase databaseWithPath:writableDBPathNsstring_];
    if ([db open]) {
        NSString * sql = @"insert into user (name, phoneTitle, phone, mail, address, imgUrl) values(?,?,?,?,?,?)";
       
        [self transToPhoneDBString:people];
        
        if( people.emailString == nil)
            people.emailString = @"";
        if( people.addressString == nil)
            people.addressString = @"";
        
        NSString * name  = people.nameString;
        NSString * mail  = people.emailString;
        NSString * address = people.addressString;

        NSString * imgURL;
        if( people.imgURL == nil)
            imgURL = @"";
        else
            imgURL = [people.imgURL absoluteString];
        
        BOOL res = [db executeUpdate:sql, name, phoneTitleDBMutableString_, phoneValueDBMutableString_,mail, address, imgURL];
        if (!res) {
            debugLog(@"error to insert data");
        } else {
            debugLog(@"succ to insert data");
            debugLog(@"user fgname = %@, phoneTitle = %@, phone = %@, mail = %@, address = %@, imgUrl = %@", name, phoneTitleDBMutableString_, phoneValueDBMutableString_,mail,address,imgURL);

        }
        
        [phoneTitleDBMutableString_ release];
        [phoneValueDBMutableString_ release];
        
        [db close];
        
       
    }
}

-(BOOL) updateDataToDB:(HWPlayerInfoDataModel *)people primaryKey:(NSString*) pri_name
{
    //update film set starring='Jodie Foster' where starring='Jodee Foster';
    FMDatabase * db = [FMDatabase databaseWithPath:writableDBPathNsstring_];
   
    
    if ([db open])
    {
        
        NSString *sql = @"";
        
        NSString * name = people.nameString;
        NSString * mail;
        NSString * address; 
        NSString * imgUrl;
  
        
        [self transToPhoneDBString:people];
        
        if( people.emailString == nil)
            mail = @"";
        else
            mail = people.emailString;
        

        if( people.addressString == nil)
            address = @"";
        else
            address = people.addressString;
        
       
        if( people.imgURL == nil)
            imgUrl = @"";
        else
            imgUrl = [people.imgURL absoluteString];
        
        sql = [NSString stringWithFormat:@"UPDATE user SET name= '%@', phoneTitle = '%@', phone = '%@', mail = '%@', address = '%@', imgUrl = '%@' WHERE name = '%@'",name,phoneTitleDBMutableString_, phoneValueDBMutableString_,mail,address,imgUrl,pri_name];
        
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            debugLog(@"error to edit data");
        } else {
            debugLog(@"succ to edit data");
        }
        
        [phoneTitleDBMutableString_ release];
        [phoneValueDBMutableString_ release];
        
        [db close];
        return TRUE;
    }
    else
        return FALSE;
}

-(void)deleteDataInDB:(HWPlayerInfoDataModel *)people
{
    debugMethod();
    
    FMDatabase * db = [FMDatabase databaseWithPath:writableDBPathNsstring_];
    
    
    if ([db open])
    {
        NSString *sql = @"";
        
        NSString * name = people.nameString;
        
        NSString * mail;
        NSString * address;
        
        if( people.emailString == nil)
            mail = @"";
        else
            mail = people.emailString;
        
        if( people.addressString == nil)
            address = @"";
        else
            address = people.addressString;
        
        
        sql = [NSString stringWithFormat:@"DELETE FROM user WHERE name = '%@' AND mail = '%@' AND address ='%@'",name,mail,address];
        
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            debugLog(@"error to delete data");
        } else {
            debugLog(@"succ to delete data");
        }
        [db close];
    }
}

-(void)syncDBtoPPPhoneBook
{
    debugMethod();
    
    FMDatabase * db = [FMDatabase databaseWithPath:writableDBPathNsstring_];
    if ([db open]) {
       
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        
              
        while ([rs next]) {
            int userId = [rs intForColumn:@"id"];
            
            NSString * name       = [rs stringForColumn:@"name"];
            NSString * phoneDBString      = [rs stringForColumn:@"phone"];
            NSString * phoneDBTitleString = [rs stringForColumn:@"phoneTitle"];
            NSString * mail       = [rs stringForColumn:@"mail"];
            NSString * address    = [rs stringForColumn:@"address"];
            NSString * imgUrl     = [rs stringForColumn:@"imgUrl"];
            
            debugLog(@"user id = %d, fgname = %@, phoneTitle = %@, phone = %@, mail = %@, address = %@, imgUrl = %@", userId, name, phoneDBTitleString, phoneDBString,mail,address,imgUrl);
            

            // 新增連絡人一筆新資料
            HWPlayerInfoDataModel *newPeople = [[HWPlayerInfoDataModel alloc]init];
            newPeople.nameString = name;
            newPeople.addressString = address;
            newPeople.emailString    = mail;

            // 電話字串處理
            NSMutableArray *phoneValueArray = [self newPhoneValueArray:phoneDBString];
            NSMutableArray *phoneTitleArray = [self newPhoneTitleArray:phoneDBTitleString];
            int totalPhoneCount = [phoneValueArray count];
            
            
            //implement autoreleasePool
            for( int phoneIdx = 0 ; phoneIdx < totalPhoneCount ; phoneIdx++)
            {
                @autoreleasepool {
                    //HWPhoneData *newPhoneData = [[HWPhoneData alloc]init];
                
            
                    HWPhoneData *newPhoneData = [[[HWPhoneData alloc]init]autorelease];
                    newPhoneData.titleNSString = [phoneTitleArray objectAtIndex:phoneIdx];
                    newPhoneData.phoneNumberValueNSString = [phoneValueArray objectAtIndex:phoneIdx];
                    newPhoneData.numKey = phoneIdx;
                    [newPeople addPhoneData: newPhoneData];
                    
                    //[newPhoneData release];
                }
               
            }
            
            [phoneValueArray release];
            [phoneTitleArray release];
            
            // decode NSSTRING to NSURL
            if( [imgUrl isEqualToString: @""] == TRUE)
            {
                newPeople.imgURL = Nil;
            }
            else
            {
                newPeople.imgURL = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            
            if( [phonebookDelegate_ respondsToSelector:@selector(saveNewPlayer:)])
            {
                [phonebookDelegate_ performSelector:@selector(saveNewPlayer:) withObject:newPeople];
            }
            
            [newPeople release];
        }
        [db close];
    }
}

-(void)clearDB
{
    debugMethod();
    FMDatabase * db = [FMDatabase databaseWithPath:writableDBPathNsstring_];
    if ([db open]) {
        NSString * sql = @"delete from user";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to clearDB db data");
        } else {
            debugLog(@"succ to clearDB db data");
        }
        [db close];
    }
}

-(void) transToPhoneDBString:(HWPlayerInfoDataModel*) people
{
    int totalPhoneCount = [people phoneNumberEntries];
    
    phoneValueDBMutableString_ = [[NSMutableString alloc]init];
    phoneTitleDBMutableString_ = [[NSMutableString alloc]init];
    
    for( int phoneIdx = 0 ; phoneIdx < totalPhoneCount ; phoneIdx++ )
    {
       HWPhoneData *phoneData = [people phoneDataAtIdx:phoneIdx];
    
        if( phoneData.phoneNumberValueNSString.length > 0 )
        {
            [phoneValueDBMutableString_ appendString: phoneData.phoneNumberValueNSString];
            [phoneTitleDBMutableString_ appendString: phoneData.titleNSString];
            
            // 最後一筆，不加斷行符號
            if( phoneIdx < totalPhoneCount-1 )
            {
                [phoneValueDBMutableString_ appendString:@","];
                [phoneTitleDBMutableString_ appendString:@","];
            }

        }
    }
}

-(NSMutableArray*) newPhoneValueArray:(NSString*)phoneValueString
{
    NSMutableArray *arrPhoneValueArray = [[NSMutableArray alloc]init];
    
    // decode phone string
    int phoneLen = phoneValueString.length;
    int posIdx   = 0;
    
    for( int endIdx = 0 ; endIdx < phoneLen ; endIdx++)
    {
        // 找到分隔符號
        if( [phoneValueString characterAtIndex:endIdx] == ',')
        {
            NSRange stringRagne;
            stringRagne.length = endIdx - posIdx;
            stringRagne.location = posIdx;
            posIdx = endIdx+1;
            [arrPhoneValueArray addObject: [phoneValueString substringWithRange:stringRagne]];

        }
        // at least.
        else if( endIdx >= phoneLen-1)
        {
         
            [arrPhoneValueArray addObject: [phoneValueString substringFromIndex:posIdx]];
        }
        
    }
    
   
    return arrPhoneValueArray;
}

-(NSMutableArray*) newPhoneTitleArray:(NSString*)phoneTitleString;
{
    NSMutableArray *arrPhoneTitleArray = [[NSMutableArray alloc]init];
    
    // decode phone string
    int phoneLen = phoneTitleString.length;
    int posIdx   = 0;
    
    for( int endIdx = 0 ; endIdx < phoneLen ; endIdx++)
    {
        // 找到分隔符號
        if( [phoneTitleString characterAtIndex:endIdx] == ',')
        {
            NSRange stringRagne;
            stringRagne.length = endIdx - posIdx;
            stringRagne.location = posIdx;
            posIdx = endIdx+1;
            
            [arrPhoneTitleArray addObject: [phoneTitleString substringWithRange:stringRagne]];
        }
        // at least.
        else if( endIdx >= phoneLen-1)
        {
            
            [arrPhoneTitleArray addObject: [phoneTitleString substringFromIndex:posIdx]];
        }
    }
    
       return arrPhoneTitleArray;
}
@end
