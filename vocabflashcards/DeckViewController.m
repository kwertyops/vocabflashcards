//
//  ViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/29/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "DeckViewController.h"
#import "MBProgressHUD.h"
#import "DBManager.h"

@interface DeckViewController ()

@end

@implementation DeckViewController

@synthesize revealBlock = _revealBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRevealBlock:(RevealBlock)revealBlock {
    _revealBlock = [revealBlock copy];
}

- (IBAction)revealSidebar:(id)sender {
    _revealBlock();
}
@end
