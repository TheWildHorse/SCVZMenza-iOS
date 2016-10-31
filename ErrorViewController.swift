//
//  ErrorViewController.swift
//  Menza
//
//  Created by Igor Rinkovec on 31/10/16.
//  Copyright © 2016 Igor Rinkovec. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    
    var refreshDelegate: RefreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.refreshDelegate!.reloadData()
    }
    
    
}
