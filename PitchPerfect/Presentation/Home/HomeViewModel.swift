//
//  HomeViewModel.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 21/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import AVFoundation
import XCoordinator

class HomeViewModel {
    private let router: WeakRouter<AppRoute>

    init(router: WeakRouter<AppRoute>) {
        self.router = router
    }

    func triggerPlay(with file: URL?) {
        router.trigger(.play(file))
    }

    func getPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
