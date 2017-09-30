//
//  ThingsCellGeneric.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

protocol ThingsCellGenericDelegate: class {
    func thingCell(didPressItemNumber: Int, isAccept: Bool)
}

class ThingsCellGeneric: UITableViewCell {
    
    weak var delegate: ThingsCellGenericDelegate?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell (_ title: String, tag: Int, acceptSymbol: Bool, delSymbol: Bool) {
        
        self.title.text = title.capitalized
        self.tag = tag
        acceptBtn.isHidden = !acceptSymbol
        delBtn.isHidden = !delSymbol
    }
    
    @IBAction func handleButtonPress(sender: UIButton) {
        let isAccept = sender.tag == 1 ? false : true
        self.delegate?.thingCell(didPressItemNumber: self.tag, isAccept: isAccept)
    }
}
