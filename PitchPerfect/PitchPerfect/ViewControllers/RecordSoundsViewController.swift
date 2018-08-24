//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 22/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class RecordSoundsViewController: UIViewController{

    // MARK: IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // MARK: Private Properties
    private var audioFile:AudioFileModel!
        
    // MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        audioFile = AudioFileModel(fileName: "recordedVoice.wav", functionToCallWhenFinish: onAudioStopped)
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
        audioFile.startRecording()
        configureUI(recording: true)
    }

    @IBAction func stopRecording(_ sender: Any) {
        audioFile.stopRecording()
        configureUI(recording: false)
    }
    
    // MARK: Private Functions
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
    
    private func onAudioStopped(success:Bool){
        if(success){
            performSegue(withIdentifier: "segueToPlaySounds", sender: audioFile.url)
        }else{
            //Record not finished properly
        }
    }
    
}
