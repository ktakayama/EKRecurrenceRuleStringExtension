
import Foundation
import EventKit
import EKRecurrenceRuleStringExtension

let ruleString = "RRULE FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=13;BYDAY=FR"

let recurrenceRule = EKRecurrenceRule.recurrenceRuleFromString(ruleString)
recurrenceRule?.stringForICalendar()
