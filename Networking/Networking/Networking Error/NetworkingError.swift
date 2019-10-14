//
//  NetworkingError.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public enum NetworkingError: Error, Equatable {
    case couldNotBuildURL
    case invalidResponse
    case decodingError
    case clientError(String)
    case serverError(String)
    case other(String)
}

extension NetworkingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .couldNotBuildURL:
            return "Could not build propper URL"
        case .invalidResponse:
            return "Could not get propper response"
        case .decodingError:
            return "Could not decode data"
        case .clientError(let error):
            return "Could not reach API successfully! Error: \(error)"
        case .serverError(let error):
            return "Server couldn't process request. Error: \(error)"
        case .other(let error):
            return "Could not identify the error! Error: \(error) ☹️"
        }
    }
}
