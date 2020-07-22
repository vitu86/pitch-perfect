//
//  HomeController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class HomeController: BaseController {

    private var audioFile: AudioRecorderController?

    private let viewModel: HomeViewModel

    private lazy var rootView: HomeView = {
        let home = HomeView()
        home.delegate = self
        return home
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Home.title

        audioFile = try? AudioRecorderController(fileName: "recordedVoice.wav")
        audioFile?.delegate = self
    }
}

// MARK: - Actions -
extension HomeController: HomeViewDelegate, AudioRecorderDelegate {
    func onStartRecordTapped() {
        audioFile?.startRecording()
    }

    func onStopRecordTapped() {
        audioFile?.stopRecording()
    }

    func onRecordStopped(_ successfully: Bool) {
        showPlaySound()
    }

    private func showPlaySound() {
        hideNextTitleButtonNavBar()
        viewModel.triggerPlay(with: audioFile?.url)
    }
}

private extension UIViewController {
    func hideNextTitleButtonNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
