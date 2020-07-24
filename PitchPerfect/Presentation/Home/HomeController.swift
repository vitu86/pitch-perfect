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

// MARK: - Delegates -
extension HomeController: HomeViewDelegate, AudioRecorderDelegate {
    func onStartRecordTapped() {
        viewModel.getPermission(completion: { canRecord in
            DispatchQueue.main.async {
                if canRecord {
                    self.startRecord()
                } else {
                    self.showPermissionAlert()
                }
            } }
        )
    }

    func onStopRecordTapped() {
        rootView.configUI(.waiting)
        audioFile?.stopRecording()
    }

    func onRecordStopped(_ successfully: Bool) {
        showPlaySound()
    }
}

// MARK: - Actions -
extension HomeController {
    private func showPlaySound() {
        hideNextTitleButtonNavBar()
        viewModel.triggerPlay(with: audioFile?.url)
    }

    private func startRecord() {
        rootView.configUI(.recording)
        audioFile?.startRecording()
    }

    private func showPermissionAlert() {
        let alert = UIAlertController(title: nil, message: L10n.Home.permissionError, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: L10n.Home.Alert.settings, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl)
                else {
                    return
            }

            UIApplication.shared.open(settingsUrl)
        }
        alert.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

private extension UIViewController {
    func hideNextTitleButtonNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
