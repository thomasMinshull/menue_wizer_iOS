//
//  InvalidLogoViewController.swift
//  MenuWise
//
//  Created by thomas minshull on 2018-09-23.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit

class InvalidLogoViewController: UIViewController {

    @IBOutlet var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ReportButtonTapped(_ sender: Any) {
        textLabel.text = "Thank you, your report has been sent"
        
    }
    
}
