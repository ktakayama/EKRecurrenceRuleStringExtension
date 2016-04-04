# EKRecurrenceRuleStringExtension

<a href="https://travis-ci.org/ktakayama/EKRecurrenceRuleStringExtension"><img src="https://travis-ci.org/ktakayama/EKRecurrenceRuleStringExtension.svg?branch=master" alt="Build status" /></a>
<a href="https://raw.githubusercontent.com/ktakayama/EKRecurrenceRuleStringExtension/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>

## Usage

### recurrenceRuleFromString

You can create EKRecurrenceRule object from iCalendar fromat.

```swift
let recurrenceRule = EKRecurrenceRule.recurrenceRuleFromString("RRULE FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=13;BYDAY=FR")
```

### stringForICalendar

```swift
let recurrenceRule = EKRecurrenceRule.recurrenceRuleFromString("RRULE FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=13;BYDAY=FR")
print(recurrenceRule?.stringForICalendar())
// => RRULE FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=13;BYDAY=FR
```
