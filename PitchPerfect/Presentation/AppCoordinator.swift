//
//  AppCoordinator.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 21/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import AVFoundation
import XCoordinator

enum AppRoute: Route {
    case record
    case play(URL?)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    init() {
        super.init(initialRoute: .record)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .record:
            return .set([
                HomeController(
                    viewModel: HomeViewModel(
                        router: weakRouter
                    )
                )
            ])

        case let .play(url):
            let controller = PlayController()
            controller.recordedAudioURL = url
            return .push(controller)
        }
    }
}
