//
//  ViewController.swift
//  TOTP
//
//  Created by Hasan Dag on 21.12.2021.
//

import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        
        view = MainView()
    }
}
