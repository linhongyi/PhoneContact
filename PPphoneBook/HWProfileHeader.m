//
//  ProfileHeader.m
//  ProfileView
//
//  Created by Ajay Chainani on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HWProfileHeader.h"
#import "UIView+position.h"
#import <QuartzCore/QuartzCore.h>
#import "PPContactDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation HWProfileHeader

@synthesize ppContactDetailViewControllerRef = ppContactDetailViewControllerRef_;
@synthesize imgURL        = imageURL_;
@synthesize imageLabel    = imageLabel_;
@synthesize nameTextField = nameTextField_;
@synthesize nameLabel     = nameLabel_;
@synthesize imageView     = imageView_;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        imageView_	= [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, self.frame.size.width/4,  self.frame.size.height-20)];
        imageView_.backgroundColor = [UIColor whiteColor];
        imageView_.contentMode =UIViewContentModeScaleAspectFill;
       
        imageView_.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imageView_.layer.borderWidth = 1;
        imageView_.layer.masksToBounds = YES;
         [self addSubview:imageView_];
        
        //image text
        imageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView_.bounds.size.height * 0.8, imageView_.bounds.size.width, imageView_.bounds.size.height / 5)];
        imageLabel_.text = @"Edit";
        imageLabel_.textAlignment = NSTextAlignmentCenter;
        imageLabel_.textColor = [ UIColor whiteColor];
        imageLabel_.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        
        //name ( uiTabel )
        nameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(20+imageView_.frameX+imageView_.frameWidth, imageView_.frameY, 320-(30+imageView_.frameX+imageView_.frameWidth), imageView_.frameWidth)];
               nameLabel_.font = [UIFont boldSystemFontOfSize:20];
        nameLabel_.shadowColor = [UIColor whiteColor];
        nameLabel_.shadowOffset = CGSizeMake(0, 1);
        nameLabel_.backgroundColor = [UIColor clearColor];
        
        //set nameTableView_(編輯時候使用)
        nameTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(20+imageView_.frameX+imageView_.frameWidth, imageView_.frameY, 320-(30+imageView_.frameX+imageView_.frameWidth), imageView_.frameWidth) style: UITableViewStyleGrouped];
        
        
        //set nameTextField(編輯時候使用)
        //CGRect textFieldRect = CGRectMake(83.0f, 10.0f, 100.0f, 20.0f);
        nameTextField_ = [[UITextField alloc]init];
        nameTextField_.userInteractionEnabled = TRUE;
        nameTextField_.returnKeyType = UIReturnKeyDone;
        nameTextField_.delegate = self;
        nameTextField_.placeholder = @"姓名";
        
       
    }
    return self;
}

-(void) dealloc
{
    [imageURL_ release];
    [imageLabel_ release];
    [nameTextField_ release];
    [nameLabel_ release];
    [imageView_ release];
    [nameTableView_ release];
    [super dealloc];
}


-(void) showBrowseContact
{
 
     // 移除編輯時的文字區 , 加入檢視時候的 name label
    [nameTableView_ removeFromSuperview];
    [imageLabel_ removeFromSuperview];
    [self addSubview:nameLabel_];
    
}

-(void) showAddPeopleContact
{
    //handle image
    imageView_.image = [UIImage imageNamed:@"NoName.jpg"];
    [imageView_ addSubview:imageLabel_];
    
    
    //移除檢視時候的 label , 加入編輯時的文字區
    nameTableView_.dataSource = self;
    [nameLabel_ removeFromSuperview];
    [self addSubview: nameTableView_];
}

// 顯示編輯人頁面
-(void) showEditContact
{
    [imageView_ addSubview:imageLabel_];

    
    //移除檢視時候的 label , 加入編輯時的文字區
    nameTableView_.dataSource = self;
    [nameLabel_ removeFromSuperview];
    [self addSubview: nameTableView_];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}

//load image by asserts library url
-(void) loadImageFromAsserURL: (NSURL * )assertURL
{
    
    // no assertUrl , so add default image;
    if( assertURL == Nil)
    {
        [imageView_ setImage: [UIImage imageNamed:@"NoName.jpg"]];
        return ;
    }
    
    ALAssetsLibrary *library = [[[ALAssetsLibrary alloc]init]autorelease];
    
    
    ALAssetsLibraryAssetForURLResultBlock result = ^(ALAsset *__strong asset)
    {
        ALAssetRepresentation * assetRepresentation = [asset defaultRepresentation];
        
        CGImageRef cgImage = [assetRepresentation CGImageWithOptions:nil];
        
        if( cgImage )
        {
            imageView_.image = [UIImage imageWithCGImage:cgImage];
        }
    };

    ALAssetsLibraryAccessFailureBlock failure =^(NSError *__strong error)
    {
        NSLog(@"Error retrieving asset from url: %@",[ error localizedFailureReason ]);
    };
    
    [library assetForURL: assertURL
             resultBlock:result failureBlock:failure];
}

// 顯示點選圖像view
-(void)showImagePickControllerView
{
     // create imagePickController
     UIImagePickerController *imagePickController = [[[UIImagePickerController alloc]init]autorelease];
     
     //You can use isSourceTypeAvailable to check
     if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary ] == TRUE )
     {
         imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
     }
     
     else if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum ] == TRUE )
     {
         imagePickController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
     }
     else if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ] == TRUE )
     {
         imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
     }
    
    imagePickController.delegate= self;
    imagePickController.allowsEditing=NO;
    
    [self.ppContactDetailViewControllerRef presentViewController:imagePickController animated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier]autorelease];
        
        UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width/4), 0, 1, cell.contentView.bounds.size.height)]autorelease];
        
        lineView.backgroundColor = [UIColor lightGrayColor];
        
        [cell.contentView addSubview:lineView];

    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.textLabel.text =@"姓名";


    CGRect textFieldRect = CGRectMake((cell.bounds.size.width/4)+5, cell.center.y/2, cell.bounds.size.width/4, cell.bounds.size.height);
    self.nameTextField.frame = textFieldRect;
    
    [cell.contentView addSubview: self.nameTextField];
  
    return cell;
}

#pragma UiActionSheet

-(void) wakeImgSettingActionSheet
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc]
                                  initWithTitle:@"圖像選擇" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Choose Another Graph" otherButtonTitles: @"Discard The Graph",nil]autorelease];
   
    
    [actionSheet showInView: self.ppContactDetailViewControllerRef.tableView ];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // click delete account
    if( buttonIndex == 0)
    {
        [self showImagePickControllerView];
    }
    else if( buttonIndex == 1)
    {
        self.imgURL = nil;
        [imageView_ setImage: [UIImage imageNamed:@"NoName.jpg"]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   // do nothing
}

#pragma mark UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        // Do something with an image from the camera
    } else {
        // Do something with an image from another source
        
         //self.imageView.image= [info objectForKey:UIImagePickerControllerOriginalImage];
        
         self.imgURL = [info objectForKey: UIImagePickerControllerReferenceURL];
        
         [self loadImageFromAsserURL: self.imgURL];
        
         [picker dismissViewControllerAnimated: NO completion: Nil];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated: YES completion: Nil];
}

#pragma mark UITextField Delegate Method
//click return key
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}


// handle text editing...
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // add word
    if( string.length > 0)
    {
        self.ppContactDetailViewControllerRef.saveButton.enabled = YES;
    }
    else
    {
        if( textField.text.length > 1 )
            self.ppContactDetailViewControllerRef.saveButton.enabled = YES;
        else
            self.ppContactDetailViewControllerRef.saveButton.enabled = NO;
    }
    return TRUE;
}
@end
