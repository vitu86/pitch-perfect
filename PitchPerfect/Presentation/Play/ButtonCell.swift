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
            buttonImage.image = style?.getImage()
        }
    }

    private lazy var buttonImage: UIImageView = {
        let image = UIImageView()
        image.image = style?.getImage()
        return image
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
        case highPich
        case lowPich
        case reverb
        case slow

        func getImage() -> UIImage {
            switch self {
            case .echo:
                return Asset.Buttons.PlaySound.echo.image

            case .fast:
                return Asset.Buttons.PlaySound.fast.image

            case .highPich:
                return Asset.Buttons.PlaySound.highPitch.image

            case .lowPich:
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
            case 2: self = .highPich
            case 3: self = .lowPich
            case 4: self = .reverb
            default: self = .slow
            }
        }

    }
}
