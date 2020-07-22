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

enum AudioPlayerError: Error {
    case couldNotCreatFile
    case couldNotStartFile
}

protocol AudioPlayerDelegate: AnyObject {
    func onAudioPlay()
    func onAudioStop()
}

class AudioPlayerController: NSObject, AVAudioPlayerDelegate {

    weak var delegate: AudioPlayerDelegate?

    // MARK: Private properties
    private var audioFile: AVAudioFile?
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var stopTimer: Timer?

    // MARK: Override Functions
    init(fileURL: URL?) throws {
        super.init()

        guard let fileURL = fileURL else {
            throw AudioPlayerError.couldNotCreatFile
        }

        do {
            audioFile = try AVAudioFile(forReading: fileURL)
        } catch {
            throw AudioPlayerError.couldNotCreatFile
        }
    }

    // Private Functions
    // Connect list of audio nodes
    private func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count - 1 {
            audioEngine?.connect(nodes[x], to: nodes[x + 1], format: audioFile?.processingFormat)
        }
    }

    // Public Functions
    func playSound(
        rate: Float? = nil,
        pitch: Float? = nil,
        echo: Bool = false,
        reverb: Bool = false
    ) throws {

        createAndConnectNodes(rate: rate, pitch: pitch, echo: echo, reverb: reverb)
        scheduleAndPlay(rate: rate)

        guard let audioEngine = audioEngine,
            let audioPlayerNode = audioPlayerNode else {
            return
        }

        do {
            try audioEngine.start()
        } catch {
            throw AudioPlayerError.couldNotStartFile
        }

        // play the recording!
        audioPlayerNode.play()

        delegate?.onAudioPlay()
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

        delegate?.onAudioStop()
    }
}

// MARK: - Support Functions -
extension AudioPlayerController {
    private func getRatePichNode(rate: Float? = nil, pitch: Float? = nil) -> AVAudioUnitTimePitch {
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        return changeRatePitchNode
    }

    private func getEchoNode() -> AVAudioUnitDistortion {
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        return echoNode
    }

    private func getReverbNode() -> AVAudioUnitReverb {
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        return reverbNode
    }

    private func createAndConnectNodes(rate: Float?, pitch: Float?, echo: Bool, reverb: Bool) {
        // initialize audio engine components
        audioEngine = AVAudioEngine()

        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()

        guard let audioEngine = audioEngine,
            let audioPlayerNode = audioPlayerNode else {
            return
        }

        audioEngine.attach(audioPlayerNode)

        // node for adjusting rate/pitch
        let changeRatePitchNode = getRatePichNode(rate: rate, pitch: pitch)
        audioEngine.attach(changeRatePitchNode)

        // node for echo
        let echoNode = getEchoNode()
        audioEngine.attach(echoNode)

        // node for reverb
        let reverbNode = getReverbNode()
        audioEngine.attach(reverbNode)

        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(
                audioPlayerNode,
                changeRatePitchNode,
                echoNode,
                reverbNode,
                audioEngine.outputNode
            )
        } else if echo == true {
            connectAudioNodes(
                audioPlayerNode,
                changeRatePitchNode,
                echoNode,
                audioEngine.outputNode
            )
        } else if reverb == true {
            connectAudioNodes(
                audioPlayerNode,
                changeRatePitchNode,
                reverbNode,
                audioEngine.outputNode
            )
        } else {
            connectAudioNodes(
                audioPlayerNode,
                changeRatePitchNode,
                audioEngine.outputNode
            )
        }
    }

    private func scheduleAndPlay(rate: Float?) {
        guard let audioPlayerNode = audioPlayerNode,
            let audioFile = audioFile else {
            return
        }

        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            guard let audioPlayerNode = self.audioPlayerNode,
                let audioFile = self.audioFile,
                let lastRenderTime = audioPlayerNode.lastRenderTime
                else {
                return
            }
            var delayInSeconds: Double = 0
            if let playerTime = audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {

                if let rate = rate {
                    delayInSeconds =
                        Double(audioFile.length - playerTime.sampleTime)
                        / Double(audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds =
                        Double(audioFile.length - playerTime.sampleTime)
                        / Double(audioFile.processingFormat.sampleRate)
                }
            }
            self.stopSchedule(delayInSeconds: delayInSeconds)
        }
    }

    private func stopSchedule(delayInSeconds: Double) {
        // schedule a stop timer for when audio finishes playing
        self.stopTimer = Timer(
            timeInterval: delayInSeconds,
            target: self,
            selector: #selector(self.stopAudio),
            userInfo: nil,
            repeats: false
        )
        if let stopTimer = self.stopTimer {
            RunLoop.main.add(stopTimer, forMode: RunLoop.Mode.default)
        }
    }
}
