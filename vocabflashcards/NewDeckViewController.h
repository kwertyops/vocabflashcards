//
//  NewDeckViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/30/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDeckViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)createPressed:(id)sender;

@end
