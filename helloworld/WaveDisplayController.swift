//
//  WaveDisplayController.swift
//  moog
//
//  Created by Mike Crandall on 3/11/21.
//  Copyright © 2021 AudioKit. All rights reserved.
//

import UIKit

class WaveDisplayController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var menuButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = "Moog Shit and all that"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func onMenu(){
        print("onMenu")
    }
    

}
