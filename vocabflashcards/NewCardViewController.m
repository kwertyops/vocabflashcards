//
//  NewCardViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 12/5/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "NewCardViewController.h"
#import "InsertCardViewController.h"

@interface NewCardViewController ()

@end

@implementation NewCardViewController

@synthesize wordFromDict = _wordFromDict;
@synthesize wordText = _wordText;
@synthesize defText = _defText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _wordText.text = [_wordFromDict objectForKey:@"name"];
    
    _defText.text = [_wordFromDict objectForKey:@"description"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCardPressed:(id)sender {
    
    InsertCardViewController *icvc = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"InsertCardViewController"];
    
    icvc.cardToInsert = _wordFromDict;
    
    [[self navigationController] pushViewController:icvc animated:YES];
    
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
