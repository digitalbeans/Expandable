//
//  IdeaViewController.m
//  Expandable
//
//  Created by Dean Thibault on 8/18/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "IdeaViewController.h"

@interface IdeaViewController ()

@end

@implementation IdeaViewController

@synthesize tableArray;
@synthesize scrollView, contentView;
@synthesize titleField, descriptionView, attachedTable;
@synthesize activeField, activeView;
@synthesize DescriptionHeightConstraint, attachmentsTableHeightConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.tableArray = [NSMutableArray array];
	
	self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	self.navigationItem.leftItemsSupplementBackButton = true;

	[self registerForKeyboardNotifications];

	UILongPressGestureRecognizer *lpg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	[self.attachedTable addGestureRecognizer:lpg];

	[self updateTableSize:attachedTable];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.attachedTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer;
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		attachedTable.editing = !attachedTable.editing;
	}
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(keyboardWasShown:)
            name:UIKeyboardDidShowNotification object:nil];
 
   [[NSNotificationCenter defaultCenter] addObserver:self
             selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification object:nil];
 
}
 
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	if (activeField) {
		NSDictionary* info = [aNotification userInfo];
		CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	 
		UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
		self.scrollView.contentInset = contentInsets;
		self.scrollView.scrollIndicatorInsets = contentInsets;
	 
		// If active text field is hidden by keyboard, scroll it so it's visible
		// Your app might not need or want this behavior.
		CGRect aRect = self.view.frame;
		aRect.size.height -= kbRect.size.height;
		if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
			[self.scrollView scrollRectToVisible:activeField.frame animated:YES];
		}
	}
	else if (activeView) {
		NSDictionary* info = [aNotification userInfo];
		CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	 
		UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
		self.scrollView.contentInset = contentInsets;
		self.scrollView.scrollIndicatorInsets = contentInsets;
	 
		// If active text field is hidden by keyboard, scroll it so it's visible
		// Your app might not need or want this behavior.
		CGRect aRect = self.view.frame;
		aRect.size.height -= kbRect.size.height;
		if (!CGRectContainsPoint(aRect, self.activeView.frame.origin) ) {
			[self.scrollView scrollRectToVisible:activeView.frame animated:YES];
		}
	}
}
 
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

- (BOOL)textViewShouldReturn:(UITextView *)textView
{
	[textView resignFirstResponder];
	
	return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
	if (descriptionView.contentSize.height >= 106) {
		DescriptionHeightConstraint.constant = descriptionView.contentSize.height;
	} else {
		DescriptionHeightConstraint.constant = 106;
	}
	[scrollView layoutIfNeeded];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.activeField = textField;
	self.activeView = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	self.activeField = nil;
	
	if (textField == titleField){
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"IdeaUpdateNotification" object:nil];
	

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	self.activeView = textView;
	self.activeField = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	self.activeView = nil;
	
	if (textView == descriptionView) {
	}

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
		return [self.tableArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaAttachmentTableCell" forIndexPath:indexPath];
	
	
	[cell.textLabel setText:[self.tableArray objectAtIndex:indexPath.row]];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[self.tableArray removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if (self.tableArray.count == 0) {
    		tableView.editing = NO;
		}
		[self updateTableSize:attachedTable];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void) updateTableSize: (UITableView *)table
{
	CGFloat maxHeight;
	
	CGSize size = table.contentSize;
	// Calculate the minimum size to contain our text
	CGSize maxSize = CGSizeMake(size.width, MAXFLOAT);
	CGSize newSize = [table sizeThatFits:maxSize];
	
	maxHeight = MAX(200.0, newSize.height);
	maxHeight = MAX(maxHeight, [table sizeThatFits:maxSize].height);
	
	attachmentsTableHeightConstraint.constant = maxHeight;
}

- (IBAction)doAddItem:(id)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Item", nil) message: nil preferredStyle:UIAlertControllerStyleAlert];
	
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	}];
	
	UIAlertAction *cancelAction = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                      style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction *action)
                    {
                      NSLog(@"Cancel action");
                    }];
	[alertController addAction:cancelAction];
	
	UIAlertAction *okAction = [UIAlertAction
	  actionWithTitle:NSLocalizedString(@"OK", @"OK action")
	  style:UIAlertActionStyleDefault
	  handler:^(UIAlertAction *action)
	  {
		UITextField *item = alertController.textFields.firstObject;
		[self.tableArray addObject:[item text]];
		[self.attachedTable reloadData];
		[self updateTableSize:attachedTable];
	  }];
	  [alertController addAction:okAction];
	  [self presentViewController:alertController animated:YES completion:nil];
}


@end
