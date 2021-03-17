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


var globalMic: AKMicrophone?
var globalTracker: AKFrequencyTracker?
var globalSilence: AKBooster?

@objc protocol WaveManagerDelegate {
    @objc func onTimer()
}

class WaveManager: NSObject {

    static let sharedInstance = WaveManager()

    weak var delegate : WaveManagerDelegate?
    weak var controller : WaveDisplayController?

//    var plot : AKNodeOutputPlot?
//    var mic: AKMicrophone?
//    var tracker: AKFrequencyTracker?
//    var silence: AKBooster?
    var timer : Timer?

    
    private override init() {
        super.init()
        self.startWithMic()
    }
    
    func startWithMic(){
        AKSettings.audioInputEnabled = true
        
        globalMic = AKMicrophone()
        globalTracker = AKFrequencyTracker(globalMic)
        globalSilence = AKBooster(globalTracker, gain: 0)
        AudioKit.output = globalSilence

        
//        timer = Timer.scheduledTimer(timeInterval: 0.1,
//                                     target: self,
//                                     selector: #selector(self.onTimer),
//                                     userInfo: nil,
//                                     repeats: true)
        
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
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

//        let frequency = self.tracker?.frequency
//        let amplitude = self.tracker?.amplitude
//        print("amp:\(amplitude)")

//        guard let frequency = self.tracker?.frequency as Double?,
//            let amplitude = self.tracker?.amplitude as Double? else { return }
//        print("\(frequency) :   \(amplitude)")

        delegate?.onTimer()
    }

    
}
