//
//  CurrentDataRepository.swift
//  N26BC
//
//  Created by Aaron Huánuco on 15/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation

protocol CurrentDataRepository {
    func getCurrentData(url: URL?, completion: @escaping (Result<CurrentResponseModel, ShowableError>) -> Void)
}
