//
//  AudioPlayerController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 24/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//
//  This class is completely based on
//  PlaySoundsViewController+Audio.swift
//  from PitchPerfect project of Udacity©
//  that is:
//  Copyright © 2016 Udacity. All rights reserved.
//  All credits of the original class for Udacity©

import AVFoundation

class AudioPlayerController: NSObject, AVAudioPlayerDelegate {
    
    // MARK: Audio Player Controller Helpers (Error and Event Helper)
    // Couldn't find a way to localize enum's, so used struct
    private struct ErrorHelper {
        static let AudioFileError = NSLocalizedString("AudioFileError", comment: "Message when audio file creation goes wrong")
        static let AudioEngineError = NSLocalizedString("AudioEngineError", comment: "Message when audio engine start goes wrong")
    }
    
    enum StateHelper {
        case playing, notPlaying
    }
    
    // MARK: Private properties
    private var audioFile: AVAudioFile!
    private var audioEngine: AVAudioEngine!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var stopTimer: Timer!
    private var funcCallBackError:((String) -> Void)!
    private var funcCallBackState:((StateHelper) -> Void)!
    
    // MARK: Override Functions
    init(fileURL:URL, functionToHandleErrors:@escaping ((String) -> Void), functionToHandleStates:@escaping ((StateHelper) -> Void)){
        super.init()
        funcCallBackError = functionToHandleErrors
        funcCallBackState = functionToHandleStates
        
        funcCallBackState(.notPlaying)
        
        do {
            audioFile = try AVAudioFile(forReading: fileURL)
        } catch {
            funcCallBackError(ErrorHelper.AudioFileError)
        }
    }
    
    // Private Functions
    // Connect list of audio nodes
    private func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    // Public Functions
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(self.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            funcCallBackError(ErrorHelper.AudioEngineError)
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
        funcCallBackState(.playing)
    }
    
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        funcCallBackState(.notPlaying)
    }
}
