//
//  ParticipantsTVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 23.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

protocol ParticipantsTVCDelegate {
    func checkedParticipants(context: NSManagedObjectContext, array: [Participant])
}

class ParticipantsTVC: UITableViewController {
    
    // MARK: - Properties -
    lazy var participants = [Participant]()
    lazy var checkedParticipants = [Participant]()
    lazy var temp = [Participant]()
    lazy var coreData = CoreDataStack.instance
    var participantToDelete: Participant?
    var delegate: ParticipantsTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Участники поездки"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openParticipantCreationVC))
        // check how much views un stack and should we show Back button
        if let viewControllers = navigationController?.viewControllers {
            //print(viewControllers.count)
            if viewControllers.count > 1 {
                let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
                self.navigationItem.setLeftBarButtonItems([newBackButton], animated: true)
            }
        }
        
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        tableView.tableFooterView = UIView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkedParticipants.removeAll()
        loadData()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.isEmpty ? 1 : participants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == participants.count {
            
            let cell: UITableViewCell
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = "Здесь отображаются все участники Ваших поездок.\nК сожалению, у Вас нет ни одного участника.\nДобавьте первого, нажав на плюс в верхнем углу экрана."
            cell.isHidden = participants.count > 0 ? true : false
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! ParticipantTVCell
            let participant = participants[indexPath.row]
            cell.accessoryType = isChecked(participant: participant) ? .checkmark : .none
            cell.configure(participant: participant)
            
            return cell
        }
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType != .checkmark {
            cell?.accessoryType = .checkmark
            checkedParticipants.append(participants[indexPath.row])
            print("There are \(checkedParticipants.count) participants checked")
        } else {
            cell?.accessoryType = .none
            let participantToUncheck = participants[indexPath.row]
            for (index, value) in checkedParticipants.enumerated() {
                if value.idUser == participantToUncheck.idUser {
                    checkedParticipants.remove(at: index)
                }
            }
            print("There are \(checkedParticipants.count) participants checked")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == participants.count ? false : true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Удалить") { (action, indexPath) in
            let managedObjectContext = self.coreData.persistentContainer.viewContext
            self.participantToDelete = self.participants[indexPath.row]
            let confirmDeleteAlertController = UIAlertController(title: "Удалить участника из списка?", message: "Вы уверены, что хотите удалить\n\"\((self.participantToDelete?.name!)!)\"\nиз базы данных?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let deleteAction = UIAlertAction(title: "Удалить", style: UIAlertActionStyle.default, handler: { [weak self] (action: UIAlertAction) -> Void in
                managedObjectContext.delete((self?.participantToDelete!)!)
                self?.coreData.saveContext()
                self?.loadData()
                self?.participantToDelete = nil
            })
            
            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: { [weak self] (action: UIAlertAction) -> Void in
                self?.participantToDelete = nil
                tableView.isEditing = false
            })
            
            confirmDeleteAlertController.addAction(deleteAction)
            confirmDeleteAlertController.addAction(cancelAction)
            
            self.present(confirmDeleteAlertController, animated: true, completion: nil)
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Редактировать") { (action, indexPath) in
            self.openParticipantChangesVC(indexPath: indexPath)
        }
        
        edit.backgroundColor = Constants.blueColor
        
        return [delete, edit]
    }
    
    // MARK: - Private function -
    private func loadData() {
        participants = Participant.getParticipantsForCurrentUser(context: coreData.persistentContainer.viewContext)
        print("There are participants: \(participants.count)")
        tableView.reloadData()
    }
    
    private func isChecked(participant: Participant) -> Bool {
        for value in temp {
            if participant.idUser == value.idUser {
                checkedParticipants.append(participant)
                return true
            }
        }
        return false
    }
    
    
    // Переходы по контроллерам
    func back() {
        delegate?.checkedParticipants(context: coreData.persistentContainer.viewContext, array: checkedParticipants)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func openParticipantCreationVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantDetailsVC") as! ParticipantDetailsVC
        VC.isNewParticipant = true
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    func openParticipantChangesVC(indexPath: IndexPath) {
        var participant: Participant!
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantDetailsVC") as! ParticipantDetailsVC
        participant = participants[indexPath.row]
        VC.isNewParticipant = false
        VC.participant = participant
        VC.coreData = self.coreData
        self.navigationController!.pushViewController(VC, animated: true)
    }
}
