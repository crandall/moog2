//
//  LiveView.swift
//  moog
//
//  Created by Mike Crandall on 3/25/21.
//  Copyright © 2021 AudioKit. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI


class LiveView: AKLiveViewController, AKKeyboardDelegate {

    var oscillator : AKOscillator = AKOscillator()
    var currentMIDINote: MIDINoteNumber = 0
    var currentAmplitude = 0.4
    var currentRampDuration = 0.1
    
    var plot : AKNodeOutputPlot?
    var currGain : Float = 2.0

    
    let square = AKTable(.square, count: 256)
    let triangle = AKTable(.triangle, count: 256)
    let sine = AKTable(.sine, count: 256)
    let sawtooth = AKTable(.sawtooth, count: 256)

    var oscillatorMic: AKMicrophone?
    var oscillatorTracker: AKFrequencyTracker?
    var oscillatorSilence: AKBooster?
    
    
//    var tracker: AKFrequencyTracker!
    func receiveSound() {
//        AudioKit.stop()
        AKSettings.audioInputEnabled = true
        let mic = AKMicrophone()
        
        self.oscillatorTracker = AKFrequencyTracker(mic)
        self.oscillatorSilence = AKBooster(oscillatorTracker, gain: 0)
        AudioKit.output = self.oscillatorSilence
//        AudioKit.start()

        do {
            try AudioKit.start()
        } catch {
            print("AudioKit.start error")
        }

        Timer.scheduledTimer( timeInterval: 0.1, target: self, selector: #selector(self.handleTracker), userInfo: nil, repeats: true)
    }
    
    @objc func handleTracker(){
        if let tracker = self.oscillatorTracker as AKFrequencyTracker?{
            print("\(tracker.frequency)")
        }
    }

    override func viewDidLoad() {
        
        self.oscillator = AKOscillator(waveform: square)
        AudioKit.output = self.oscillator
        
//        AKSettings.audioInputEnabled = true
//        self.oscillatorMic = AKMicrophone()
//        self.oscillatorTracker = AKFrequencyTracker(oscillatorMic)
//        self.oscillatorSilence = AKBooster(oscillatorTracker, gain: 0)
//        AudioKit.output = self.oscillatorSilence


        do {
            try AudioKit.start()
        } catch {
            print("AudioKit.start error")
        }
        oscillator.rampDuration = currentRampDuration
        oscillator.amplitude = currentAmplitude


//        addTitle("Oscillator Synth")
        addView(AKSlider(property: "Amplitude",
                         value: oscillator.amplitude,
                         format: "%0.3f"
        ) { amplitude in
//            print("amplitude:\(amplitude)")
            self.currentAmplitude = amplitude
        })

        addView(AKSlider(property: "Ramp Duration",
                         value: oscillator.rampDuration,
                         format: "%0.3f s"
        ) { time in
            print("duration:\(time)")
            self.currentRampDuration = time
        })
        
        let keyboard = AKKeyboardView(width: 400, height: 100, firstOctave: 3, octaveCount: 3)
        keyboard.delegate = self
        addView(keyboard)
        
        let shit = self.view.bounds
        
//        let node = AKNode(avAudioNode: self.oscillatorMic)
//        let plot3 = AKOutputWaveformPlot(self.oscillatorTracker, frame: CGRect(width: 1000, height: 600), bufferSize: 1024)
//        let plot1 = AKOutputWaveformPlot(self.oscillator, frame: CGRect(width: 1000, height: 600), bufferSize: 1024)
//        addView(plot3)
        let plot2 = AKOutputWaveformPlot.createView(width: 1000, height: 600)
        addView(plot2)
//        addView(AKOutputWaveformPlot.createView())

//        self.noteOn(note: 1)
        
//        oscillator.play()
        self.noteOn(note: 72)
        
//        self.oscillator.start()
//        self.oscillator.play()

    }
    
    func noteOn(note: MIDINoteNumber) {
//        print("noteOn")
        currentMIDINote = note
        // start from the correct note if amplitude is zero
        if oscillator.amplitude == 0 {
            oscillator.rampDuration = 0
        }
        oscillator.frequency = note.midiNoteToFrequency()
        
        // Still use rampDuration for volume
        oscillator.rampDuration = currentRampDuration
        oscillator.amplitude = currentAmplitude
        oscillator.play()
    }
    
    func noteOff(note: MIDINoteNumber) {
//        print("noteOff")
        if currentMIDINote == note {
            oscillator.amplitude = 0
        }
    }
}
