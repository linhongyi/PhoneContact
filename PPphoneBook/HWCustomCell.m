//
//  HWCustomCell.m
//  PPphoneBook
//
//  Created by pptai on 12/11/20.
//  Copyright (c) 2012年 HowardLin. All rights reserved.
//

#import "HWCustomCell.h"
#import "CommonVar.h"
#import "PPContactDetailViewController.h"


@interface HWCustomCell ()
{
    BOOL bCouldResponse_;
}

-(void) m_updatePhoneTextFieldDataToContactData:(NSRange)range  replacementString:(NSString *)string;
-(void) m_updateAddressTextFieldDataToContactData:(NSRange)range  replacementString:(NSString *)string;
-(void) m_updateEmailTextFieldDataToContactData:(NSRange)range  replacementString:(NSString *)string;

@end

@implementation HWCustomCell
@synthesize cellTextField = cellTextField_;
@synthesize delegate      = delegate_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        bCouldResponse_ = false;
        
        // Initialization code
        CGRect textFieldRect = CGRectMake((self.contentView.bounds.size.width/4)+5, 0, self.contentView.bounds.size.width/2+20, self.contentView.bounds.size.height);
        
        
        // create phone textfield;
        cellTextField_ = [[UITextField alloc] initWithFrame:textFieldRect];
        cellTextField_.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
        cellTextField_.returnKeyType = UIReturnKeyDone;
        cellTextField_.clearButtonMode = YES;
        cellTextField_.tag = 0;
        cellTextField_.delegate = self;
        cellTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        cellTextField_.returnKeyType = UIReturnKeyDone;
        
        [self.contentView addSubview:cellTextField_];
        
        grayLineView_ = [[UIView alloc] initWithFrame:CGRectMake((self.contentView.bounds.size.width/4), 0, 1, self.contentView.bounds.size.height)];
        
        grayLineView_.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:grayLineView_];

     
    }
    return self;
}

-(void) dealloc
{
    [cellTextField_ release];
    [grayLineView_ release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





#pragma mark - textField
// handle text editing...
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // add word
    if( string.length > 0)
    {
        
        if( [self.textLabel.text isEqualToString:@"信箱"] == TRUE)
        {
            [self m_updateEmailTextFieldDataToContactData:range replacementString:string];
        }
        else if( [self.textLabel.text isEqualToString:@"地址"] == TRUE)
        {
             [self m_updateAddressTextFieldDataToContactData:range replacementString:string];
        }
        // 檢查是否為電話
        else
        {
            /****************
             *檢查電話是否有非數字
             *****************/
            
            // check the input is number or not
            NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
            
            if ([alphaNumbersSet isSupersetOfSet:stringSet] == false )
                return false;
            // edit phonenumber > 13
            else if( range.location > LENGTH_TITLE + LENGTH_PHONE_NUMBER)
            {
                return false;
            }
            
                      
            NSNumber *newRow = 0;
            
    
            //檢查是否為最新的一筆
            if( [delegate_ respondsToSelector:@selector(notifyHWcontactViewShouldAddCellInChangingWordWithIndexPath:)] == TRUE)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow: self.tag inSection: self.cellTextField.tag] ;
                

                NSNumber *bAnswer = [delegate_ performSelector:@selector(notifyHWcontactViewShouldAddCellInChangingWordWithIndexPath:) withObject: indexPath];
                    
                if( [bAnswer boolValue] == TRUE)
                {
                    if( [ delegate_ respondsToSelector:@selector(hwContactViewWillReturnRowIndex)])
                    {
                            // note add row data, and return new row
                            newRow = [delegate_ performSelector:@selector(hwContactViewWillReturnRowIndex)];
                            
                            // add row
                        if( [delegate_ respondsToSelector:@selector(notifyHWcontactViewToAddTableViewCellWithIndexPath:)] == TRUE)
                        {
                                NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                                             [NSIndexPath indexPathForRow:[newRow intValue]-1 inSection:0],
                                                             nil];
                                
                                [delegate_ performSelector:@selector(notifyHWcontactViewToAddTableViewCellWithIndexPath:) withObject: insertIndexPaths];
                        }
                    }
                }
                    
            }
            
            [self m_updatePhoneTextFieldDataToContactData:range replacementString:string];

             
             // reload before row
                        
             
             if( [delegate_ respondsToSelector:@selector(notifyHWcontactViewToRenewTableViewCellEdittMode)] == TRUE)
             {
                 [delegate_ performSelector:@selector(notifyHWcontactViewToRenewTableViewCellEdittMode)];
             }
            
             
        }
    }
    else
    {
        if( [self.textLabel.text isEqualToString:@"信箱"] == TRUE)
        {
            [self m_updateEmailTextFieldDataToContactData:range replacementString:string];
        }
        else if( [self.textLabel.text isEqualToString:@"地址"] == TRUE)
        {
            [self m_updateAddressTextFieldDataToContactData:range replacementString:string];
        }
        // 檢查是否為電話
        else
        {
            [self m_updatePhoneTextFieldDataToContactData:range replacementString:string];

        }
    }
        
        return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 檢查是否為電話
    if( [self.textLabel.text isEqualToString:@"信箱"] != TRUE
       && [self.textLabel.text isEqualToString:@"地址"] != TRUE)
    {
              
        // to do 檢查空字的textfield remove
        if( [ delegate_ respondsToSelector:@selector(notifyHWcontactViewShouldRemoveNullPhoneValueAndReturnDeleteRowButTheKey:)])
        {
           // NSLog(@"textFieldShouldBeginEditing");

            NSNumber *protectKey = [[NSNumber alloc]initWithInt: textField.tag];
            
            // note remove row data, and return the Idx
            NSNumber *targetIdex = [delegate_ performSelector:@selector(notifyHWcontactViewShouldRemoveNullPhoneValueAndReturnDeleteRowButTheKey:) withObject: protectKey];
            
            [protectKey release];
            
            if( [targetIdex intValue] >= 0)
            {
                NSLog(@"delete row %d", [targetIdex intValue]);
                NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                            [NSIndexPath indexPathForRow:[targetIdex intValue] inSection:0],
                                             nil];
              
                if( [delegate_ respondsToSelector:@selector(notifyHWcontactViewToDeleteTableViewCellWithIndexPath:)] == TRUE)
                {
                     [delegate_ performSelector:@selector(notifyHWcontactViewToDeleteTableViewCellWithIndexPath:) withObject: deleteIndexPaths];
                }
               
            }
            
           
        }
        
    }
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField
{
      
    NSRange range;
    range.location = 0;
    range.length   = textField.text.length;
    
    if( [self.textLabel.text isEqualToString:@"信箱"] == TRUE)
    {
        [self m_updateEmailTextFieldDataToContactData:range replacementString:@""];
    }
    else if( [self.textLabel.text isEqualToString:@"地址"] == TRUE)
    {
        [self m_updateAddressTextFieldDataToContactData:range replacementString:@""];
    }
    // 檢查是否為電話
    else
    {
        [self m_updatePhoneTextFieldDataToContactData:range replacementString:@""];
    }
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( [delegate_ respondsToSelector:@selector(textFieldDidTextBeginEdittingAtIndexPath:)] == TRUE)
    {
       NSIndexPath *indexPath = [NSIndexPath indexPathForRow: self.tag inSection: self.cellTextField.tag] ;
        
        [delegate_ performSelector:@selector(textFieldDidTextBeginEdittingAtIndexPath:) withObject:indexPath];
       
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //NSLog(@"textFieldShouldEndEditing textField.tag:%d", textField.tag);
    return YES;
}

//click return key
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn textField.tag:%d", textField.tag);
    [textField resignFirstResponder];
    
    return YES;
}



