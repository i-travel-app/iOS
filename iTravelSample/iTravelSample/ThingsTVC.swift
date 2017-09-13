//
//  ThingsTVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 25.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import TabPageViewController
//
// MARK: - Section Data Structure
//
struct Item {
    var name: String
    var detail: String
    
    init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}

struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

class ThingsTVC: UITableViewController {
    
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Вещи в поездку"
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize the sections array
        sections = [
            Section(name: "Средства гигиены", items: [
                Item(name: "Гигиена 1", detail: "Чистота - залог здоровья!"),
                Item(name: "Гигиена 2", detail: "В чистом теле - чистый дух!"),
                Item(name: "Гигиена 3", detail: "Надо, надо умываться по утрам и вечерам, а нечистым трубочистам - стыд и срам!")]),
            Section(name: "Документы", items: [
                Item(name: "Документы 1", detail: "Без паспорта за границу?! Ну ты даешь..."),
                Item(name: "Документы 2", detail: "Ну и водительские права не забудь... Может, еще в прокате возмешь машинку..."),
                Item(name: "Документы 3", detail: "Про справки не забудь, а мало ли что...")]),
            Section(name: "Теплые вещи", items: [
                Item(name: "Теплые вещи 1", detail: "На улице зима, - возьми свитерок, на всякий..."),
                Item(name: "Теплые вещи 2", detail: "В Африке тоже бывает снег ))) Одевайся теплее!"),
                Item(name: "Теплые вещи 3", detail: "Прогноз видел? Бери побольше теплых вещей!")])
        ]
        
        // add gestures to drag & drop functionality
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ThingsTVC.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navigationHeight = topLayoutGuide.length
        tableView.contentInset.top = navigationHeight + TabPageOption().tabHeight
    }
    
    fileprivate func updateNavigationBarOrigin(velocity: CGPoint) {
        guard let tabPageViewController = parent as? TabPageViewController else { return }
        
        if velocity.y > 0.5 {
            tabPageViewController.updateNavigationBarHidden(true, animated: true)
        } else if velocity.y < -0.5 {
            tabPageViewController.updateNavigationBarHidden(false, animated: true)
        }
    }
    
    func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot = snapshotOfCell(cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    
                    let sourceItem = sections[(Path.initialIndexPath?.section)!].items[(Path.initialIndexPath?.row)!]
                    
                    if Path.initialIndexPath?.section == indexPath?.section {
                        
                        swap(&sections[(Path.initialIndexPath?.section)!].items[(Path.initialIndexPath?.row)!], &sections[(Path.initialIndexPath?.section)!].items[(indexPath?.row)!])
                        
                    } else {
                        
                        sections[(Path.initialIndexPath?.section)!].items = sections[(Path.initialIndexPath?.section)!].items.filter{$0.name != sourceItem.name}
                        
                        sections[(indexPath?.section)!].items.insert(sourceItem, at: (indexPath?.row)!)
                    }
                    //print("first section has \(sections[0].items.count) rows\nsecond section has \(sections[1].items.count) rows")
                    tableView.reloadData()
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

}

//
// MARK: - View Controller DataSource and Delegate
//
extension ThingsTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ThingTVCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ThingTVCell ??
            ThingTVCell(style: .default, reuseIdentifier: "cell")
        
        let item: Item = sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        
        cell.nameLabel.text = item.name
        cell.detailLabel.text = item.detail
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].collapsed ? 0 : UITableViewAutomaticDimension
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ThingsTVHeader ?? ThingsTVHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !sections[section].items.isEmpty {
            return 44.0
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !sections[section].items.isEmpty {
            return 1.0
        } else {
            return 0
        }
    }
    
}

//
// MARK: - UIScrollViewDelegate
//
extension ThingsTVC {
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        updateNavigationBarOrigin(velocity: velocity)
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let tabpageViewController = parent as? TabPageViewController else { return }
        
        tabpageViewController.showNavigationBar()
    }
}

//
// MARK: - Section Header Delegate
//
extension ThingsTVC: ThingsTVHeaderDelegate {
    
    func toggleSection(_ header: ThingsTVHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
