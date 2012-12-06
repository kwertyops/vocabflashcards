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

- (IBAction)revealSidebar:(id)sender;
- (void)reloadTitle;

@end
