//
//  ThingsCell.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

protocol ThingsCellDelegate: class {
    func thingCell(didPressItemNumber: Int, isAccept: Bool)
}

class ThingsCell: UITableViewCell {
    
    weak var delegate: ThingsCellDelegate?
    
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell (_ title: String, tag: Int) {
    
        self.title.text = title
        self.tag = tag
    }
    
    @IBAction func handleButtonPress(sender: UIButton) {
        let isAccept = sender.tag == 1 ? false : true
        self.delegate?.thingCell(didPressItemNumber: self.tag, isAccept: isAccept)
    }
}
