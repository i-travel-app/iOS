//
//  ParticipantsTVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 23.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class ParticipantsTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties -
    var fetchedResultController: NSFetchedResultsController<Participant>!
    lazy var coreData = CoreDataStack()
    var participantToDelete: Participant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Участники поездки"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openParticipantCreationVC))
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.rightBarButtonItem = addButton
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        if let objects = fetchedResultController.fetchedObjects {
            return objects.count + 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == (fetchedResultController.fetchedObjects?.count)! {
            
            let cell: UITableViewCell
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = "Здесь отображаются все участники Ваших поездок.\nК сожалению, у Вас нет ни одного участника.\nДобавьте первого, нажав на плюс в верхнем углу экрана."
            cell.isHidden = (fetchedResultController.fetchedObjects?.count)! > 0 ? true : false
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! ParticipantTVCell
            let participant = fetchedResultController.object(at: indexPath)
            cell.configure(participant: participant)
            
            return cell
        }
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        openParticipantChangesVC(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == (fetchedResultController.fetchedObjects?.count)! ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedObjectContext = coreData.persistentContainer.viewContext
        
        if editingStyle == .delete {
            participantToDelete = fetchedResultController.object(at: indexPath)
            
            let confirmDeleteAlertController = UIAlertController(title: "Удалить участника из списка?", message: "Вы уверены, что хотите удалить \"\((participantToDelete?.name!)!)\" из базы данных?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
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
    
    // MARK: Private function
    private func loadData() {
        fetchedResultController = Participant.getParticipants(managedObjectContext: coreData.persistentContainer.viewContext)
        print("There are participants: \(String(describing: fetchedResultController.fetchedObjects?.count))")
        fetchedResultController.delegate = self
        self.tableView.reloadData()
    }
    
    // MARK: - Fetched Results Controller Delegate Methods -
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.delete:
            print("NSFetchedResultsChangeType.Delete detected")
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            }
        case NSFetchedResultsChangeType.insert:
            print("NSFetchedResultsChangeType.Insert detected")
        case NSFetchedResultsChangeType.move:
            print("NSFetchedResultsChangeType.Move detected")
        case NSFetchedResultsChangeType.update:
            print("NSFetchedResultsChangeType.Update detected")
            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        VC.participant = Participant(context: coreData.persistentContainer.viewContext)
        VC.coreData = self.coreData
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    func openParticipantChangesVC(indexPath: IndexPath) {
        var participant: Participant!
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantDetailsVC") as! ParticipantDetailsVC
        participant = fetchedResultController.object(at: indexPath)
        VC.isNewParticipant = false
        VC.participant = participant
        VC.coreData = self.coreData
        self.navigationController!.pushViewController(VC, animated: true)
    }

}
