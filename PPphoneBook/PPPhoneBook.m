//
//  PPPhoneBook.m
//  PPphoneBook
//
//  Created by pptai on 12/10/16.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "PPPhoneBook.h"

@interface PPPhoneBook (Private)
//
// declare the private member function, Hidden
//
- (id)nameToKeyObject:(NSString*)name;
- (id)sortAllKey;
-(BOOL) isSave:(HWPlayerInfoDataModel *)exitPeopleData newData:(HWPlayerInfoDataModel*)people;
@end // End Test (Private)


@implementation PPPhoneBook:NSObject

-(id) init
{
    self = [super init];
    
    if( self )
    {
        dataCenter_ = [[PPDataCenter alloc]init];
        dataCenter_.phonebookDelegate = self;
        
        
        bookName_ = [[NSString alloc ]initWithString: @"howard"];
        
        ppHoneBook_ = [[NSMutableDictionary alloc]init];
        
        [dataCenter_ openDB];
        //[dataCenter_ clearDB];
        [dataCenter_ syncDBtoPPPhoneBook];
    }
 

    return self;
}


-(void) dealloc
{
    [ppHoneBook_ release];
    [dataCenter_ release];
    [bookName_ release];
    [super dealloc];
}

- (id)nameToKeyObject:(NSString*)name
{
    if( name.length <= 0 )
    {
        return nil;
    }
    
    NSString *firstKey =  name;
    firstKey = [firstKey substringWithRange:NSMakeRange (0,1)];

    // search this keyObject in dictionary
    id obj   = [ppHoneBook_ objectForKey:firstKey];
    return obj;
}

-(int) keyOrder:(NSString*)name
{
    if( name.length <= 0 )
    {
        return 0;
    }
    
    NSString *firstKey =  name;
    firstKey = [firstKey substringWithRange:NSMakeRange (0,1)];
    
    NSArray *arrAllKey = [self sortAllKey];
    int keyIdx = 0;
    
    for(  ; keyIdx < [ppHoneBook_ count] ; keyIdx++)
    {
        // hit
        if( [ firstKey isEqualToString:[arrAllKey objectAtIndex: keyIdx ]] ==TRUE)
            break;
    }
    
    if( keyIdx >= [ppHoneBook_ count])
        return -1;
    else
        return keyIdx;
}

// 獲得排序後key
-(id) sortAllKey
{
    NSArray *keys = [ppHoneBook_ allKeys];
    
         
    keys = [keys sortedArrayUsingComparator:^(id obj1, id obj2)
                {
                    return [obj1 compare: obj2];
                }];
    
    return keys;
}

// set up the AddressBooks name and an empty book;
-(void) saveNewPlayer:(HWPlayerInfoDataModel *)theNewPlayer
{
    // Get First character (ascii), and use it as key value for dictionary
    NSMutableArray *obj = [self nameToKeyObject:theNewPlayer.nameString];
    
    // the key exit
    if( obj != NULL )
    {
        // NSArray *keys = [ppHoneBook_ allKeys];
        [obj addObject:theNewPlayer];
        
        //加入新連絡人，排序
        [obj sortUsingComparator:^(id obj1, id obj2)
                {
                    if ([obj1 isKindOfClass:[HWPlayerInfoDataModel class]] && [obj2 isKindOfClass:[HWPlayerInfoDataModel class]])
                    {
                        HWPlayerInfoDataModel *s1 = (HWPlayerInfoDataModel*)obj1;
                        HWPlayerInfoDataModel *s2 = (HWPlayerInfoDataModel*)obj2;
                        
                        //NSLog(@"s1:%@, s2:%@", s1.nameString, s2.nameString);
                        
                        int len1 = s1.nameString.length;
                        int len2 = s2.nameString.length;
                        
                        int minLen = MIN(len1, len2);
                        
                        NSString *textName1;
                        NSString *textName2;
                        NSComparisonResult result;
                        
                        for( int lenIdx = 0 ; lenIdx < minLen ;lenIdx ++)
                        {
                            textName1 = [s1.nameString substringWithRange:NSMakeRange(lenIdx,1)];
                            textName2 = [s2.nameString substringWithRange:NSMakeRange(lenIdx,1)];
                            result = [textName1 compare: textName2];
                       
                            if( result != (NSComparisonResult)NSOrderedSame)
                            {
                                return result;
                            }
                        }
                   
                    }
                    
                    // TODO: default is the same?
                    return (NSComparisonResult)NSOrderedSame;

                }];
        //[self traceMyBook];
    }
    else
    {
        NSString *firstKey =  theNewPlayer.nameString;
        firstKey = [firstKey substringWithRange:NSMakeRange (0,1)];
        
        NSMutableArray *arrObj = [NSMutableArray array];
        [arrObj addObject: theNewPlayer];
        [ppHoneBook_ setObject:arrObj forKey:firstKey];
    }
}

