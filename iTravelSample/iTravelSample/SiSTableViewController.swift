//
//  SiSTableViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 04.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSTableViewController: UITableViewController {

    var clothesSet = Set<Cloth>()
    var clothesArray = [Cloth]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clothesArray = Array(self.clothesSet)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: NSString = "Cell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId as String)!
        let cloth = clothesArray[indexPath.row]
        cell.textLabel?.text = cloth.title
        cell.detailTextLabel?.text = "id \(cloth.id)"
        return cell
    }
}
