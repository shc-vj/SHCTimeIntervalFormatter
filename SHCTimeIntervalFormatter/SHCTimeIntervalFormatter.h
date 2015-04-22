//
//  SHCTimeIntervalFormatter.h
//  pl.metasprint.servicetest
//
//  Created by pawelc on 02/04/15.
//  Copyright (c) 2015 Metasprint. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SHCTimeIntervalFormatterDefaultSeparator;	// = @":"
extern NSString * const SHCTimeIntervalFormatterDefaultMinusSign;	// = @"-"
extern NSString * const SHCTimeIntervalFormatterDefaultInfinityString; // @"--:--"

typedef NS_ENUM(NSInteger, SHCTimeIntervalFormatterStyle) {
	/// style with empty string
	SHCTimeIntervalFormatterNoStyle = 0,
	/**
	 Dynamic style, use only a needed components
	 For the time intervals below an hour use minutes:seconds format, above an hour hours:minutes:seconds
	 */
	SHCTimeIntervalFormatterNumericDynamicHoursStyle,
	/// style with hours:minutes:seconds
	SHCTimeIntervalFormatterNumericHMSStyle,
	/// style with minutes:seconds
	SHCTimeIntervalFormatterNumericMSStyle,
	/// style with only seconds
	SHCTimeIntervalFormatterNumericSStyle
};

/**
 SHCTimeIntervalFormatter is formatter (and only formatter, not parser) for time intervals from NSTimeInterval
 */
@interface SHCTimeIntervalFormatter : NSFormatter

/**
 Default is NO
 */
@property (nonatomic, assign) BOOL allowMiliseconds;

/**
 Used as a separator between hours,minutes,seconds
 Default is SHCTimeIntervalFormatterDefaultSeparator (@":")
 */
@property (nonatomic, copy) NSString *componentsSeparator;


/**
 String used as a minus sign (for negative time intervals)
 Default is SHCTimeIntervalFormatterDefaultMinusSign (@"-")
 */
@property (nonatomic, copy) NSString *minusSign;

/**
 Value used for representing infinity (to be precise value for which `fpclassify` returns FP_INFINITE)
 Default is SHCTimeIntervalFormatterDefaultInfinityString (@"--:--")
 */
@property (nonatomic, copy) NSString *infinityString;

/**
 Formatting style
 Default is SHCTimeIntervalFormatterNumericDynamicHoursStyle
 */
@property (nonatomic, assign) SHCTimeIntervalFormatterStyle style;

/**
 Use or not a leading zeroes for minutes component for intervals below an hour
 Apply to:
 * SHCTimeIntervalFormatterNumericDynamicHoursStyle
 * SHCTimeIntervalFormatterNumericMSStyle
 
 Default is NO
 */
@property (nonatomic, assign) BOOL useLeadingZeroesForMinutes;

/**
 Convinience method using default parameters of SHCTimeIntervalFormatter
 
 @param ti	NSTimeInterval to convert
 @return		String representation of NSTimeInterval
 */
+ (NSString*)stringFromTimeInterval:(NSTimeInterval)ti;

/**
 Convinience method using a specified style and defaults of other parameters
 
 @param ti    NSTimeInterval to convert
 @param style Style to use
 
 @return		String representation of NSTimeInterval
 */
+ (NSString*)stringFromTimeInterval:(NSTimeInterval)ti style:(SHCTimeIntervalFormatterStyle)style;

/**
 @param ti NSTimeInterval to convert
 @return  String representation of NSTimeInterval
 */
- (NSString*)stringFromTimeInterval:(NSTimeInterval)ti;

// @name NSFormatter overrides

/**
 @discussion SHCTimeIntervalFormatter currently only implements formatting, not parsing. Until it implements parsing, this will always return NO.
 */
- (BOOL)getObjectValue:(out id *)obj forString:(NSString *)string errorDescription:(out NSString **)error;


@end
