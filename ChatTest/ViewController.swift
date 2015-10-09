//
//  ViewController.swift
//  ChatTest
//
//  Created by Laxman on 08/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tapHereAction(sender: AnyObject) {
    
    let firstViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
    self.navigationController?.pushViewController(firstViewController, animated: true)
        
    }
}

