//
//  WaveDisplayController.swift
//  moog
//
//  Created by Mike Crandall on 3/11/21.
//  Copyright © 2021 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI

class WaveDisplayController: UIViewController {
    
//    @IBOutlet weak var plotTopLC : NSLayoutConstraint!
//    @IBOutlet weak var plotWidthLC : NSLayoutConstraint!
//    @IBOutlet weak var plotHeightLC : NSLayoutConstraint!
    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var gainLabel : UILabel!
    
    var plot : AKNodeOutputPlot?
    var mic: AKMicrophone?
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        gainLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateDataLabels()
        
        let f = self.view.frame
        print("\(f.debugDescription)")
        
        self.setUpPlot()
        self.startWithMicrophone()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.shutdownAudioKit()
//        self.timer?.invalidate()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.bringSubviewToFront(self.menuButton)
        self.view.bringSubviewToFront(self.slider)
        self.view.bringSubviewToFront(self.gainLabel)
    }
    
    func setUpPlot(){
        DispatchQueue.main.async {
            let bounds = self.view.bounds
            if let p = AKNodeOutputPlot(self.mic, frame: bounds) as AKNodeOutputPlot?{
                self.plot = p
//                self.plot!.backgroundColor = .green
                self.plot!.color = UIColor(displayP3Red: 66/255, green: 110/255, blue: 244/255, alpha: 1.0)
                self.plot!.backgroundColor = .black
                self.view.addSubview(self.plot!)
            }
        }
    }
    
    
    func restartAudioKit(){
        print("restartAudioKit")
        return
        do {
//            try AudioKit.disconnectAllInputs()
            try AudioKit.shutdown()
//            AudioKit.output = nil
//            self.mic = nil
        } catch {
            print("error shutting down")
        }

        DispatchQueue.main.async {
            self.plot?.removeFromSuperview()
            self.plot = nil
            self.setUpPlot()
            self.startWithMicrophone()
        }

    }
    
    @IBAction func onBack(){
        
        let alertController = UIAlertController(title: "Moog Wave Display", message: nil, preferredStyle: .actionSheet)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let exitAction = UIAlertAction(title: "Exit", style: .default, handler: { alertAction in
            self.navigationController?.popViewController(animated: true)
        })
        
        let restartAction = UIAlertAction(title: "Restart Audio", style: .default, handler: { alertAction in
            self.restartAudioKit()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { alertAction in
            print("cancel")
        })

        
//        alertController.addAction(restartAction)
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
    
    func shutdownAudioKit(){
        do {
            try AudioKit.shutdown()
        } catch {
            print("error shutting down")
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
        
        
        AudioKit.output = silence
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        
    }
    
    func startWithWavFile(){
        
        var playYoda = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sine", ofType: "wav")!)
        do {
            let file = try AKAudioFile(forReading: playYoda as URL)
            if let player = AKPlayer(audioFile: file) as AKPlayer?{
                player.isLooping = true
                AKSettings.audioInputEnabled = true
                tracker = AKFrequencyTracker(player)
                //            AudioKit.output = tracker
                let silence = AKBooster(tracker, gain: 1.0)
                //                AudioKit.output = tracker
                AudioKit.output = silence
                
                mic = AKMicrophone()
                tracker = AKFrequencyTracker(mic)
                
                Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(self.updateUI),
                                     userInfo: nil,
                                     repeats: true)
                
                
                do {
                    try AudioKit.start()
                    player.play()
                } catch {
                    AKLog("AudioKit did not start!")
                }
                
            }
            print("got it")
        } catch {
            print("yomama")
        }
        
        print("yo")
        return
        
        //        AKSettings.audioInputEnabled = true
        //        mic = AKMicrophone()
        //        tracker = AKFrequencyTracker(mic)
        //        silence = AKBooster(tracker, gain: 0)
        //        let loud = AKBooster(tracker, gain: 1.0)
        //        Timer.scheduledTimer(timeInterval: 0.1,
        //                             target: self,
        //                             selector: #selector(self.updateUI),
        //                             userInfo: nil,
        //                             repeats: true)
        //
        //
        //        AudioKit.output = silence
        //        do {
        //            try AudioKit.start()
        //        } catch {
        //            AKLog("AudioKit did not start!")
        //        }
        
        
        
        //        AKSettings.audioInputEnabled = true
        //        mic = AKMicrophone()
        //
        //        tracker = AKFrequencyTracker(mic)
        //        silence = AKBooster(tracker, gain: 0)
        //        Timer.scheduledTimer(timeInterval: 0.1,
        //                             target: self,
        //                             selector: #selector(self.updateUI),
        //                             userInfo: nil,
        //                             repeats: true)
        //
        //
        //        AudioKit.output = silence
        //        do {
        //            try AudioKit.start()
        //        } catch {
        //            AKLog("AudioKit did not start!")
        //        }
        
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
