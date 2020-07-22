//
//  AudioFileModel.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 23/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import AVFoundation

enum AudioRecorderError: Error {
    case filePathNotFound
    case audioSessionCouldNotStart
    case audioRecorderCouldNotStart
}

protocol AudioRecorderDelegate: AnyObject {
    func onRecordStopped(_ successfully: Bool)
}

class AudioRecorderController: NSObject {

    weak var delegate: AudioRecorderDelegate?

    // MARK: Private Properties
    private var audioRecorder: AVAudioRecorder?

    var url: URL? {
        return audioRecorder?.url
    }

    // MARK: Public Methods
    init(fileName: String) throws {
        super.init()

        let dirPath =
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            as String
        let recordingName = fileName
        let pathArray = [dirPath, recordingName]
        let nullableFilePath = URL(string: pathArray.joined(separator: "/"))

        guard let filePath = nullableFilePath else {
            throw AudioRecorderError.filePathNotFound
        }

        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(
                AVAudioSession.Category(
                    rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)
                ),
                options: AVAudioSession.CategoryOptions.defaultToSpeaker
            )
        } catch {
            throw AudioRecorderError.audioSessionCouldNotStart
        }

        do {
            try audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.delegate = self
        } catch {
            throw AudioRecorderError.audioRecorderCouldNotStart
        }

    }

    func startRecording() {
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }

    func stopRecording() {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }

}

extension AudioRecorderController: AVAudioRecorderDelegate {
    // MARK: AVAudioRecorderDelegate Functions
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate?.onRecordStopped(flag)
    }
}
