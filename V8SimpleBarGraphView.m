//
//  V8SimpleBarGraphView.m
//  V8SimpleBarGraph
//
//  Created by Shawn Veader on 2/16/13.
//  Copyright (c) 2013 Shawn Veader. All rights reserved.
//

#import "V8SimpleBarGraphView.h"


@interface V8SimpleBarGraphView ()

@property (nonatomic, assign) NSInteger numberOfBars;
@property (nonatomic, strong) NSMutableArray *barValues;

@property (nonatomic, assign) NSInteger maxBarValue;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, assign) BOOL barCountDetermined;
@property (nonatomic, assign) BOOL defaultsHaveBeenSet;

@end


#pragma mark - Implementation
@implementation V8SimpleBarGraphView

#pragma mark - Init/Dealloc
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setDefaults];
    }
    return self;
}

- (void)dealloc {
	self.dataSource = nil;
	self.delegate = nil;
}


#pragma mark - LayoutSubViews
- (void)layoutSubviews {
	[super layoutSubviews];

	if (!self.barCountDetermined) {
		[self collectData];
	}
	[self determineBarWidth];

	// find or create subviews for each bar
	UIView *viewForIndex = nil;
	for (int i = 0; i < [self.barValues count]; i++) {
		viewForIndex = [self viewWithTag:[self tagForBarAtIndex:i]];
		if (!viewForIndex) {
			// bar should grow entire height, set height back to 0
			viewForIndex = [[UIView alloc] initWithFrame:[self defaultFrameForBarAtIndex:i]];
			[viewForIndex setTag:[self tagForBarAtIndex:i]];
			[self addSubview:viewForIndex];
		}
		viewForIndex.backgroundColor = [self getColorForBarAtIndex:i];
	}

	// now animate the bars to proper height
	[UIView animateWithDuration:0.2f
						  delay:0.1f
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 UIView *barView = nil;
						 CGRect newFrame = CGRectZero;
						 for (int i = 0; i < [self.barValues count]; i++) {
							 barView = [self viewWithTag:[self tagForBarAtIndex:i]];
							 if (barView) {
								 newFrame = [self frameForBarAtIndex:i];
								 [self logFrame:barView.frame withName:[NSString stringWithFormat:@"Bar:%i (current)", i]];
								 [self logFrame:newFrame withName:[NSString stringWithFormat:@"Bar:%i (new)", i]];
								 barView.frame = newFrame;
							 }
						 }
					 }
					 completion:^(BOOL finished){
					 }];
}


#pragma mark - Getters and Setters
- (void)setDataSource:(id)newDataSource {
	if (_dataSource != newDataSource) {
		_dataSource = newDataSource;
		[self collectData];
	}
}
 
- (void)setFrame:(CGRect)newFrame {
	if (!CGRectEqualToRect(self.frame, newFrame)) {
		// resize as necessary and "redraw"
		[self determineBarWidth];
		[self setNeedsDisplay];
	}
	[super setFrame:newFrame];
}


#pragma mark - Data Fetching Methods
- (void)reloadData {
	[self collectData];
}

- (void)collectData {
	if (!self.defaultsHaveBeenSet) {
		[self setDefaults];
	}
	self.barCountDetermined = NO;
	
	if (!self.barValues) {
		self.barValues = [NSMutableArray array];
	}
	
	[self getNumberOfBarsFromDataSource];
	[self getBarValuesFromDataSource];
	[self determineMaximumBarValue];
	
	self.barCountDetermined = YES;
	[self setNeedsLayout];
}

// return the tag for the bar at a given index
- (NSInteger)tagForBarAtIndex:(NSInteger)index {
	return ((index + 1) * 10) + 13;
}

- (void)setDefaults {
	self.numberOfBars = 0;
	self.maxBarValue = 0;
	self.barWidth = 0.0f;
	self.barValues = [NSMutableArray array];
	
	self.barCountDetermined = NO;
	self.defaultsHaveBeenSet = YES;
	
	self.paddingBetweenBars = 2.0f;
	self.paddingTop = 5.0f;
	self.paddingBottom = 5.0f;
	self.paddingLeft = 5.0f;
	self.paddingBottom = 5.0f;
	
	self.barColor = [UIColor grayColor];
	self.selectedBarColor = [UIColor redColor];

	self.defaultsHaveBeenSet = YES;
}

