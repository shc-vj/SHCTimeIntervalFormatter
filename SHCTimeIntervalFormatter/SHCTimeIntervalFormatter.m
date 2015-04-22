//
//  SHCTimeIntervalFormatter.m
//  pl.metasprint.servicetest
//
//  Created by pawelc on 02/04/15.
//  Copyright (c) 2015 Metasprint. All rights reserved.
//

#import "SHCTimeIntervalFormatter.h"

NSString * const SHCTimeIntervalFormatterDefaultMinusSign      = @"-";
NSString * const SHCTimeIntervalFormatterDefaultSeparator      = @":";
NSString * const SHCTimeIntervalFormatterDefaultInfinityString = @"--:--";

@implementation SHCTimeIntervalFormatter

+ (NSString*)stringFromTimeInterval:(NSTimeInterval)ti
{
	return [[self new] stringFromTimeInterval:ti];
}

+ (NSString*)stringFromTimeInterval:(NSTimeInterval)ti style:(SHCTimeIntervalFormatterStyle)style;
{
	SHCTimeIntervalFormatter *formatter = [self new];
	formatter.style = style;
	
	return [formatter stringFromTimeInterval:ti];
}

- (instancetype)init
{
	self = [super init];
	if( self ) {
        _style                     = SHCTimeIntervalFormatterNumericDynamicHoursStyle;
        _allowMiliseconds          = NO;
        _useLeadingZerosForMinutes = NO;
        _componentsSeparator       = SHCTimeIntervalFormatterDefaultSeparator;
        _minusSign                 = SHCTimeIntervalFormatterDefaultMinusSign;
        _infinityString            = SHCTimeIntervalFormatterDefaultInfinityString;
	}
	
	return self;
}

- (NSString*)stringFromTimeInterval:(NSTimeInterval)ti
{
	return [self stringForObjectValue:@(ti)];
}

- (void)setInfinityString:(NSString *)infinityString
{
	if( nil == infinityString ) {
		_infinityString = SHCTimeIntervalFormatterDefaultInfinityString;
	} else {
		_infinityString = [infinityString copy];
	}
}

- (void)setMinusSign:(NSString *)minusSign
{
	if( nil == minusSign ) {
		_minusSign = SHCTimeIntervalFormatterDefaultMinusSign;
	} else {
		_minusSign = [minusSign copy];
	}
}

- (void)setComponentsSeparator:(NSString *)componentsSeparator
{
	if( nil == componentsSeparator ) {
		_componentsSeparator = SHCTimeIntervalFormatterDefaultSeparator;
	} else {
		_componentsSeparator = [componentsSeparator copy];
	}
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if( self ) {
        _style                     = [aDecoder decodeIntegerForKey:@"style"];
        _allowMiliseconds          = [aDecoder decodeBoolForKey:@"allowMiliseconds"];
        _useLeadingZerosForMinutes = [aDecoder decodeBoolForKey:@"useLeadingZerosForMinutes"];
        _componentsSeparator       = [aDecoder decodeObjectForKey:@"componentsSeparator"];
		if( nil == _componentsSeparator ) {
			_componentsSeparator = SHCTimeIntervalFormatterDefaultSeparator;
		}
		_minusSign	= [aDecoder decodeObjectForKey:@"minusSign"];
		if( nil == _minusSign ) {
			_minusSign = SHCTimeIntervalFormatterDefaultMinusSign;
		}
		_infinityString = [aDecoder decodeObjectForKey:@"infnityString"];
		if( nil == _infinityString ) {
			_infinityString = SHCTimeIntervalFormatterDefaultInfinityString;
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	
	[aCoder encodeInteger:_style forKey:@"style"];
	[aCoder encodeBool:_allowMiliseconds forKey:@"allowMiliseconds"];
	[aCoder encodeBool:_useLeadingZerosForMinutes forKey:@"useLeadingZerosForMinutes"];
	if( _componentsSeparator != SHCTimeIntervalFormatterDefaultSeparator ) {
		[aCoder encodeObject:_componentsSeparator forKey:@"componentsSeparator"];
	}
	if( _minusSign != SHCTimeIntervalFormatterDefaultMinusSign ) {
		[aCoder encodeObject:_minusSign forKey:@"minusSign"];
	}
	if( _infinityString != SHCTimeIntervalFormatterDefaultInfinityString ) {
		[aCoder encodeObject:_infinityString forKey:@"infnityString"];
	}
}

#pragma mark - NSFormatter overrides

- (NSString*)stringForObjectValue:(id)obj
{
	// object can be NSNumber only
	if( ![obj isKindOfClass:[NSNumber class]] ) {
		return nil;
	}
	
	if( _style != SHCTimeIntervalFormatterNoStyle ) {
		
		// simply calculate units
		double timeIntervalAsDouble = [obj doubleValue];
		if( fpclassify(timeIntervalAsDouble) == FP_INFINITE ) {
			// for infinity use special value
			return self.infinityString;
		}
		
		double timeIntervalAbsolute = fabs(timeIntervalAsDouble);
		
		long hours = 0, minutes=0;
		double seconds=0.0;
		
		switch (_style) {
			case SHCTimeIntervalFormatterNumericHMSStyle:
			case SHCTimeIntervalFormatterNumericDynamicHoursStyle:
				hours = timeIntervalAbsolute / (60*60);
				minutes = (timeIntervalAbsolute - (hours * (60*60))) / (60);
				seconds = timeIntervalAbsolute - (hours * (60*60) + minutes * (60));
				break;
				
			case SHCTimeIntervalFormatterNumericMSStyle:
				minutes = timeIntervalAbsolute / (60);
				seconds = timeIntervalAbsolute - (minutes * (60));
				break;
				
			case SHCTimeIntervalFormatterNumericSStyle:
				seconds = timeIntervalAbsolute;
				break;
						   
			default:
				// unsupported styles
				return @"";
		}
		
		if( !_allowMiliseconds ) {
			seconds = round( seconds );
		}

        static NSString * const integerLeadingZerosFormat    = @"%02ld%@";
        static NSString * const integerFormat                = @"%ld%@";
        static NSString * const secondsFormat                = @"%02.0f";
        static NSString * const secondsWithMilisecondsFormat = @"%06.3f";
		
		NSMutableString *buffer = [NSMutableString string];
		NSString *format;

		if( timeIntervalAsDouble < 0 ) {
			[buffer appendString:_minusSign];
		}

		// format hours
		if( _style == SHCTimeIntervalFormatterNumericHMSStyle ||
		   (_style==SHCTimeIntervalFormatterNumericDynamicHoursStyle && hours > 0 ) ) {
			[buffer appendFormat:integerFormat, hours, _componentsSeparator];
		}
		
		// format minutes
		switch( _style ) {
			case SHCTimeIntervalFormatterNumericHMSStyle:
				format = integerLeadingZerosFormat;
				break;
				
			case SHCTimeIntervalFormatterNumericDynamicHoursStyle:
				if (hours > 0) {
					format = integerLeadingZerosFormat;
					break;
				} else {
					// follow default
				}
				
			default:
				format = (_useLeadingZerosForMinutes == YES) ?  integerLeadingZerosFormat : integerFormat;
		}
		
		if( _style != SHCTimeIntervalFormatterNumericSStyle ) {
			[buffer appendFormat:format, minutes, _componentsSeparator];
		}
		
		// format seconds
		format = (_allowMiliseconds == YES) ? secondsWithMilisecondsFormat : secondsFormat;

		[buffer appendFormat:format, seconds];
		
		return [buffer copy];
	}
		
	// no style, empty string
	return @"";
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
	return NO;
}


@end
