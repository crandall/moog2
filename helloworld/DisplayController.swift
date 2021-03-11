//
//  DisplayController.swift
//  moog
//
//  Created by Mike Crandall on 1/14/19.
//  Copyright © 2019 AudioKit. All rights reserved.
//

// test

import UIKit
import AudioKit
import AudioKitUI

class DisplayController: UIViewController {

    @IBOutlet weak var plotTopLC : NSLayoutConstraint!
    @IBOutlet weak var plotWidthLC : NSLayoutConstraint!
    @IBOutlet weak var plotHeightLC : NSLayoutConstraint!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var gainLabel : UILabel!
    
    var plot : AKNodeOutputPlot?
    var mic: AKMicrophone?
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var trackerTimer : Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.startWithMicrophone()
//        self.setUpPlot()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        gainLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        do {
////            try AudioKit.shutdown()
////            AudioKit.output = nil
////            self.mic = nil
////
//////            if self.trackerTimer != nil {
//////                self.trackerTimer!.invalidate()
//////                self.trackerTimer = nil
//////            }
////        } catch {
////            print("error shutting down")
////        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateDataLabels()
        
        let f = self.view.frame
        print("\(f.debugDescription)")
        
        self.setUpPlot()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.bringSubviewToFront(self.backButton)
        self.view.bringSubviewToFront(self.slider)
        self.view.bringSubviewToFront(self.gainLabel)

    }
    
    func setUpPlot(){
        DispatchQueue.main.async {
            let bounds = self.view.bounds
            if let p = AKNodeOutputPlot(self.mic, frame: bounds) as AKNodeOutputPlot?{
                self.plot = p
//                self.plot!.color = .green
                self.plot!.color = UIColor(displayP3Red: 66/255, green: 110/255, blue: 244/255, alpha: 1.0)
                self.plot!.backgroundColor = .black
                self.view.addSubview(self.plot!)
            }
        }
    }
    
    func restartAudioKit(){
        exit(0)
//        do {
//            try AudioKit.disconnectAllInputs()
//            try AudioKit.shutdown()
//            AudioKit.output = nil
//            self.mic = nil
//            self.plot?.removeFromSuperview()
//            self.plot = nil
//
//            // restart:
//            self.startWithMicrophone()
//            self.setUpPlot()
//        } catch {
//            print("error shutting down")
//        }
    }

    @IBAction func onBack(){
        
        let optionMenu = UIAlertController(title: "Moog Wave Display", message: "Quit app for AudioKit restart?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let restartAction = UIAlertAction(title: "Quit App", style: .default, handler: { alertAction in
            self.restartAudioKit()
        })
        
        optionMenu.addAction(restartAction)
        optionMenu.addAction(cancelAction)

        DispatchQueue.main.async {
            self.present(optionMenu, animated: true, completion: nil)
        }
    }

//    @IBAction func onBack1(_ sender: UIButton) {
//        let alertController = UIAlertController(title: nil, message: "Alert message.", preferredStyle: .actionSheet)
//        
//        let defaultAction = UIAlertAction(title: "Default", style: .default, handler: { (alert: UIAlertAction!) -> Void in
//            //  Do some action here.
//        })
//        
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
//            //  Do some destructive action here.
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
//            //  Do something here upon cancellation.
//        })
//        
//        alertController.addAction(defaultAction)
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//        
//        if let popoverController = alertController.popoverPresentationController {
//            popoverController.barButtonItem = sender as? UIBarButtonItem
//        }
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func onSliderValueChanged(sender:UISlider){
        DispatchQueue.main.async {
            self.plot?.gain = sender.value
            self.updateDataLabels()
        }
    }
    
    
    func startWithMicrophone(){
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(self.updateUI),
                             userInfo: nil,
                             repeats: true)

        
//        AudioKit.output = mic
        AudioKit.output = silence
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        
    }
    
    func updateDataLabels(){
        let value = self.slider.value
        
        // gain:
        let gain = String(format: "%.02f", value)
//        gainLabel.text = "Gain: \(gain)"
        
        var dataString = "amplitude: \(currAmplitudeString ?? "0")\n"
        dataString += "frequency: \(currFrequencyString ?? "0")\n"
        dataString += "gain: \(gain)"
        
        DispatchQueue.main.async {
            self.gainLabel.text = dataString
        }

        
    }

    var currAmplitudeString : String?
    var currFrequencyString : String?
    var currGainString : String?
    @objc func updateUI() {
        currFrequencyString = String(format: "%0.02f", tracker.frequency)
        currAmplitudeString = String(format: "%0.02f", tracker.amplitude)
        self.updateDataLabels()

//        if tracker.amplitude > 0.1 {
//            print("tracker:\(tracker.amplitude)")
////            frequencyLabel.text = String(format: "%0.1f", tracker.frequency)
////
////            var frequency = Float(tracker.frequency)
////            while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
////                frequency /= 2.0
////            }
////            while frequency < Float(noteFrequencies[0]) {
////                frequency *= 2.0
////            }
////
////            var minDistance: Float = 10_000.0
////            var index = 0
////
////            for i in 0..<noteFrequencies.count {
////                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
////                if distance < minDistance {
////                    index = i
////                    minDistance = distance
////                }
////            }
////            let octave = Int(log2f(Float(tracker.frequency) / frequency))
////            noteNameWithSharpsLabel.text = "\(noteNamesWithSharps[index])\(octave)"
////            noteNameWithFlatsLabel.text = "\(noteNamesWithFlats[index])\(octave)"
//        }
////        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
    }

}
