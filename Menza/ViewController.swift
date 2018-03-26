//
//  ViewController.swift
//  Menza
//
//  Created by Igor Rinkovec on 08/05/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import UIKit

protocol RefreshDelegate: class {
    func reloadData()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatePickerViewControllerDelegate {
    
    var availableDays:Array<MenusWrapper>?
    var selectedDay:MenusWrapper?
    var tableViewMenus:Array<Menu>?
    var isDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mealPicker: UISegmentedControl!
    @IBOutlet weak var dateLabel: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125.0
        tableView.delegate = self
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        self.loadMenus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DatePickerSegue" {
            if let destination = segue.destination as? DatePickerViewController {
                destination.availableDays = self.availableDays
                destination.delegate = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableViewMenus = self.tableViewMenus else {
            return 0
        }
        return tableViewMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuTableViewCell"
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MenuTableViewCell

        cell.MenuDescriptionLabel.text = tableViewMenus![indexPath.row].description;
        if(tableViewMenus![indexPath.row].name == "Vegeterian") {
            cell.MenuImageIcon.image = UIImage(named: "Vegeterian");
        }
        else if(tableViewMenus![indexPath.row].name == "Additional") {
            cell.MenuImageIcon.image = UIImage(named: "Additional");
        }
        else {
            cell.MenuImageIcon.image = UIImage(named: "Menu");
        }
        
        return cell
    }
    
    func loadMenus() {
        isDataLoading = true
        MenusFetcherService.getMenus { wrappers, error in
            guard error == nil else {
                self.isDataLoading = false
                self.displayErrorScreen()
                return
            }
            guard wrappers!.count != 0 else {
                self.displayErrorScreen()
                return
            }
            self.availableDays = wrappers
            self.selectedDay = wrappers?.first
            self.mealPicker.selectedSegmentIndex = 0
            self.isDataLoading = false
            self.refreshView()
        }
    }
    
    func displayErrorScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ErrorViewController = storyboard.instantiateViewController(withIdentifier: "ErrorScreen") as! ErrorViewController
        vc.refreshDelegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    func setActiveDay(index: Int) {
        self.selectedDay = self.availableDays![index]
        self.mealPicker.selectedSegmentIndex = 0
        self.refreshView()
    }
    
    func refreshView() {
        if(mealPicker.selectedSegmentIndex == 0) {
            self.tableViewMenus = self.selectedDay?.lunch
        }
        else {
            self.tableViewMenus = self.selectedDay?.dinner
        }
        self.tableView?.reloadData()
        self.dateLabel.title = self.selectedDay?.date
    }

    @IBAction func onMealChange(sender: AnyObject) {
        self.refreshView()
    }

}

extension ViewController: RefreshDelegate {
    func reloadData() {
        self.loadMenus()
    }
}