#pragma mark - Data Source Methods
- (void)getNumberOfBarsFromDataSource {
	if (self.dataSource) {
		self.numberOfBars = [self.dataSource numberOfItemsInSimpleGraphView:self];
	} else {
		self.numberOfBars = 0;
	}
}

- (void)getBarValuesFromDataSource {
	if (self.dataSource) {
		[self.barValues removeAllObjects];
		for (int i = 0; i < self.numberOfBars; i++) {
			NSInteger barValue = [self.dataSource valueOfItemInSimpleGraphView:self atIndex:i];
			[self.barValues addObject:[NSNumber numberWithInteger:barValue]];
		}
	}
}

#pragma mark - Delegate Methods
- (UIColor *)getColorForBarAtIndex:(NSUInteger)index {
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorForBarInSimpleGraphView:atIndex:)]) {
		return [self.delegate colorForBarInSimpleGraphView:self atIndex:index];
	}
	return self.barColor;
}

#pragma mark - Calculation Methods
- (void)determineMaximumBarValue {
	if ([self.barValues count] > 0) {
		self.maxBarValue = [[self.barValues valueForKeyPath:@"@max.integerValue"] integerValue];
	} else {
		self.maxBarValue = 0;
	}

//	NSArray *sortedArray = [self.barValues sortedArrayUsingComparator:^(id obj1, id obj2) {
//		// barValues should be an array of NSNumbers
//		if ([obj1 integerValue] > [obj2 integerValue]) {
//			return (NSComparisonResult)NSOrderedDescending;
//		}
//		if ([obj1 integerValue] < [obj2 integerValue]) {
//			return (NSComparisonResult)NSOrderedAscending;
//		}
//		return (NSComparisonResult)NSOrderedSame;
//	}];
//	self.maxBarValue = [(NSNumber *)[sortedArray lastObject] integerValue];
}

- (void)determineBarWidth {
	if (self.numberOfBars > 0) {
		CGFloat spaceBetweenBars = (self.numberOfBars - 1) * self.paddingBetweenBars;
		CGFloat padding = self.paddingLeft + self.paddingRight;
		self.barWidth = floor((self.bounds.size.width - padding - spaceBetweenBars) / self.numberOfBars);
	} else {
		self.barWidth = 0.0f;
	}
}

- (CGFloat)heightForItemAtIndex:(NSUInteger)index {
	if ([self.barValues count] > index && self.maxBarValue > 0) {
		NSInteger value = [[self.barValues objectAtIndex:index] integerValue];
		CGFloat percentage = (float)value / (float)self.maxBarValue;
		CGFloat padding = self.paddingTop + self.paddingBottom;
		return floor((self.bounds.size.height - padding) * percentage);
	} else {
		return 0.0f;
	}
}

- (CGRect)frameForBarAtIndex:(NSUInteger)index {
	CGFloat height = [self heightForItemAtIndex:index];
	CGFloat y = self.bounds.size.height - self.paddingBottom - height;
	return CGRectMake([self xOriginForBarAtIndex:index], y, self.barWidth, height);
}

- (CGRect)defaultFrameForBarAtIndex:(NSUInteger)index {
	return CGRectMake([self xOriginForBarAtIndex:index], self.bounds.size.height - self.paddingBottom, self.barWidth, 0.0f);
}

- (CGFloat)xOriginForBarAtIndex:(NSUInteger)index {
	return (self.barWidth * index) + (self.paddingBetweenBars * index) + self.paddingLeft;
}

- (void)logFrame:(CGRect)barFrame withName:(NSString *)name {
	NSLog(@"Frame (%@) x:%f y:%f w:%f h:%f",
		  name, barFrame.origin.x, barFrame.origin.y, barFrame.size.width, barFrame.size.height);
}

@end
