//
//  SHCTimeIntervalFormatterTest.m
//  SHCTimeIntervalFormatter
//
//  Created by pawelc on 22/04/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SHCTimeIntervalFormatter.h"

@interface SHCTimeIntervalFormatterTest : XCTestCase

@property (nonatomic, strong) SHCTimeIntervalFormatter *formatter;

@end

@implementation SHCTimeIntervalFormatterTest

- (void)setUp {
    [super setUp];
	
	self.formatter = [SHCTimeIntervalFormatter new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testStylesWithIntervalAboveHour {
	NSString *componentsSeparator = self.formatter.componentsSeparator;
	
	// above an hour interval
	NSTimeInterval interval = 3665;

	self.formatter.style = SHCTimeIntervalFormatterNumericDynamicHoursStyle;
	NSString *expected = [NSString stringWithFormat:@"1%@01%@05", componentsSeparator, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);

	self.formatter.style = SHCTimeIntervalFormatterNumericHMSStyle;
	expected = [NSString stringWithFormat:@"1%@01%@05", componentsSeparator, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);

	self.formatter.style = SHCTimeIntervalFormatterNumericMSStyle;
	expected = [NSString stringWithFormat:@"61%@05", componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
	
	self.formatter.style = SHCTimeIntervalFormatterNumericSStyle;
	expected = [NSString stringWithFormat:@"3665"];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
}

- (void)testStylesWithIntervalBelowHour {
	NSString *componentsSeparator = self.formatter.componentsSeparator;

	// below an hour interval
	NSTimeInterval interval = 3555;
	
	self.formatter.style = SHCTimeIntervalFormatterNumericDynamicHoursStyle;
	NSString *expected = [NSString stringWithFormat:@"59%@15", componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
	
	self.formatter.style = SHCTimeIntervalFormatterNumericHMSStyle;
	expected = [NSString stringWithFormat:@"0%@59%@15", componentsSeparator, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
	
	self.formatter.style = SHCTimeIntervalFormatterNumericMSStyle;
	expected = [NSString stringWithFormat:@"59%@15", componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
	
	self.formatter.style = SHCTimeIntervalFormatterNumericSStyle;
	expected = [NSString stringWithFormat:@"3555"];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);

}

- (void)testComponentsSeparator {
	// prepare
	self.formatter.style = SHCTimeIntervalFormatterNumericHMSStyle;
	
	NSString *componentsSeparator = self.formatter.componentsSeparator;
	
	NSTimeInterval interval = 3665;
	NSString *expected = [NSString stringWithFormat:@"1%@01%@05", componentsSeparator, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
	
	componentsSeparator = @"#";
	self.formatter.componentsSeparator = componentsSeparator;
	expected = [NSString stringWithFormat:@"1%@01%@05", componentsSeparator, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval]);
	
	// reset
	self.formatter.componentsSeparator = nil;
}

- (void)testInfinitySymbol {
	
	NSString *infinitySymbol = self.formatter.infinityString;
	XCTAssertEqualObjects(infinitySymbol, [self.formatter stringFromTimeInterval:INFINITY]);
	
	infinitySymbol = @"~~";
	self.formatter.infinityString = infinitySymbol;
	XCTAssertEqualObjects(infinitySymbol, [self.formatter stringFromTimeInterval:INFINITY]);
	
	// reset
	self.formatter.infinityString = nil;
}

- (void)testMinusSignSymbol {
	// prepare
	self.formatter.style = SHCTimeIntervalFormatterNumericMSStyle;
	self.formatter.useLeadingZerosForMinutes = YES;
	
	NSString *minusSignSymbol = self.formatter.minusSign;
	NSString *componentsSeparator = self.formatter.componentsSeparator;
	
	NSTimeInterval interval = -1.0;
	NSString *expected = [NSString stringWithFormat:@"%@00%@01", minusSignSymbol, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval] );

	minusSignSymbol = @"__";
	self.formatter.minusSign = minusSignSymbol;
	expected = [NSString stringWithFormat:@"%@00%@01", minusSignSymbol, componentsSeparator];
	XCTAssertEqualObjects(expected, [self.formatter stringFromTimeInterval:interval] );
	
	// reset
	self.formatter.minusSign = nil;
}

@end
