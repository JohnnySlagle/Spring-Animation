//
//  MTZViewController.m
//  SpringAnimation
//
//  Created by Matt Zanchelli on 3/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"

#import "MTZSpringAnimationParametersViewController.h"

#import "MTZSpringAnimationTranslateViewController.h"
#import "MTZSpringAnimationRotateViewController.h"

@interface MTZViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

/// The view controller housing the parameters of a spring animation.
@property (strong, nonatomic) MTZSpringAnimationParametersViewController *parametersVC;

/// The view controller housing the animations.
@property (strong, nonatomic) MTZSpringAnimationViewerController *animationsVC;

/// The subview for the animations view.
@property (weak, nonatomic) IBOutlet UIView *animationsView;

/// The subview for the parameters view.
@property (weak, nonatomic) IBOutlet UIView *parametersView;

/// The subview for the playback controls.
@property (weak, nonatomic) IBOutlet UIView *playBackControls;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
	btn.frame = CGRectMake(0, 0, 100, 40);
	btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
	[btn setTitle:@"Translate" forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	[btn addTarget:self action:@selector(didTapTitle:) forControlEvents:UIControlEventTouchUpInside];
	
	UINavigationItem *item = [[UINavigationItem alloc] init];
	item.titleView = btn;
	self.navigationBar.items = @[item];
	
	// Create parameters view controller.
	self.parametersVC = [[MTZSpringAnimationParametersViewController alloc] initWithNibName:@"MTZSpringAnimationParametersViewController" bundle:nil];
	// Add it to the appropriate container view.
	[self.parametersView addSubview:self.parametersVC.view];
	
	// Create animations view controller.
	self.animationsVC = [[MTZSpringAnimationTranslateViewController alloc] initWithNibName:@"MTZSpringAnimationTranslateViewController" bundle:nil];
//	self.animationsVC = [[MTZSpringAnimationRotateViewController alloc] initWithNibName:@"MTZSpringAnimationRotateViewController" bundle:nil];
	// Add it to the appropriate container view.
	[self.animationsView addSubview:self.animationsVC.view];
}

- (void)didTapTitle:(id)sender
{
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Choose an animation." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Translate", @"Rotate", nil];
	[as showFromRect:self.navigationBar.frame inView:self.view animated:YES];
}

// When the animate/play button is tapped.
- (IBAction)animate:(id)sender
{
	// Tell the animations view controller to animate based on the parameters.
	[self.animationsVC animateWithDuration:self.parametersVC.duration
					usingSpringWithDamping:self.parametersVC.dampingRatio
					 initialSpringVelocity:self.parametersVC.velocity];
	
	[self resetProgress];
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(resetProgress)
											   object:nil];
	
	// Animate the progress of the animation at the same rate.
	[UIView animateWithDuration:self.parametersVC.duration
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
					 animations:^{
						 [self.progressView setProgress:1.0f animated:YES];
					 }
					 completion:^(BOOL finished) {}];
	
	// Reset the progress view after the completion of the animation.
	[self performSelector:@selector(resetProgress)
			   withObject:nil
			   afterDelay:self.parametersVC.duration + TIME_TO_WAIT_AFTER_ANIMATION];
}

- (void)resetProgress
{
	[self.progressView setProgress:0.0f animated:NO];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

@end
