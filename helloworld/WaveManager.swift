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
    @objc optional func onTimer()
}

class WaveManager: NSObject {

    static let sharedInstance = WaveManager()

    weak var delegate : WaveManagerDelegate?
    weak var controller : WaveDisplayController?

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

        
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    
}