-(void) addPlayerDataInfo: (HWPlayerInfoDataModel *) theNewPlayer
{
   //[theNewPlayer traceAllPhoneData];
   [self saveNewPlayer:theNewPlayer];
   [dataCenter_ insertDataToDB:theNewPlayer];
}

-(void) deletePlayer:(int)section atRow:(int)row
{
    //notify db delete data
    HWPlayerInfoDataModel *exitPeopleData = [self peopleAtSection:section atRow:row];
    [dataCenter_ deleteDataInDB:exitPeopleData];
    
    NSArray *allKey = [self sortAllKey];
    
    id arrObj = [ppHoneBook_ objectForKey:[allKey objectAtIndex:section]];

    [arrObj removeObjectAtIndex:row];
 
    if( [arrObj count] <= 0)
        [ppHoneBook_ removeObjectForKey:[allKey objectAtIndex:section]];
}

 -(NSString*) keyInPPPhoneBookAtSection:(int) section
{
    NSArray *keys = [self sortAllKey];
    
    if( section > [keys count])
        return @"";
    else
    {
        return [keys objectAtIndex: section ];
    }

}

-(HWPlayerInfoDataModel*) peopleAtSection:(int)section atRow:(int)row
{
    NSArray *keys = [self sortAllKey];
    
    
    id arrObj = [ppHoneBook_ objectForKey:[keys objectAtIndex:section]];
    
    if( arrObj != nil)
        return [arrObj objectAtIndex:row];
    else
        return nil;
}

-(int)  numberentriesInTheKey:(int) section;
{
    id arrObj = [self objectAtSectionInPPPhoneBook: section];
       
    if( arrObj == Nil)
        return 0;
    else
    {
        return [arrObj count];
    }
   
}

-(int) numberKeyInKeyBook
{
    NSArray *allKey = [ppHoneBook_ allKeys];
    
    return [allKey count];
    
    /*
    int totalentries = 0;
    id  arrObj;
    
    NSArray *allKey = [ppHoneBook_ allKeys];
    
    for( NSString *key in allKey)
    {
        arrObj = [ppHoneBook_ objectForKey:key];
        
        if( [arrObj count] > 0)
            totalentries ++;
    }
    
    return totalentries;
     */
}



-(id)  objectAtSectionInPPPhoneBook:(int) section
{
    NSArray *allKey = [self sortAllKey];
    
    if( section > [allKey count])
        return Nil;
    else
    {
        id arrObj = [ppHoneBook_ objectForKey:[allKey objectAtIndex: section]];
        return arrObj;
    }
}

-(int) entries
{
    int totalentries = 0;
    id  arrObj;
    
    NSArray *allKey = [self sortAllKey];
    
    for( NSString *key in allKey)
    {
        arrObj = [ppHoneBook_ objectForKey:key];
        
        totalentries += [arrObj count];
    }
    
    return totalentries;
}

