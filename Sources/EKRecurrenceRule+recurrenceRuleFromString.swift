//
//  EKRecurrenceRule+recurrenceRuleFromString.swift
//  EKRecurrenceRuleStringExtension
//
//  Created by Takayama Kyosuke on 2016/04/04.
//  Copyright © 2016年 aill inc. All rights reserved.
//

import Foundation
import EventKit

public extension EKRecurrenceRule {

   public class func recurrenceRuleFromString(ruleString: String) -> EKRecurrenceRule? {
      let parser = RecurrenceParser(ruleString: NSString(string: ruleString))

      guard let type = parser.type else {
         return nil
      }

      return self.init(recurrenceWithFrequency:type,
         interval:parser.interval,
         daysOfTheWeek:parser.days,
         daysOfTheMonth:parser.monthDays,
         monthsOfTheYear:parser.months,
         weeksOfTheYear:parser.weeksOfTheYear,
         daysOfTheYear:parser.daysOfTheYear,
         setPositions:parser.setPositions,
         end:parser.end)
   }

}

struct RecurrenceParser {

   let ruleString: NSString

   var interval: Int {
      let intervalArray = self.ruleString.componentsSeparatedByString("INTERVAL=")

      if intervalArray.count > 1 {
         if let intervalString = intervalArray.last?.componentsSeparatedByString(";").first {
            return Int(intervalString) ?? 1
         }
      }

      return 1
   }

   var type: EKRecurrenceFrequency? {
      if self.ruleString.containsString("FREQ=DAILY") {
         return .Daily
      } else if self.ruleString.containsString("FREQ=WEEKLY") {
         return .Weekly
      } else if self.ruleString.containsString("FREQ=MONTHLY") {
         return .Monthly
      } else if self.ruleString.containsString("FREQ=YEARLY") {
         return .Yearly
      } else {
         print("[RRULE] invalid format: %", self.ruleString)
         return nil
      }
   }

   var end: EKRecurrenceEnd? {
      let untilArray = self.ruleString.componentsSeparatedByString("UNTIL=")

      if untilArray.count > 1 {
         if let recurrenceEndDateString = untilArray.last!.componentsSeparatedByString(";").first {
            let recurrenceDateFormatter = NSDateFormatter()
            recurrenceDateFormatter.locale = NSLocale(localeIdentifier:"US")
            recurrenceDateFormatter.timeZone = NSTimeZone(name:"UTC")
            recurrenceDateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            if let recurrenceEndDate = recurrenceDateFormatter.dateFromString(recurrenceEndDateString) {
               return EKRecurrenceEnd(endDate:recurrenceEndDate)
            }
         }
      } else {
         if let count = (processRegexp("COUNT=([\\d,-]*)") as [NSNumber]?)?.first {
            return EKRecurrenceEnd(occurrenceCount:count.integerValue)
         }
      }

      return nil
   }

   // BYDAY => days
   var days: [EKRecurrenceDayOfWeek]? {
      guard let bydays: [NSString] = processRegexp("BYDAY=([\\w,]*)") else {
         return nil
      }

      var days = [EKRecurrenceDayOfWeek]()

      for byday in bydays {
         var week = byday
         var weekNumber = -1

         if byday.length > 2 {
            weekNumber = Int(byday.substringWithRange(NSRange(location:0, length:byday.length-2))) ?? -1
            week = byday.substringWithRange(NSRange(location:byday.length-2, length:2))
         }

         var dofw: EKWeekday?

         switch week {
            case "MO": dofw = .Monday
            case "TU": dofw = .Tuesday
            case "WE": dofw = .Wednesday
            case "TH": dofw = .Thursday
            case "FR": dofw = .Friday
            case "SA": dofw = .Saturday
            case "SU": dofw = .Sunday
            default: dofw = nil
         }

         if let _dofw = dofw {
            let dow = weekNumber > 0 ? EKRecurrenceDayOfWeek(dayOfTheWeek:_dofw, weekNumber:weekNumber) : EKRecurrenceDayOfWeek(_dofw)
            days.append(dow)
         }
      }

      return days
   }

   // BYMONTHDAY => monthDays
   var monthDays: [NSNumber]? {
      return processRegexp("BYMONTHDAY=([\\d,-]*)")
   }

   // BYMONTH => months
   var months: [NSNumber]? {
      return processRegexp("BYMONTH=([\\d,]*)")
   }

   // BYWEEKNO => weeksOfTheYear
   var weeksOfTheYear: [NSNumber]? {
      return processRegexp("BYWEEKNO=([\\d,-]*)")
   }

   // BYYEARDAY => daysOfTheYear
   var daysOfTheYear: [NSNumber]? {
      return processRegexp("BYYEARDAY=([\\d,-]*)")
   }

   // BYSETPOS => setPositions
   var setPositions: [NSNumber]? {
      return processRegexp("BYSETPOS=([\\d,-]*)")
   }

   private func processRegexp(regexString: String) -> [NSString]? {
      let reg = try? NSRegularExpression(pattern:regexString, options:.CaseInsensitive)
      if let match = reg?.firstMatchInString(String(self.ruleString),
                                           options:.ReportProgress,
                                           range:NSRange(location:0, length:self.ruleString.length)) {
         return self.ruleString.substringWithRange(match.rangeAtIndex(1)).componentsSeparatedByString(",")
      }
      return nil
   }

   private func processRegexp(regexString: String) -> [NSNumber]? {
      guard let results: [NSString] = processRegexp(regexString) else {
         return nil
      }
      return results.map { Int($0.intValue) }
   }

}
