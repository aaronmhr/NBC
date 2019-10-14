//
//  DateToString.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

extension Date {
    func toStringWithFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
