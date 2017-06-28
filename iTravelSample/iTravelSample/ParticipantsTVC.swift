//
//  ParticipantsTVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 23.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class ParticipantsTVC: UITableViewController {
    
    // MARK: - Properties -
    lazy var participants = [Participant]()
    lazy var checkedParticipants = [Participant]()
    lazy var coreData = CoreDataStack()
    var participantToDelete: Participant?
    
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Участники поездки"
        let checkButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(switchEditingMode))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openParticipantCreationVC))
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.setLeftBarButtonItems([newBackButton], animated: true)
        self.navigationItem.setRightBarButtonItems([addButton, checkButton], animated: true)
        
        tableView.tableFooterView = UIView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            cell.configure(participant: participant)
            cell.accessoryType = isEditingMode ? .none : .disclosureIndicator
            
            return cell
        }
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != participants.count && !isEditingMode {
            openParticipantChangesVC(indexPath: indexPath)
        } else if isEditingMode {
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.accessoryType != .checkmark {
                cell?.accessoryType = .checkmark
                checkedParticipants.append(participants[indexPath.row])
                print("There are \(checkedParticipants.count) participants in checkedArray")
            } else {
                cell?.accessoryType = .none
                let participant = participants[indexPath.row]
                for (index, value) in checkedParticipants.enumerated() {
                    if value.idUser == participant.idUser {
                        checkedParticipants.remove(at: index)
                        print("There are \(checkedParticipants.count) participants in checkedArray")
                    }
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == participants.count ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedObjectContext = coreData.persistentContainer.viewContext
        
        if editingStyle == .delete {
            participantToDelete = participants[indexPath.row]
            
            let confirmDeleteAlertController = UIAlertController(title: "Удалить участника из списка?", message: "Вы уверены, что хотите удалить\n\"\((participantToDelete?.name!)!)\"\nиз базы данных?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let deleteAction = UIAlertAction(title: "Удалить", style: UIAlertActionStyle.default, handler: { [weak self] (action: UIAlertAction) -> Void in
                managedObjectContext.delete((self?.participantToDelete!)!)
                self?.coreData.saveContext()
                self?.loadData()
                self?.participantToDelete = nil
            })
            
            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: { [weak self] (action: UIAlertAction) -> Void in
                self?.participantToDelete = nil
            })
            
            confirmDeleteAlertController.addAction(deleteAction)
            confirmDeleteAlertController.addAction(cancelAction)
            
            present(confirmDeleteAlertController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Private function -
    private func loadData() {
        participants = Participant.getParticipants(context: coreData.persistentContainer.viewContext)
        print("There are participants: \(participants.count)")
        tableView.reloadData()
    }
    
    func switchEditingMode() {
        isEditingMode = isEditingMode ? false : true
        if isEditingMode {
            checkedParticipants.removeAll()
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.leftBarButtonItems = nil
            self.navigationItem.hidesBackButton = true
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(switchEditingMode))
            self.navigationItem.rightBarButtonItem = saveButton
            self.view.setNeedsDisplay()
            tableView.reloadData()
        } else {
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.leftBarButtonItems = nil
            let checkButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(switchEditingMode))
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openParticipantCreationVC))
            let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
            self.navigationItem.setLeftBarButtonItems([newBackButton], animated: true)
            self.navigationItem.setRightBarButtonItems([addButton, checkButton], animated: true)
        }
        
        
        tableView.reloadData()
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