-(NSNumber*) cellTextFieldLength;
{
    int length = cellTextField_.text.length;
    
    return [[[NSNumber alloc]initWithInt:length]autorelease];
}



-(void) m_updatePhoneTextFieldDataToContactData:(NSRange)range  replacementString:(NSString *)string;
{
    NSMutableString *updateNSstring = [[NSMutableString alloc]initWithString:self.cellTextField.text];
    [updateNSstring replaceCharactersInRange:range withString:string];
   
    //update phcurrrent rowonedata...
    HWPhoneData *updatePhoneData = [[HWPhoneData alloc]init];
    updatePhoneData.titleNSString = self.textLabel.text;
    updatePhoneData.phoneNumberValueNSString = updateNSstring;
    updatePhoneData.numKey   = self.tag;
    
    if( [ delegate_ respondsToSelector:@selector(notifyHWcontactViewShouldUpdateContacterPhoneData: withKey:)])
    {
        NSNumber *updateIdx = [[NSNumber alloc]initWithInt: self.tag ];
        
        [delegate_ performSelector:@selector(notifyHWcontactViewShouldUpdateContacterPhoneData: withKey:) withObject:updatePhoneData withObject: updateIdx];
        
        [updateIdx release];
    }
    [updatePhoneData release];
    [updateNSstring release];
}

-(void) m_updateAddressTextFieldDataToContactData:(NSRange)range  replacementString:(NSString *)string;
{
    NSMutableString *updateNSstring = [[NSMutableString alloc]initWithString:self.cellTextField.text];
    [updateNSstring replaceCharactersInRange:range withString:string];

    
    if( [ delegate_ respondsToSelector:@selector(notifyHWcontactViewShouldUpdateContacterAddressString: withKey:)])
    {
        NSNumber *updateIdx = [[NSNumber alloc]initWithInt: self.tag ];
        
        [delegate_ performSelector:@selector(notifyHWcontactViewShouldUpdateContacterAddressString: withKey:) withObject:updateNSstring withObject: updateIdx];
        
        [updateIdx release];
    }
    [updateNSstring release];
}

-(void) m_updateEmailTextFieldDataToContactData:(NSRange)range  replacementString:(NSString *)string;
{
    NSMutableString *updateNSstring = [[NSMutableString alloc]initWithString:self.cellTextField.text];
    [updateNSstring replaceCharactersInRange:range withString:string];

    if( [ delegate_ respondsToSelector:@selector(notifyHWcontactViewShouldUpdateContacterMailString: withKey:)])
    {
        NSNumber *updateIdx = [[NSNumber alloc]initWithInt: self.tag ];
        
        [delegate_ performSelector:@selector(notifyHWcontactViewShouldUpdateContacterMailString: withKey:) withObject:updateNSstring withObject: updateIdx];
        
        [updateIdx release];
    }
    [updateNSstring release];
}



@end
