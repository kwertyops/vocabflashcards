//
//  PrettyNavigationController.m
//  whosplaying
//
//  Created by Andrew Thomas on 11/13/12.
//  Copyright (c) 2012 GitRHub. All rights reserved.
//

#import "PrettyNavigationController.h"
#import "PrettyNavigationBar.h"

@interface PrettyNavigationController ()

@end

@implementation PrettyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    [self setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    [self pushViewController:rootViewController animated:NO];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
