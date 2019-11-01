//
//  TodayInteractor.swift
//  NBC
//
//  Created by Aaron Huánuco on 21/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import Commons
import Valuation

final class TodayInteractor {
    let todayProvider: TodayProviderProtocol
    let timer: TimerProtocol
    init(todayProvider: TodayProviderProtocol, timer: TimerProtocol) {
        self.todayProvider = todayProvider
        self.timer = timer
    }
}

extension TodayInteractor: TodayInteractorProtocol {
    func retrieveTodayData(completion: @escaping (Result<Valuation, BCError>) -> Void) {
        timer.schedule(timeInterval: Constants.todayCallPeriod, repeats: true) { [weak self] in
            self?.todayProvider.retrieveTodayData(currency: Constants.currency, completion: completion)
        }
        timer.fire()
    }
    
    func stopRetreavingTodayData() {
        timer.invalidate()
    }
}

extension TodayInteractor  {
    private enum Constants {
        static let currency: Currency = Currency.euro
        static let todayCallPeriod: TimeInterval = 10
    }
}
