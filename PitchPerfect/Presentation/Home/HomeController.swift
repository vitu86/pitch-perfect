//
//  HomeController.swift
//  PitchPerfect
//
//  Created by Vitor Costa on 10/07/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
  private let rootView = HomeView()

  override func loadView() {
    view = rootView
  }
}
