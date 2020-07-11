//
//  AudioFileModel.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 23/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import AVFoundation

class AudioRecorderController: NSObject, AVAudioRecorderDelegate{
    
    // MARK: Private Properties
    private var audioRecorder:AVAudioRecorder!
    private var functionToCallBack:((Bool) -> Void)!
    
    var url:URL{
        get {
            return audioRecorder.url
        }
    }
    
    // MARK: Public Methods
    init(fileName:String, functionToCallWhenFinish:@escaping ((Bool) -> Void)){
        super.init()
        
        functionToCallBack = functionToCallWhenFinish
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = fileName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try? audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.delegate = self
    }
    
    public func startRecording(){
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    public func stopRecording(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
    
    // MARK: AVAudioRecorderDelegate Functions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        functionToCallBack(flag)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
