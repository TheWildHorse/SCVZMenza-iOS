//
//  ViewController.swift
//  Menza
//
//  Created by Igor Rinkovec on 08/05/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate
{
    func setActiveDay(index: Int)
}

class DatePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate:DatePickerViewControllerDelegate!
    var availableDays:Array<MenusWrapper>?

    @IBOutlet weak var dateTableView: UITableView!
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let availableDays = self.availableDays else {
            return 0
        }
        return availableDays.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //variable type is inferred
        let cell = UITableViewCell()
        cell.textLabel?.text = availableDays![indexPath.row].date;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate!.setActiveDay(indexPath.row)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

