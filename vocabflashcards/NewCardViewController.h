//
//  NewCardViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 12/5/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCardViewController : UIViewController<UITextViewDelegate>

@property (nonatomic) NSDictionary *wordFromDict;

@property (weak, nonatomic) IBOutlet UITextView *wordText;
@property (weak, nonatomic) IBOutlet UITextView *defText;

- (IBAction)addCardPressed:(id)sender;

@end
