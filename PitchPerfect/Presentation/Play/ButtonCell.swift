//
//  ButtonCell.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 11/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class ButtonCell: UICollectionViewCell {

    var style: Style? {
        didSet {
            buttonImage.setImage(style?.getImage(), for: .normal)
        }
    }

    var canTouch: Bool = true {
        didSet {
            buttonImage.isEnabled = canTouch
        }
    }

    private lazy var buttonImage: UIButton = {
        let button = UIButton()
        button.setImage(style?.getImage(), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {
        addSubview(buttonImage)
        buttonImage.edgesToSuperview()
    }
}

extension ButtonCell {
    enum Style {
        case echo
        case fast
        case highPitch
        case lowPitch
        case reverb
        case slow

        func getImage() -> UIImage {
            switch self {
            case .echo:
                return Asset.Buttons.PlaySound.echo.image

            case .fast:
                return Asset.Buttons.PlaySound.fast.image

            case .highPitch:
                return Asset.Buttons.PlaySound.highPitch.image

            case .lowPitch:
                return Asset.Buttons.PlaySound.lowPitch.image

            case .reverb:
                return Asset.Buttons.PlaySound.reverb.image

            case .slow:
                return Asset.Buttons.PlaySound.slow.image
            }
        }

        init(position: Int) {
            switch position {
            case 0: self = .echo
            case 1: self = .fast
            case 2: self = .highPitch
            case 3: self = .lowPitch
            case 4: self = .reverb
            default: self = .slow
            }
        }

    }
}
