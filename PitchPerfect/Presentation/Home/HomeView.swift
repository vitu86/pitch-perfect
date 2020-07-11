//
//  HomeView.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    private let recordButton: UIButton = {
        let button = UIButton()
        button.frame = .init(origin: .zero, size: .init(width: 350, height: 250))
        button.setTitle(L10n.tapToRecord, for: .normal)
        button.setImage(Asset.record.image, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .red
        addButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func addButtons() {
        addSubview(recordButton)
    }
}


