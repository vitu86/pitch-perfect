//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 22/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // MARK: Properties
    private var audioRecorder:AVAudioRecorder!
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToPlaySounds"){
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: IBActions
    @IBAction func recordAudio(_ sender: Any) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
                
        configureUI(recording: true)
    }

    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        configureUI(recording: false)
    }
    
    // MARK: private functions
    private func configureUI(recording:Bool){
        if(recording){
            recordButton.isEnabled = false
            stopRecordButton.isEnabled = true
            recordLabel.text = "Recording in progress"
        }else{
            recordButton.isEnabled = true
            stopRecordButton.isEnabled = false
            recordLabel.text = "Tap to record"
        }
    }
    
    // MARK: AVAudioRecorderDelegate Functions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finalizou a gravação")
        if(flag){
            performSegue(withIdentifier: "segueToPlaySounds", sender: audioRecorder.url)
        }else{
            print("Recording was not successfull")
        }
    }
    
}