-(BOOL) modifyPlayerData:(HWPlayerInfoDataModel*)people atSection:(int)section atRow:(int)row
{
    HWPlayerInfoDataModel *exitPeopleData = [self peopleAtSection:section atRow:row];
   
    // 值有變動
    if([ self isSave: exitPeopleData newData: people] == TRUE )
    {
        BOOL bAnswer = [dataCenter_ updateDataToDB: people primaryKey: exitPeopleData.nameString];
      
        // 寫入資料庫成功
        if( bAnswer)
        {
            
            //NSString *key = [self keyInPPPhoneBookAtSection: section];
            
            // 姓名索引不變
            //if( [key isEqualToString: [people.nameString substringWithRange:NSMakeRange (0,1)] ] == TRUE)
            //{
            //    exitPeopleData.addressString     = people.addressString;
            //    exitPeopleData.emailString       = people.emailString;
                
            //    exitPeopleData.imgURL            = people.imgURL;
            //    exitPeopleData.nameString        = people.nameString;
            //}
            //else
            //{
                //刪除錯誤分組
                NSArray *allKey = [self sortAllKey];
                
                id arrObj = [ppHoneBook_ objectForKey:[allKey objectAtIndex:section]];
                
                [arrObj removeObjectAtIndex:row];
                
                if( [arrObj count] <= 0)
                    [ppHoneBook_ removeObjectForKey:[allKey objectAtIndex:section]];

                
                //新增資料
                //exitPeopleData =[[ HWPlayerInfoDataModel alloc]init];
                //exitPeopleData.addressString     = people.addressString;
                //exitPeopleData.emailString       = people.emailString;
     
                //exitPeopleData.imgURL      = people.imgURL;
                //exitPeopleData.nameString        = people.nameString;
               
                [self saveNewPlayer:people];
                //[exitPeopleData release];
            }
        return bAnswer;
    }
    else
    {
        return FALSE;
    }
}

-(NSArray*) lookUpThePlayerIndex:(HWPlayerInfoDataModel*)people
{
    // Get First character (ascii), and use it as key value for dictionary
    id obj = [self nameToKeyObject:people.nameString];
    
    // get all key;
     NSArray *allKey = [self sortAllKey];
  
    
    // the key exit
    if( obj != NULL )
    {
        if( [obj containsObject:people] == TRUE)
        {
            NSNumber *row = [[NSNumber alloc]initWithInt:[obj indexOfObject:people]];
            NSNumber *section = [[NSNumber alloc]initWithInt:[allKey indexOfObject:[people.nameString substringWithRange:NSMakeRange (0,1)]]];
  
            NSArray *arrIdex = [[NSArray alloc]initWithObjects:section,row,Nil];
            
            [row release];
            [section release];
            return [arrIdex autorelease];
            
        }
        else
            return Nil;
    }
    else
    {
        return Nil;
    }

}

-(BOOL) isSave:(HWPlayerInfoDataModel *)exitPeopleData newData:(HWPlayerInfoDataModel*)people
{
    if( exitPeopleData.nameString != people.nameString)
        return TRUE;
    else if ( exitPeopleData.addressString != people.addressString )
        return TRUE;
    else if( exitPeopleData.emailString != people.emailString)
        return TRUE;
    else if( [exitPeopleData isEqualToPhoneDataCompareWithHWPlayerInfoDataModel:people] == FALSE)
        return TRUE;
    else if( exitPeopleData.imgURL != people.imgURL)
        return TRUE;
    else
        return FALSE;
}

-(void) traceMyBook
{
    NSLog(@"cout:%d",ppHoneBook_.count);
    
    NSArray *allkey = [self sortAllKey];
    
    for( int key = 0 ; key <allkey.count ; key++)
    {
        id pobj = [ppHoneBook_ objectForKey:[allkey objectAtIndex:key]];
        
        NSLog(@"key: %@",[allkey objectAtIndex:key]);
        
        for( HWPlayerInfoDataModel *nextPeople in pobj)
            NSLog(@"name: %@",nextPeople.nameString);
    }
    
}
@end