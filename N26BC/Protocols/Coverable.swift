//
//  Coverable.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

protocol Coverable: class {
    func addFullScreenLoadingView()
    func removeFullScreenLoadingView()
}

extension Coverable where Self: UIViewController {
    func addFullScreenLoadingView() -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.alpha = 0.3
        view.tag = Constants.loadingTag
        return view
    }
    
    func removeFullScreenLoadingView() {
        guard let view = self.view.subviews.first(where: { $0.tag == Constants.loadingTag } ) else { return }
        view.removeFromSuperview()
    }
}

private enum Constants {
    static let loadingTag = 101
}
