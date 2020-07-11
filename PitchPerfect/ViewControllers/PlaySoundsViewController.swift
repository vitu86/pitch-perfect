//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 22/08/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    // MARK: Public Properties
    var recordedAudioURL: URL!

    // MARK: Private Properties
    private var audioPlayer: AudioPlayerController!

    enum ButtonType: Int {
        case slow = 0
        case fast, highPitch, lowPitch, echo, reverb
    }

    // MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        readjustButton()
        audioPlayer = AudioPlayerController(
            fileURL: recordedAudioURL, functionToHandleErrors: onAudioControllerError,
            functionToHandleStates: onAudioControllerStates)
    }

    // MARK: Private Functions
    private func onAudioControllerError(error: String) {
        showAlert(
            title: NSLocalizedString(
                "error", comment: "The word 'error' capitalized to be used in alert popup's title"),
            message: error)
    }

    private func onAudioControllerStates(event: AudioPlayerController.StateHelper) {
        switch event {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }

    // Adjusting buttons's mode so they don't stretch on screen in landscape mode
    private func readjustButton() {
        slowButton.contentMode = .center
        slowButton.imageView?.contentMode = .scaleAspectFit

        highPitchButton.contentMode = .center
        highPitchButton.imageView?.contentMode = .scaleAspectFit

        fastButton.contentMode = .center
        fastButton.imageView?.contentMode = .scaleAspectFit

        lowPitchButton.contentMode = .center
        lowPitchButton.imageView?.contentMode = .scaleAspectFit

        echoButton.contentMode = .center
        echoButton.imageView?.contentMode = .scaleAspectFit

        reverbButton.contentMode = .center
        reverbButton.imageView?.contentMode = .scaleAspectFit
    }

    private func setPlayButtonsEnabled(_ enabled: Bool) {
        slowButton.isEnabled = enabled
        highPitchButton.isEnabled = enabled
        fastButton.isEnabled = enabled
        lowPitchButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: IBActions
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            audioPlayer.playSound(rate: 0.5)
        case .fast:
            audioPlayer.playSound(rate: 1.5)
        case .highPitch:
            audioPlayer.playSound(pitch: 1000)
        case .lowPitch:
            audioPlayer.playSound(pitch: -1000)
        case .echo:
            audioPlayer.playSound(echo: true)
        case .reverb:
            audioPlayer.playSound(reverb: true)
        }
    }

    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        audioPlayer.stopAudio()
    }
}
