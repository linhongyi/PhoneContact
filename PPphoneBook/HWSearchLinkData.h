//
//  HWSearchLinkData.h
//  PPphoneBook
//
//  Created by pptai on 12/11/14.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWSearchLinkData : NSObject
{
    @private
    int section;
    int row;
}
@property (nonatomic) int section;
@property (nonatomic) int row;
@end
