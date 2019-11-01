//
//  Storyboard-Helper.swift
//  NBC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

protocol StoryboardInstantiator { }

extension StoryboardInstantiator {
    public static func defaultViewController<T: UIViewController>(for type: T.Type) -> T {
        let viewControllerName = String(describing: type)
        let storyboardName = viewControllerName.replacingOccurrences(of: "ViewController", with: "")
        let storyaboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyaboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Failed to instantiate \(viewControllerName)")
        }
        return viewController
    }
}
