//
//  SiSCollectionViewCell.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var imagePersonOutlet: UIImageView!
    
    internal func configure(participant: Participant) {
        myLabel.text = participant.name
        if let imgData = participant.image {
            imagePersonOutlet.image = UIImage(data: (imgData as Data?)!)
            imagePersonOutlet.layer.cornerRadius = imagePersonOutlet.frame.size.height / 2
            imagePersonOutlet.clipsToBounds = true
            imagePersonOutlet.layer.borderWidth = 1.0
        }
    }
    
}
