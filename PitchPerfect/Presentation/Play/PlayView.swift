//
//  PlayView.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class PlayView: UIView {

    private lazy var buttons: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: CircleLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.register(ButtonCell.self, forCellWithReuseIdentifier: "buttons")
        collection.backgroundColor = .white
        return collection
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

    func reset() {
        buttons.invalidateIntrinsicContentSize()
    }

    private func configUI(_ state: State = .waiting) {
        addSubview(buttons)

        buttons.edgesToSuperview(insets: .horizontal(Values.Dimen.playSoundMargins), usingSafeArea: true)
    }

    private func addTaps() {
    }
}

// MARK: - Actions -
extension PlayView {
}

// MARK: - State Machine -
extension PlayView {
    private enum State {
        case waiting
        case playing
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

        return cell!
    }
}
