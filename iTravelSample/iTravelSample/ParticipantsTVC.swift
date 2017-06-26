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
    
    var fetchedResultController: NSFetchedResultsController<Participant>!
    lazy var coreData = CoreDataStack()
    //var participants = [Participant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Участники поездки"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openParticipantDetailVC))
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.rightBarButtonItem = addButton
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            let currentSection = sections[section]
            print("\n\n\n\nThere are \(currentSection.numberOfObjects) objects==rows")
            return currentSection.numberOfObjects
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let section = fetchedResultController.sections?.first
        //if !(section?.numberOfObjects == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! ParticipantTVCell
            let participant = fetchedResultController.object(at: indexPath)
            cell.configure(participant: participant)
            return cell

        //} else {
            
            //let cell: UITableViewCell
            //cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath)
            //cell.textLabel?.numberOfLines = 0
            //cell.textLabel?.textAlignment = .center
            //cell.textLabel?.textColor = .red
            //cell.textLabel?.text = "Здесь отображаются все участники Ваших поездок.\nК сожалению, у Вас нет ни одного участника.\nДобавьте первого, нажав на плюс в верхнем углу экрана."
            //return cell
        //}
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Private function
    
    private func loadData() {
        fetchedResultController = Participant.getParticipants(managedObjectContext: self.coreData.persistentContainer.viewContext)
        fetchedResultController.delegate = self
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
