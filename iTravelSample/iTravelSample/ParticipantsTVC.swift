//
//  ParticipantsTVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 23.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ParticipantsTVC: UITableViewController {
    
    var participants = [Participant]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Участники поездки"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addButton

       self.participants = CoreDataStack.instance.getAllParticipantsFromDB()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.isEmpty ? 1 : self.participants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if participants.isEmpty {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = "Здесь отображаются все участники Ваших поездок.\nК сожалению, у Вас нет ни одного участника.\nДобавьте первого, нажав на плюс в верхнем углу экрана."
        } else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        }
        return cell
    }

}
