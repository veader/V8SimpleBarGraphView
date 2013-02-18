//
//  V8ViewController.m
//  V8SimpleBarGraph
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

#import "V8ViewController.h"

@interface V8ViewController ()
@end

@implementation V8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.barValues = @[@4, @20, @5, @10, @23, @14, @7, @2, @0, @13];
	[self.graphView reloadData];
	self.graphView.backgroundColor = [UIColor lightGrayColor];

	[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(shuffleAndReload) userInfo:nil repeats:YES];
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

@end
