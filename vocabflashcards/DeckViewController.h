//
//  ViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/29/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "DeckManager.h"

typedef void (^RevealBlock)();

@interface DeckViewController : UIViewController

@property (strong, nonatomic) RevealBlock revealBlock;
@property (strong, nonatomic) DeckManager *deckManager;

@property (strong, nonatomic) NSDictionary *currentCard;

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@property (nonatomic) BOOL flipped;

- (IBAction)revealSidebar:(id)sender;
- (void)reload;

- (IBAction)mainButtonPressed:(id)sender;
- (IBAction)checkButtonPressed:(id)sender;
- (IBAction)xButtonPressed:(id)sender;

@end
