//
//  DefaultTimer.swift
//  Commons
//
//  Created by Aaron Huánuco on 16/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

public final class DefaultTimer: TimerProtocol {
    private(set) weak var timer: Timer?
    
    public init() { }
    
    public func schedule(timeInterval: TimeInterval, repeats: Bool, completionBlock: @escaping CompletionBlock) {
        self.timer?.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats) {
            (timer) -> Void in
            DispatchQueue.global(qos: .background).async {
                completionBlock()
            }
        }
        self.timer = timer
    }
    
    public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    public func fire() {
        timer?.fire()
    }
    
    deinit {
        invalidate()
    }
}
