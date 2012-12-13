//
//  GHMenuViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 1/3/12.
//  Copyright (c) 2012 Greg Haines. All rights reserved.
//

#import "GHMenuViewController.h"
#import "GHMenuCell.h"
#import "GHRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NewDeckViewController.h"
#import "PrettyNavigationController.h"
#import "DeckManager.h"


#pragma mark -
#pragma mark Implementation
@implementation GHMenuViewController

@synthesize deckManager = _deckManager;

#pragma mark Memory Management
- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC 
					  withSearchBar:(UISearchBar *)searchBar 
						withHeaders:(NSArray *)headers 
					withControllers:(NSArray *)controllers {
	if (self = [super initWithNibName:nil bundle:nil]) {
		_sidebarVC = sidebarVC;
		_searchBar = searchBar;
		_headers = headers;
		_controllers = controllers;
		
		_sidebarVC.sidebarViewController = self;
		_sidebarVC.contentViewController = _controllers[0][0];
	}
	return self;
}

-(void)reinit
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    _deckManager = [appDelegate deckManager];

    NSArray *allDecks = [_deckManager allDecks];
    
    NSMutableArray *cellInfos = [[NSMutableArray alloc] init];
    
    cellInfos[0] = [[NSMutableArray alloc] init];
    cellInfos[1] = [[NSMutableArray alloc] init];
    
    cellInfos[0][0] = [[NSMutableDictionary alloc] init];
    cellInfos[0][0][kSidebarCellImageKey] = [UIImage imageNamed:@"plus.png"];
    cellInfos[0][0][kSidebarCellTextKey] = NSLocalizedString(@"New Deck", @"");
    
    cellInfos[1][0] = [[NSMutableDictionary alloc] init];
    
    int i = 0;
	
    for(NSDictionary *deck in allDecks)
    {        
        cellInfos[1][i] = [[NSMutableDictionary alloc] init];
        cellInfos[1][i][kSidebarCellImageKey] = [UIImage imageNamed:@"deck_icon.png"];
        cellInfos[1][i][kSidebarCellTextKey] = NSLocalizedString([deck objectForKey:@"title"], @"");
        i++;
    }
    
    _cellInfos = (NSArray *)cellInfos;
    
    [_menuTableView reloadData];
    
    if([_deckManager indexForCurrentDeck] != -1)
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_deckManager indexForCurrentDeck] inSection:1] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

#pragma mark UIViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:_searchBar];
	
	_menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds) - 44.0f) 
												  style:UITableViewStylePlain];
	_menuTableView.delegate = self;
	_menuTableView.dataSource = self;
	_menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_menuTableView.backgroundColor = [UIColor clearColor];
	_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_menuTableView];
}

- (void)viewWillAppear:(BOOL)animated {
	self.view.frame = CGRectMake(0.0f, 0.0f,kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	[_searchBar sizeToFit];
    if([_deckManager indexForCurrentDeck] != -1)
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:[_deckManager indexForCurrentDeck] inSection:1] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
		? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		: YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_cellInfos[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GHMenuCell";
    GHMenuCell *cell = (GHMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = info[kSidebarCellTextKey];
	cell.imageView.image = info[kSidebarCellImageKey];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (_headers[section] == [NSNull null]) ? 0.0f : 21.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
			(id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
			(id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
		];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    if(indexPath.section == 0)
    {
            
        NewDeckViewController *dest = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"NewDeckViewController"];
            
        [appDelegate.deckView.navigationController pushViewController:dest animated:NO];
            
        [_sidebarVC toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
        
    }
    if(indexPath.section == 1)
    {
        [[appDelegate deckManager] setCurrentDeck:[[[appDelegate deckManager] allDecks] objectAtIndex:indexPath.row]];
        
        //[(DeckViewController *)[(UINavigationController *)[_sidebarVC contentViewController] visibleViewController] reload];
        
        [_sidebarVC toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];

    }
    
    
}

#pragma mark Public Methods
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
	[_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
	if (scrollPosition == UITableViewScrollPositionNone) {
		[_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
	}
}

@end
