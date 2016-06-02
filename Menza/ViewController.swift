//
//  ViewController.swift
//  Menza
//
//  Created by Igor Rinkovec on 08/05/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menus:Array<Menu>?
    var menusWrapper:MenusWrapper? // holds the last wrapper that we've loaded
    var isDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mealPicker: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125.0
        tableView.delegate = self
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        self.loadMenus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menus = self.menus else {
            return 0
        }
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuTableViewCell"
        let cell: MenuTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MenuTableViewCell

        cell.MenuDescriptionLabel.text = menus![indexPath.row].description;
        if(menus![indexPath.row].name == "Vegeterian") {
            cell.MenuImageIcon.image = UIImage(named: "Vegeterian");
        }
        else if(menus![indexPath.row].name == "Additional") {
            cell.MenuImageIcon.image = UIImage(named: "Additional");
        }
        else {
            cell.MenuImageIcon.image = UIImage(named: "Menu");
        }
        
        return cell
    }
    
    func loadMenus() {
        isDataLoading = true
        Menu.getMenus { wrapper, error in
            guard error == nil else {
                self.isDataLoading = false
                let alert = UIAlertController(title: "Error",
                    message: "Neuspješno učitavanje: \(error?.localizedDescription)",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.addMenusFromWrapper(wrapper)
            self.isDataLoading = false
        }
    }
    
    
    func addMenusFromWrapper(wrapper: MenusWrapper?) {
        self.menusWrapper = wrapper
        if(mealPicker.selectedSegmentIndex == 0) {
            self.menus = self.menusWrapper?.lunch
        }
        else {
            self.menus = self.menusWrapper?.dinner
        }
        self.tableView?.reloadData()
    }

    @IBAction func onMealChange(sender: AnyObject) {
        self.addMenusFromWrapper(menusWrapper)
    }

}

