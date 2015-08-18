//
//  IdeaViewController.h
//  Expandable
//
//  Created by Dean Thibault on 8/18/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tableArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UITableView *attachedTable;

@property (strong, nonatomic) IBOutlet UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITextView *activeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DescriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentsTableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;


@end
