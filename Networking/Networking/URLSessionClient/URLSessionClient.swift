//
//  URLSessionClient.swift
//  Networking
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public final class URLSessionClient: URLSessionClientProtocol {
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder
    
    public init(session: URLSessionProtocol, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    public func fetchResources<T: Decodable>(url: URL?, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        session.makeRequest(for: url) { result in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.decoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(.apiError(error.localizedDescription)))
            }
        }.resume()
    }
}
