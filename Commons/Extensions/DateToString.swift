//
//  DateToString.swift
//  Commons
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public extension Date {
    func toStringWithFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

public extension Optional where Wrapped == Date {
  func toStringWithFormat(_ format: String) -> String? {
    guard let date = self else {
        return nil
    }
    return date.toStringWithFormat(format)
  }
}
