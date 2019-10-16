//
//  StringToDate.swift
//  Commons
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public extension String {
    func toDateWithFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

public extension Optional where Wrapped == String {
  func toDateWithFormat(_ format: String) -> Date? {
    guard let string = self else {
        return nil
    }
    return string.toDateWithFormat(format)
  }
}
