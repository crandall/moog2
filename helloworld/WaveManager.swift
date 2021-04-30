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
//        self.playWavFile()
    }
    
    func startWithMic(){

        let sr = AKSettings.sampleRate
        print("yo")
        AKSettings.sampleRate = 22050   //44100
//        AKSettings.sampleRate = 88200   //44100

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

//        if let inputs = AudioKit.inputDevices as [AKDevice]?{
//            print("yo")
//        }
//
//
//        if let inputs = AudioKit.availableInputs {
//            try AudioKit.setInputDevice(inputs[0])
//            try mic.setDevice(inputs[0])
//            dump(inputs)
//            dump(EZAudioDevice.inputDevices())
//        }
    }
    
    func playWavFile(){
        let playFile = NSURL(fileURLWithPath: Bundle.main.path(forResource: "square", ofType: "wav")!)
        do {
            let file = try AKAudioFile(forReading: playFile as URL)
            if let player = AKPlayer(audioFile: file) as AKPlayer?{
                player.isLooping = true
//                AKSettings.audioInputEnabled = true
//                globalTracker = AKFrequencyTracker(player)
//                let silence = AKBooster(globalTracker, gain: 1.0)
                //                AudioKit.output = tracker
//                AudioKit.output = silence

//                globalMic = AKMicrophone()
//                globalTracker = AKFrequencyTracker(globalMic)

                AKSettings.audioInputEnabled = true
                globalMic = AKMicrophone()
                globalTracker = AKFrequencyTracker(player)
                globalSilence = AKBooster(globalTracker, gain: 0)
                AudioKit.output = globalSilence


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
        
    }

}


class OscillatorWaveManager: NSObject {
    
    static let sharedInstance = OscillatorWaveManager()
    
    private override init() {
        super.init()
        self.startWithMic()
    }
    
    func startWithMic(){
//        AKSettings.audioInputEnabled = true
//
//        globalMic = AKMicrophone()
//        globalTracker = AKFrequencyTracker(globalMic)
//        globalSilence = AKBooster(globalTracker, gain: 0)
//        AudioKit.output = globalSilence
        
        
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    
}
