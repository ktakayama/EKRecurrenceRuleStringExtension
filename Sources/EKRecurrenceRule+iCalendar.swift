//
//  EKRecurrenceRule+iCalendar.swift
//  EKRecurrenceRuleStringExtension
//
//  Created by Takayama Kyosuke on 2016/04/04.
//  Copyright © 2016年 aill inc. All rights reserved.
//

import Foundation
import EventKit

public extension EKRecurrenceRule {

    public func stringForICalendar() -> String {
        let ret = self.description
        return "RRULE " + ret.componentsSeparatedByString(" RRULE ")[1]
    }

}
