//
//  NewDeckViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "NewDeckViewController.h"
#import "AppDelegate.h"

@interface NewDeckViewController ()

@end

@implementation NewDeckViewController

@synthesize textField = _textField;

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createPressed:(id)sender
{

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.deckManager newDeck:[_textField text]];
    [appDelegate.menuController reinit];
    [self.navigationController popViewControllerAnimated:YES];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

@end
