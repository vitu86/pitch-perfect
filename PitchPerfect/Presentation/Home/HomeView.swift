//
//  HomeView.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import TinyConstraints
import UIKit

protocol HomeViewDelegate: AnyObject {
    func onStartRecordTapped()
    func onStopRecordTapped()
}

class HomeView: UIView {

    weak var delegate: HomeViewDelegate?

    private let uiContainer = UIView()

    private let recordButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Buttons.Home.record.image, for: .normal)
        return button
    }()

    private let stopButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Buttons.Home.stop.image, for: .normal)
        button.isEnabled = false
        return button
    }()

    private let stateLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Home.tapToRecord
        return label
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        configUI()
        addTaps()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Config -
extension HomeView {
    private func configUI(_ state: State = .waiting) {
        addSubview(uiContainer)

        uiContainer.addSubview(recordButton)
        uiContainer.addSubview(stateLabel)
        uiContainer.addSubview(stopButton)

        recordButton.isEnabled = state == .waiting
        stopButton.isEnabled = state == .recording
        stateLabel.text = state == .waiting ? L10n.Home.tapToRecord : L10n.Home.recordingInProgress

        recordButton.topToSuperview()
        recordButton.centerXToSuperview()
        recordButton.aspectRatio(Values.Dimen.homeAspectRatio)
        recordButton.width(Values.Dimen.homeButtonSize)

        stateLabel.centerXToSuperview()
        stateLabel.topToBottom(
            of: recordButton,
            offset: Values.Dimen.homeTopToBottomSpace
        )

        stopButton.centerXToSuperview()
        stopButton.topToBottom(
            of: stateLabel,
            offset: Values.Dimen.homeTopToBottomSpace
        )
        stopButton.aspectRatio(Values.Dimen.homeAspectRatio)
        stopButton.width(Values.Dimen.homeButtonSize)
        stopButton.bottomToSuperview()

        uiContainer.centerYToSuperview()
        uiContainer.horizontalToSuperview()
    }

    private func addTaps() {
        recordButton.addTarget(self, action: #selector(onStartRecordTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(onStopRecordTapped), for: .touchUpInside)
    }
}

// MARK: - Actions -
extension HomeView {
    @objc private func onStartRecordTapped() {
        configUI(.recording)
        delegate?.onStartRecordTapped()
    }

    @objc private func onStopRecordTapped() {
        configUI(.waiting)
        delegate?.onStopRecordTapped()
    }
}

// MARK: - State Machine -
extension HomeView {
    private enum State {
        case waiting
        case recording
    }
}
