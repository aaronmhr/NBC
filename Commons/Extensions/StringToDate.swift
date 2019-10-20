//
//  StringToDate.swift
//  Commons
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public extension String {
    func toDateWithFormat(_ formatter: DateFormatter) -> Date? {
        let date = formatter.date(from: self)
        return date
    }
}

public extension Optional where Wrapped == String {
  func toDateWithFormat(_ formatter: DateFormatter) -> Date? {
    guard let string = self else {
        return nil
    }
    return string.toDateWithFormat(formatter)
  }
}
