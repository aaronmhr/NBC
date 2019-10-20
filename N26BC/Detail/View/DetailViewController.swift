//
//  DetailViewController.swift
//  N26BC
//
//  Created by Aaron Huánuco on 20/10/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailViewController: DetailViewProtocol {

}
