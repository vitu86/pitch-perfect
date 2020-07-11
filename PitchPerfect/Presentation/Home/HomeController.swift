//
//  HomeController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    private lazy var rootView: HomeView = {
        let home = HomeView()
        home.delegate = self
        return home
    }()

    override func loadView() {
        view = rootView
    }
}

// MARK: - Actions -
extension HomeController: HomeViewDelegate {
    func onStartRecordTapped() {
        print("Startou a gravação")
    }

    func onStopRecordTapped() {
        print("Stopou a gravação")
    }
}
