//
//  OscillatorController.swift
//  moog
//
//  Created by Mike Crandall on 3/30/21.
//  Copyright © 2021 AudioKit. All rights reserved.
//

import UIKit

class OscillatorController: UIViewController {
    
    @IBOutlet weak var menuButton : UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black

        // Do any additional setup after loading the view.
        self.handleOsc()
    }
    
    func handleOsc(){
        let osc = LiveView()
        self.view.addSubview(osc.view)
        print("osc")
    }

    @IBAction func onBack(){
        
        let alertController = UIAlertController(title: "Moog Wave Display", message: nil, preferredStyle: .actionSheet)
        
        let exitAction = UIAlertAction(title: "Exit", style: .default, handler: { alertAction in
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { alertAction in
            print("cancel")
        })
        
        
        alertController.addAction(exitAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.menuButton
            let yPopover = self.menuButton.frame.maxY + self.menuButton.frame.height
            popoverController.sourceRect = CGRect(x: self.menuButton.bounds.minX, y:yPopover, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
