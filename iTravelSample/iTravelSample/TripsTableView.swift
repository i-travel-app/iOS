//
//  TripsTableView.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 26.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class TripsTableView: UITableView {

    override func draw(_ rect: CGRect) {
        self.layer.borderColor = Constants.blueColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        self.separatorColor = Constants.blueColor
    }

}
