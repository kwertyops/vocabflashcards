//
//  ViewController.h
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/29/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

typedef void (^RevealBlock)();

@interface DeckViewController : UIViewController

@property (strong, nonatomic) RevealBlock revealBlock;

- (IBAction)revealSidebar:(id)sender;

@end
