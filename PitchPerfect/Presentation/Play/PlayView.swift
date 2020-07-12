//
//  PlayView.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

protocol PlayViewDelegate: AnyObject {
    func onButtonTapped(_ button: ButtonCell)
    func onPauseTapped()
}

class PlayView: UIView {

    weak var delegate: PlayViewDelegate?
    var isPlaying: Bool = false

    private lazy var buttons: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: CircleLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.register(ButtonCell.self, forCellWithReuseIdentifier: "buttons")
        collection.backgroundColor = .white
        return collection
    }()

    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Buttons.Home.stop.image, for: .normal)
        button.isEnabled = false
        return button
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
extension PlayView {

    func reset(isPlaying: Bool) {
        self.isPlaying = isPlaying
        pauseButton.isEnabled = isPlaying
        buttons.reloadData()
    }

    private func configUI() {
        addSubview(buttons)
        addSubview(pauseButton)

        buttons.edgesToSuperview(insets: .horizontal(Values.Dimen.playSoundMargins), usingSafeArea: true)

        pauseButton.center(in: buttons)
        pauseButton.aspectRatio(Values.Dimen.homeAspectRatio)
        pauseButton.width(Values.Dimen.homeButtonSize)
    }

    private func addTaps() {
        pauseButton.addTarget(self, action: #selector(onPauseTapped), for: .touchUpInside)
    }
}

// MARK: - Actions -
extension PlayView {
    @objc private func onPauseTapped() {
        delegate?.onPauseTapped()
    }
}

// MARK: - CollectonView Functions -
extension PlayView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttons", for: indexPath) as? ButtonCell
        if cell == nil {
            cell = ButtonCell()
        }

        cell?.style = .init(position: indexPath.row)
        cell?.canTouch = !isPlaying

        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let button = collectionView.cellForItem(at: indexPath) as?  ButtonCell else {
            return
        }
        delegate?.onButtonTapped(button)
    }
}
