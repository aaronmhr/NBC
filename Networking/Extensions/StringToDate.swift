//
//  StringToDate.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
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
