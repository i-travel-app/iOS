//
//  ParticipantTVCell.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 26.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ParticipantTVCell: UITableViewCell {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var img: UIImageViewX!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func configure(participant: Participant) {
        name.text = participant.name
        age.text = String(participant.age)
        gender.text = participant.isMan ? "Мужской" : "Женский"
        
        let imageData = participant.image! as Data
        img.image = UIImage(data: imageData)
    }

}
