//
//  V8ViewController.m
//  V8SimpleBarGraph
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

#import "V8ViewController.h"

@interface V8ViewController ()
@property (nonatomic, strong) NSTimer *animationTimer;
@end

@implementation V8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.barValues = @[@4, @20, @5, @10, @23, @14, @7, @2, @0, @13];
	[self.graphView reloadData];
	self.graphView.backgroundColor = [UIColor lightGrayColor];
	self.graphView.selectedBarColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shuffleAndReload {
	NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.barValues];
	id last = [newArray lastObject];
	[newArray removeLastObject];
	[newArray insertObject:last atIndex:0];
	self.barValues = newArray;
	[self.graphView reloadData];
}

- (IBAction)animateButtonTapped:(id)sender {
	if (self.animationTimer) {
		// stop timer
		[self.animationTimer invalidate];
		self.animationTimer = nil;
		[self.animateButton setTitle:@"Animate" forState:UIControlStateNormal];
	} else {
		// start timer
		self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(shuffleAndReload) userInfo:nil repeats:YES];
		[self.animateButton setTitle:@"Stop" forState:UIControlStateNormal];
	}
}

- (IBAction)setSelectedIndexButtonTapped:(id)sender {
	[self.graphView selectIndex:1];
}

#pragma mark - DataSource Methods
- (NSUInteger)numberOfItemsInSimpleGraphView:(V8SimpleBarGraphView *)graphView {
	return [self.barValues count];
}

- (NSInteger)valueOfItemInSimpleGraphView:(V8SimpleBarGraphView *)graphView atIndex:(NSUInteger)index {
	if ([self.barValues count] > index) {
		return [[self.barValues objectAtIndex:index] integerValue];
	}
	return 0;
}

#pragma mark - Delegate Methods
/*
- (UIColor *)colorForBarInSimpleGraphView:(V8SimpleBarGraphView *)graphView atIndex:(NSUInteger)index {
	if (fmod(index, 2) != 0) {
		return [UIColor redColor];
	} else if(fmod(index, 3) != 0) {
		return [UIColor greenColor];
	} else if(fmod(index, 5) != 0) {
		return [UIColor blueColor];
	} else {
		return [UIColor grayColor];
	}
}
 */

- (void)simpleBarGraphView:(V8SimpleBarGraphView *)graphView didHoverOnIndex:(NSUInteger)index {
//	NSLog(@"Hover %d", index);
	self.indexLabel.text = [NSString stringWithFormat:@"Touching index: %d", index];
	CGPoint barCenter = [self.graphView centerOfBarAtIndex:index];
	CGFloat barHeight = [self.graphView heightForBarAtIndex:index];

	barCenter.x = barCenter.x + self.graphView.frame.origin.x;
	barCenter.y = barCenter.y + 10.0f;

	CGPoint labelCenter = CGPointMake(barCenter.x, barCenter.y - barHeight - 25.0f);
	self.valueLabel.center = labelCenter;
	self.valueLabel.text = [NSString stringWithFormat:@"%d", [[self.barValues objectAtIndex:index] integerValue]];

	[UIView animateWithDuration:0.1f animations:^{
		self.arrowLabel.alpha = 1.0f;
		self.arrowLabel.center = barCenter;
		self.valueLabel.alpha = 1.0f;
	}];
	[UIView animateWithDuration:0.3f delay:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.valueLabel.alpha = 0.0f;
	} completion:^(BOOL finished) {
	}];
}

@end
