//
//  PlayController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class PlayController: UIViewController {
    var recordedAudioURL: URL?

    private let rootView = PlayView()

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.PlaySounds.title
    }

}
