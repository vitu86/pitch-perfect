//
//  PlayController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class PlayController: UIViewController {
    var recordedAudioURL: URL? {
        didSet {
            audioPlayer = try? AudioPlayerController(fileURL: recordedAudioURL)
            audioPlayer?.delegate = self
        }
    }

    private let rootView = PlayView()
    private var audioPlayer: AudioPlayerController?
    private var audioPlaying: Bool = false

    override func loadView() {
        view = rootView
        rootView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.PlaySounds.title
    }
}

extension PlayController: PlayViewDelegate {
    func onButtonTapped(_ button: ButtonCell) {
        guard let style = button.style,
            !rootView.isPlaying else {
            return
        }

        switch style {
        case .slow:
            try? audioPlayer?.playSound(rate: 0.5)

        case .fast:
            try? audioPlayer?.playSound(rate: 1.5)

        case .highPitch:
            try? audioPlayer?.playSound(pitch: 1_000)

        case .lowPitch:
            try? audioPlayer?.playSound(pitch: -1_000)

        case .echo:
            try? audioPlayer?.playSound(echo: true)

        case .reverb:
            try? audioPlayer?.playSound(reverb: true)

        }
    }

    func onPauseTapped() {
        audioPlayer?.stopAudio()
    }
}

extension PlayController: AudioPlayerDelegate {
    func onAudioPlay() {
        rootView.reset(isPlaying: true)
    }

    func onAudioStop() {
        rootView.reset(isPlaying: false)
    }
}
