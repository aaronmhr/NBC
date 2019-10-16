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

public final class DefaultTimer: TimerProtocol {
    private(set) weak var timer: Timer?
    
    public func schedule(timeInterval: TimerProtocol.TimeInterval, repeats: Bool, completionBlock: @escaping CompletionBlock) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) {
          (timer) -> Void in
          completionBlock()
        }
    }
    
    public func invalidate() {
        timer?.invalidate()
    }
}
