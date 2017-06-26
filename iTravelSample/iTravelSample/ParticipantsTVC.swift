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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openParticipantDetailVC))
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.rightBarButtonItem = addButton

       self.participants = CoreDataStack().getAllParticipantsFromDB()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Переходы по контроллерам
    
    func back() {
        let alert = UIAlertController(title: "Данные не будут сохранены", message: "В случае выхода из этого меню, Ваши данные не сохранятся! Выберите участников поездки и нажмите кнопку \"Сохранить\".", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { (action) ->
            Void in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: nil))
        
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func openParticipantDetailVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantDetailsVC") as! ParticipantDetailsVC
        self.navigationController!.pushViewController(VC, animated: true)
    }

}
