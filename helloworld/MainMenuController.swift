//
//  MainMenuController.swift
//  moog
//
//  Created by Mike Crandall on 1/14/19.
//  Copyright © 2019 AudioKit. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController {

//    @IBOutlet weak var logoIV : UIImageView!
    @IBOutlet weak var foundationLogoIV : UIImageView!
    @IBOutlet weak var schoolLogoIV : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var buildLabel : UILabel!
    @IBOutlet weak var waveButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.isIdleTimerDisabled = true
        
        waveButton.layer.shadowColor = UIColor.black.cgColor
        waveButton.layer.shadowOpacity = 1
        waveButton.layer.shadowOffset = CGSize.zero
        waveButton.layer.shadowRadius = 10

        
        foundationLogoIV.layer.shadowColor = UIColor.black.cgColor
        foundationLogoIV.layer.shadowOpacity = 1
        foundationLogoIV.layer.shadowOffset = CGSize.zero
        foundationLogoIV.layer.shadowRadius = 10
        
        schoolLogoIV.layer.shadowColor = UIColor.black.cgColor
        schoolLogoIV.layer.shadowOpacity = 1
        schoolLogoIV.layer.shadowOffset = CGSize.zero
        schoolLogoIV.layer.shadowRadius = 10
        
        waveButton.setTitle("ThereScope", for: .normal)
        
        if let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String?{
            buildLabel.text = "build \(build)"
        }

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let f = self.view.frame
//        print("yoMama")
//    }
    
    @IBAction func onWave(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "displayController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension UIView {
    
    private static var _addShadow:Bool = false
    
    @IBInspectable var addShadow:Bool {
        get {
            return UIView._addShadow
        }
        set(newValue) {
            if(newValue == true){
                layer.masksToBounds = false
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.075
                layer.shadowOffset = CGSize(width: 0, height: -3)
                layer.shadowRadius = 1
                
                layer.shadowPath = UIBezierPath(rect: bounds).cgPath
                layer.shouldRasterize = true
                layer.rasterizationScale =  UIScreen.main.scale
            }
        }
    }
    
}
