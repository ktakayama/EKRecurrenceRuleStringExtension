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

   public class func recurrenceRuleFromString(_ ruleString: String) -> EKRecurrenceRule? {
      let parser = RecurrenceParser(ruleString: NSString(string: ruleString))

      guard let type = parser.type else {
         return nil
      }

      return self.init(recurrenceWith:type,
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
      let intervalArray = self.ruleString.components(separatedBy: "INTERVAL=")

      if intervalArray.count > 1 {
         if let intervalString = intervalArray.last?.components(separatedBy: ";").first {
            return Int(intervalString) ?? 1
         }
      }

      return 1
   }

   var type: EKRecurrenceFrequency? {
      if self.ruleString.contains("FREQ=DAILY") {
         return .daily
      } else if self.ruleString.contains("FREQ=WEEKLY") {
         return .weekly
      } else if self.ruleString.contains("FREQ=MONTHLY") {
         return .monthly
      } else if self.ruleString.contains("FREQ=YEARLY") {
         return .yearly
      } else {
         return nil
      }
   }

   var end: EKRecurrenceEnd? {
      let untilArray = self.ruleString.components(separatedBy: "UNTIL=")

      if untilArray.count > 1 {
         if let recurrenceEndDateString = untilArray.last!.components(separatedBy: ";").first {
            let recurrenceDateFormatter = DateFormatter()
            recurrenceDateFormatter.locale = Locale(identifier:"US")
            recurrenceDateFormatter.timeZone = TimeZone(identifier:"UTC")
            recurrenceDateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            if let recurrenceEndDate = recurrenceDateFormatter.date(from: recurrenceEndDateString) {
               return EKRecurrenceEnd(end:recurrenceEndDate)
            }
         }
      } else {
         if let count = (processRegexp("COUNT=([\\d,-]*)") as [NSNumber]?)?.first {
            return EKRecurrenceEnd(occurrenceCount:count.intValue)
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
            weekNumber = Int(byday.substring(with: NSRange(location:0, length:byday.length-2))) ?? -1
            week = byday.substring(with: NSRange(location:byday.length-2, length:2)) as NSString
         }

         var dofw: EKWeekday?

         switch week {
            case "MO": dofw = .monday
            case "TU": dofw = .tuesday
            case "WE": dofw = .wednesday
            case "TH": dofw = .thursday
            case "FR": dofw = .friday
            case "SA": dofw = .saturday
            case "SU": dofw = .sunday
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

   fileprivate func processRegexp(_ regexString: String) -> [NSString]? {
      let reg = try? NSRegularExpression(pattern:regexString, options:.caseInsensitive)
      if let match = reg?.firstMatch(in: String(self.ruleString),
                                           options:.reportProgress,
                                           range:NSRange(location:0, length:self.ruleString.length)) {
         return self.ruleString.substring(with: match.rangeAt(1)).components(separatedBy: ",") as [NSString]?
      }
      return nil
   }

   fileprivate func processRegexp(_ regexString: String) -> [NSNumber]? {
      guard let results: [NSString] = processRegexp(regexString) else {
         return nil
      }
      return results.map { NSNumber(value: $0.intValue) }
   }

}
