//
//  ListViewController.swift
//  N26BC
//
//  Created by Aaron Huánuco on 13/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    var presenter: ListPresenterProtocol!
}

extension ListViewController: ListViewProtocol { }
