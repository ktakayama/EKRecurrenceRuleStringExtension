//
//  RecurrenceRuleFromStringTests.swift
//  EKRecurrenceRuleStringExtension
//
//  Created by Takayama Kyosuke on 2016/04/04.
//  Copyright © 2016年 aill inc. All rights reserved.
//

import XCTest
import EventKit
@testable import EKRecurrenceRuleStringExtension

class RecurrenceRuleFromStringTests: XCTestCase {

    func __testRecurrenceRulePattern(ruleString: String) {
       let recurrenceRule = EKRecurrenceRule.recurrenceRuleFromString(ruleString)!
       XCTAssertEqual(recurrenceRule.stringForICalendar(), ruleString)
    }

    func testRecurrenceRulesWeekly() {
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=WEEKLY;INTERVAL=2;BYDAY=TU,SU;WKST=SU")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=WEEKLY;INTERVAL=1;COUNT=3;BYDAY=SU,MO")
    }

    func testRecurrenceRulesMonthly() {
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=13;BYDAY=FR")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=MONTHLY;INTERVAL=18;BYMONTHDAY=10,11,12,13,14,15")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=1,-1")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=MONTHLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-2")
    }

    func testRecurrenceRulesYearly() {
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=YEARLY;INTERVAL=1;BYDAY=20MO")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=YEARLY;INTERVAL=1;BYMONTH=6,7,8;BYDAY=TH")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=YEARLY;INTERVAL=3;BYYEARDAY=1,100,200")
       __testRecurrenceRulePattern(ruleString: "RRULE FREQ=YEARLY;INTERVAL=1;BYWEEKNO=20;BYDAY=MO")
    }

}
