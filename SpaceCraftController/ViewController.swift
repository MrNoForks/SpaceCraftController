//
//  ViewController.swift
//  SpaceCraftController
//
//  Created by boppo on 3/22/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var lastSeguedToARViewController : ARViewController?
    
    override var prefersStatusBarHidden : Bool{
        return true
    }
//    override func loadView() {
//        self.navigationController?.isNavigationBarHidden = true
//    }
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBOutlet var ARButtons: [UIButton]!
    
    @IBAction func ARButtonsPressed(_ sender: UIButton) {
        let vc = ARViewController()
        vc.modelName = sender.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func pressMeBtn(_ sender: UIButton) {
       performSegue(withIdentifier: "Goto AR", sender: sender)
    }
    
    
    
    

}

