# SHCTimeIntervalFormatter
NSFormatter subclass converting NSTimeInterval values into strings

## Methods
Convinience methods using a default parameters

`+ (NSString*)stringFromTimeInterval:(NSTimeInterval)ti;`

`+ (NSString*)stringFromTimeInterval:(NSTimeInterval)ti style:(SHCTimeIntervalFormatterStyle)style;`

`- (NSString*)stringFromTimeInterval:(NSTimeInterval)ti;`


## Properties

`style` - possible values are:
- `SHCTimeIntervalFormatterNumericDynamicHoursStyle` - hours are displayed only for time intervals above an hour
- `SHCTimeIntervalFormatterNumericHMSStyle` - hours always displayed ex. '1:52:15'
- `SHCTimeIntervalFormatterNumericMSStyle` - hours never displayed, minutes can be greater than 59 ex. '112:15'
-	`SHCTimeIntervalFormatterNumericSStyle` - display only seconds ex. '6735'-	

`allowMiliseconds` - display or not miliseconds parts of `NSTimeInterval`, if set to `NO` (default) specified time interval is rounded to a nearest integer count of seconds

`useLeadingZerosForMinutes` -  use or not a leading zeros for minutes component for intervals below an hour.
 </br>Apply to:
 * `SHCTimeIntervalFormatterNumericDynamicHoursStyle`
 * `SHCTimeIntervalFormatterNumericMSStyle`

`componentsSeparator`, `minusSign`, `infinityString` - set as you need respectively:
- string used as a component separator, default is ':' character
- string used as a minus sign for a negative time intervals
- string used to represent *inifinite* time interval value (to be precise: time interval is treated as *infinite* if the `fpclassify()` function returns `FP_INFINITE`)

