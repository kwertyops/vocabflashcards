//
//  ViewController.m
//  vocabflashcards
//
//  Created by Andrew Thomas on 11/29/12.
//  Copyright (c) 2012 Andrew Hannum. All rights reserved.
//

#import "DeckViewController.h"
#import "MBProgressHUD.h"
#import "DeckManager.h"
#import "AppDelegate.h"

@interface DeckViewController ()

@end

@implementation DeckViewController

@synthesize revealBlock = _revealBlock;
@synthesize deckManager = _deckManager;
@synthesize flipped = _flipped;
@synthesize mainButton = _mainButton;
@synthesize checkButton = _checkButton;
@synthesize xButton = _xButton;
@synthesize wordLabel = _wordLabel;
@synthesize definitionLabel = _definitionLabel;
@synthesize percentageLabel = _percentageLabel;
@synthesize editButton = _editButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _deckManager = [appDelegate deckManager];
    
    if([[_deckManager currentDeck] objectForKey:@"title"] != nil)
    {
        self.title = [[_deckManager currentDeck] objectForKey:@"title"];
    }
    else
    {
        self.title = @"No Deck Selected";
        _wordLabel.text = @"Powered by Wiktionary!";
        _definitionLabel.text = @"Please forgive some broken or odd-looking definitions. We're parsing wikitext. :)";
        _percentageLabel.text = @"";
        _checkButton.enabled = NO;
        _xButton.enabled = NO;
        _mainButton.enabled = NO;
        _editButton.enabled = NO;
        
        _checkButton.alpha = 0;
        _xButton.alpha = 0;
        
        _flipped = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload
{
    if([[_deckManager currentDeck] objectForKey:@"title"] != nil)
    {
        self.title = [[_deckManager currentDeck] objectForKey:@"title"];
        
        _currentCard = [_deckManager nextCard];
                
        if(_currentCard != nil)
        {
            _wordLabel.text = [_currentCard objectForKey:@"name"];
            _definitionLabel.text = [_currentCard objectForKey:@"description"];
            _percentageLabel.text =  [NSString stringWithFormat:@"%@/%@", (NSNumber *)[_currentCard objectForKey:@"correct"], (NSNumber *)[_currentCard objectForKey:@"attempts"]];
            
            //Resize to text
            CGRect labelRect = _definitionLabel.bounds;            
            CGFloat fontSize = 30;
            while (fontSize > 0.0)
            {
                CGSize size = [_definitionLabel.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:fontSize] constrainedToSize:CGSizeMake(labelRect.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
                
                if (size.height <= labelRect.size.height) break;
                
                fontSize -= 1.0;
            }
            
            //set font size
            _definitionLabel.font = [UIFont fontWithName:@"Verdana" size:fontSize];
            
             
            _definitionLabel.alpha = 0;
            _percentageLabel.alpha = 0;
            _checkButton.enabled = NO;
            _xButton.enabled = NO;
            _mainButton.enabled = YES;
            _editButton.enabled = YES;
            
            _checkButton.alpha = 0;
            _xButton.alpha = 0;
            
            _flipped = NO;
        }
        else
        {
            _wordLabel.text = @"No Cards in Deck";
            _definitionLabel.text = @"Try adding some cards.";
            _definitionLabel.alpha = 1;
            _percentageLabel.alpha = 0;
            _checkButton.enabled = NO;
            _xButton.enabled = NO;
            _mainButton.enabled = NO;
            _editButton.enabled = YES;

            
            _checkButton.alpha = 0;
            _xButton.alpha = 0;
            
            _flipped = NO;
        }
        
    }
    else
    {
        self.title = @"No Deck Selected";
        _wordLabel.text = @"";
        _definitionLabel.text = @"";
        _percentageLabel.text = @"";
        _checkButton.enabled = NO;
        _xButton.enabled = NO;
        _mainButton.enabled = NO;
        _editButton.enabled = NO;
        
        _checkButton.alpha = 0;
        _xButton.alpha = 0;
        
        _flipped = NO;
    }
}

- (IBAction)mainButtonPressed:(id)sender {
    if(!_flipped)
    {
        
        _definitionLabel.alpha = 1;
        _percentageLabel.alpha = 1;
        _mainButton.enabled = NO;
        _checkButton.alpha = 1;
        _checkButton.enabled = YES;
        _xButton.alpha = 1;
        _xButton.enabled = YES;
        
        _flipped = YES;
    }
}

- (IBAction)checkButtonPressed:(id)sender {
        
    [_currentCard setValue:[NSNumber numberWithInt:[[_currentCard objectForKey:@"correct"] intValue] + 1] forKey:@"correct"];
    [_currentCard setValue:[NSNumber numberWithInt:[[_currentCard objectForKey:@"attempts"] intValue] + 1] forKey:@"attempts"];
    
    [self reload];
    
}

- (IBAction)xButtonPressed:(id)sender {
        
    [_currentCard setValue:[NSNumber numberWithInt:[[_currentCard objectForKey:@"attempts"] intValue] + 1] forKey:@"attempts"];
    [_deckManager gotOneWrong];
    
    [self reload];
    
}

- (void)setRevealBlock:(RevealBlock)revealBlock {
    _revealBlock = [revealBlock copy];
}

- (IBAction)revealSidebar:(id)sender {
    _revealBlock();
}
- (void)viewDidUnload {
    [self setMainButton:nil];
    [self setCheckButton:nil];
    [self setXButton:nil];
    [self setDefinitionLabel:nil];
    [self setWordLabel:nil];
    [self setPercentageLabel:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
}
@end
