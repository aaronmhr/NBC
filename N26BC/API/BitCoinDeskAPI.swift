//
//  BitCoinDeskAPI.swift
//  Valuation
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public enum BitcoinDeskAPI {
    public static let defaultDateFormat = "yyyy-MM-dd"
    public static let todayResponseDateFormat = #"yyyy-MM-dd'T'HH:mm:ss+00:00"#
    
    public static let historicalFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = defaultDateFormat
        return formatter
    }()
    
    public static let todayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = todayResponseDateFormat
        return formatter
    }()
    
    case today(Currency)
    case historical(HistoricalQuery)
    
    public var url: URL? {
        switch self {
        case .today(let currency):
            return todayURL(currency: currency)
        case .historical(let queries):
            return historicalURL(queries: queries)
        }
    }
    
    private func todayURL(currency: Currency) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.path = String(format: Constants.todayPath, currency.currencyPath)
        return components.url
    }
    
    private func historicalURL(queries: HistoricalQuery) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.path = Constants.historicalPath
        components.queryItems = queries.makeQueryItems()
        return components.url
    }
}

extension BitcoinDeskAPI {
    private enum Constants {
        static let scheme = "https"
        static let baseURL = "api.coindesk.com"
        static let todayPath = "/v1/bpi/currentprice%@.json"
        static let historicalPath = "/v1/bpi/historical/close.json"
    }
    
    public struct HistoricalQuery {
        public let start: Date
        public let end: Date
        public let currency: Currency
        
        private let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = Constants.dateFormat
            return formatter
        }()
        
        public init(start: Date, end: Date, currency: Currency) {
            self.start = start
            self.end = end
            self.currency = currency
        }
        
        func makeQueryItems() -> [URLQueryItem] {
            let startQuery = URLQueryItem(name: Constants.start, value: formatter.string(from: start))
            let endQuery = URLQueryItem(name: Constants.end, value: formatter.string(from: end))
            let currencyQuery = URLQueryItem(name: Constants.currency, value: currency.rawValue)
            
            return [startQuery, endQuery, currencyQuery]
        }
        
        private enum Constants {
            static let dateFormat = "yyyy-MM-dd"
            static let start = "start"
            static let end = "end"
            static let currency = "currency"
        }
    }
}

fileprivate extension Currency {
    var currencyPath: String {
        switch self {
        case .euro, .dollar, .pound:
            return "/" + self.rawValue
        case .unknown:
            return self.rawValue
        }
    }
}
