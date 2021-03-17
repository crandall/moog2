//
//  WaveDisplayController.swift
//  moog
//
//  Created by Mike Crandall on 3/11/21.
//  Copyright © 2021 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI

class WaveDisplayController: UIViewController, WaveManagerDelegate {
    
    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var gainLabel : UILabel!
    
    var currAmplitudeString : String?
    var currFrequencyString : String?
    var currGainString : String?
    var plot : AKNodeOutputPlot?
    var timer : Timer?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        gainLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateDataLabels()
        
        let f = self.view.frame
        print("\(f.debugDescription)")
        
        self.setUpPlot()
//        WaveManager.sharedInstance.delegate = self

        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.05,
                                     target: self,
                                     selector: #selector(self.updateUI),
                                     userInfo: nil,
                                     repeats: true)
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.shutDownTimer()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.bringSubviewToFront(self.menuButton)
        self.view.bringSubviewToFront(self.slider)
        self.view.bringSubviewToFront(self.gainLabel)
    }
    
    func shutDownTimer(){
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func setUpPlot(){
        DispatchQueue.main.async {
            let bounds = self.view.bounds
            if let p = AKNodeOutputPlot(globalMic, frame: bounds) as AKNodeOutputPlot?{
                self.plot = p
                self.plot!.plotType = .buffer  //.rolling
                self.plot!.shouldFill = false
                self.plot!.shouldMirror = false
                self.plot!.color = UIColor(displayP3Red: 66/255, green: 110/255, blue: 244/255, alpha: 1.0)
                self.plot!.backgroundColor = .black
                self.view.addSubview(self.plot!)
            }
        }
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
    
    
    @IBAction func onSliderValueChanged(sender:UISlider){
        DispatchQueue.main.async {
            self.plot?.gain = sender.value
            self.updateDataLabels()
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
    
    @objc func updateUI() {
//        print("updateUI")
        currFrequencyString = String(format: "%0.02f", globalTracker?.frequency ?? "no")
        currAmplitudeString = String(format: "%0.02f", globalTracker?.amplitude ?? "no")
        
//        print("freq:\(String(describing: currFrequencyString))")
//        print("amp:\(String(describing: currAmplitudeString))")
        self.updateDataLabels()
        
    }


    
    func startWithWavFile(){
        
//        var playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sine", ofType: "wav")!)
//        do {
//            let file = try AKAudioFile(forReading: playYoda as URL)
//            if let player = AKPlayer(audioFile: file) as AKPlayer?{
//                player.isLooping = true
//                AKSettings.audioInputEnabled = true
//                tracker = AKFrequencyTracker(player)
//                //            AudioKit.output = tracker
//                let silence = AKBooster(tracker, gain: 1.0)
//                //                AudioKit.output = tracker
//                AudioKit.output = silence
//
//                mic = AKMicrophone()
//                tracker = AKFrequencyTracker(mic)
//
//
//
//                Timer.scheduledTimer(timeInterval: 0.1,
//                                     target: self,
//                                     selector: #selector(self.updateUI),
//                                     userInfo: nil,
//                                     repeats: true)
//
//
//                do {
//                    try AudioKit.start()
//                    player.play()
//                } catch {
//                    AKLog("AudioKit did not start!")
//                }
//
//            }
//            print("got it")
//        } catch {
//            print("yomama")
//        }
//
//        print("yo")
//        return
//
//        //        AKSettings.audioInputEnabled = true
//        //        mic = AKMicrophone()
//        //        tracker = AKFrequencyTracker(mic)
//        //        silence = AKBooster(tracker, gain: 0)
//        //        let loud = AKBooster(tracker, gain: 1.0)
//        //        Timer.scheduledTimer(timeInterval: 0.1,
//        //                             target: self,
//        //                             selector: #selector(self.updateUI),
//        //                             userInfo: nil,
//        //                             repeats: true)
//        //
//        //
//        //        AudioKit.output = silence
//        //        do {
//        //            try AudioKit.start()
//        //        } catch {
//        //            AKLog("AudioKit did not start!")
//        //        }
//
//
//
//        //        AKSettings.audioInputEnabled = true
//        //        mic = AKMicrophone()
//        //
//        //        tracker = AKFrequencyTracker(mic)
//        //        silence = AKBooster(tracker, gain: 0)
//        //        Timer.scheduledTimer(timeInterval: 0.1,
//        //                             target: self,
//        //                             selector: #selector(self.updateUI),
//        //                             userInfo: nil,
//        //                             repeats: true)
//        //
//        //
//        //        AudioKit.output = silence
//        //        do {
//        //            try AudioKit.start()
//        //        } catch {
//        //            AKLog("AudioKit did not start!")
//        //        }
//
    }

    
    
}
