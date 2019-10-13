//
//  APIServiceError.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public enum APIServiceError: Error, Equatable {
    case apiError(String)
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodingError
}

public extension APIServiceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .apiError:
            return "Could not reach API successfully"
        case .invalidEndpoint:
            return "Could not build propper URL"
        case .invalidResponse:
            return "Could not get propper response"
        case .noData:
            return "Could not find data"
        case .decodingError:
            return "Could not decode data"
        }
    }
}
