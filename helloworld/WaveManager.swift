//
//  WaveManager.swift
//  moog
//
//  Created by Mike Crandall on 3/17/21.
//  Copyright © 2021 AudioKit. All rights reserved.
//

import UIKit
import Foundation
import AudioKit
import AudioKitUI


@objc protocol WaveManagerDelegate {
    @objc func onTimer()
}

class WaveManager: NSObject {

    static let sharedInstance = WaveManager()

    weak var delegate : WaveManagerDelegate?
    weak var controller : WaveDisplayController?

//    var plot : AKNodeOutputPlot?
    var mic: AKMicrophone?
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer : Timer?

    
    private override init() {
        super.init()
        self.startWithMic()
    }
    
    func startWithMic(){
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        
        
        let number = Int.random(in: 0..<10)
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(self.onTimer),
                                     userInfo: ["data": "\(number)"],
                                     repeats: true)
        
        
        AudioKit.output = silence
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        print("AK started")
    }
    
    func setUpPlot(vc:UIViewController){
//        let bounds = vc.view.bounds
////        let bounds = CGRect(x: 10, y: 10, width: 600, height: 400)
//        if let p = AKNodeOutputPlot(self.mic, frame: bounds) as AKNodeOutputPlot?{
//            self.plot = p
//            
//            // new
//            self.plot!.plotType = .buffer  //.rolling
//            self.plot!.shouldFill = false
//            self.plot!.shouldMirror = false
//            
//            
//            
//            //                self.plot!.backgroundColor = .green
//            self.plot!.color = UIColor(displayP3Red: 66/255, green: 110/255, blue: 244/255, alpha: 1.0)
//            self.plot!.backgroundColor = .black
////            self.view.addSubview(self.plot!)
//        }
    }

    
    @objc func onTimer(){
        delegate?.onTimer()
    }

    
}
