//
//  ProfileHeader.h
//  ProfileView
//
//  Created by Ajay Chainani on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// modify by hongyi
// purpose: it manages all contact table headview.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class PPContactDetailViewController;

@interface HWProfileHeader : UIView <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>{
	UITableView *nameTableView_;
}
// review mode
-(void) showBrowseContact;
// add people mode
-(void) showAddPeopleContact;
// edit mode
-(void) showEditContact;
// set image by nsurl
-(void) loadImageFromAsserURL: (NSURL * )assertURL;
// show imagePickController
-(void) showImagePickControllerView;
-(void) wakeImgSettingActionSheet;



@property (nonatomic,assign) PPContactDetailViewController* ppContactDetailViewControllerRef;
@property (nonatomic, retain)   NSURL       *imgURL;
@property (nonatomic, retain)   UIImageView *imageView;
@property (nonatomic, readonly) UITextField *nameTextField;
@property (nonatomic, retain)   UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *imageLabel;
@end
