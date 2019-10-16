//
//  TimerProtocol.swift
//  Commons
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public protocol TimerProtocol {
    typealias TimeInterval = Foundation.TimeInterval
    typealias CompletionBlock = () -> Void
    
    func schedule(timeInterval: TimeInterval, repeats: Bool, completionBlock: @escaping CompletionBlock)
    func invalidate()
}
