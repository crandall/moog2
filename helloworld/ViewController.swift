//
//  ViewController.swift
//  HelloWorld
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var plot: AKNodeOutputPlot!
    @IBOutlet weak var plotWidthLC : NSLayoutConstraint!
    @IBOutlet weak var backButton : UIButton!

//    var oscillator1 = AKOscillator()
//    var oscillator2 = AKOscillator()
//    var mixer = AKMixer()
    var mic: AKMicrophone?
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.startWithMicrophone()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try AudioKit.shutdown()
            AudioKit.output = nil
            self.mic = nil
        } catch {
            print("error shutting down")
        }
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
////        self.startWithMicrophone()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.startWithMicrophone()
//    }
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.plot?.backgroundColor = .yellow
//        let f = self.view.frame
//        self.plotWidthLC.constant = f.width / 2.0
        self.view.bringSubviewToFront(self.backButton)
//        self.backButton.isHidden = true
    }
    
    @IBAction func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func startWithMicrophone(){
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        
        // Cut the volume in half since we have two oscillators
        //        tracker = AKFrequencyTracker(mic)
        AudioKit.output = mic
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        
    }


//    @IBAction func toggleSound(_ sender: UIButton) {
//        if oscillator1.isPlaying {
//            oscillator1.stop()
//            oscillator2.stop()
//            sender.setTitle("Play Sine Waves", for: .normal)
//        } else {
//            oscillator1.frequency = random(in: 220 ... 880)
//            oscillator1.start()
//            oscillator2.frequency = random(in: 220 ... 880)
//            oscillator2.start()
//            sender.setTitle("Stop \(Int(oscillator1.frequency))Hz & \(Int(oscillator2.frequency))Hz", for: .normal)
//        }
//    }

}
