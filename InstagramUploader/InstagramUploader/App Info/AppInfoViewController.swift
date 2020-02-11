//
//  AppInfoViewController.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/29.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

final class AppInfoViewController: UIViewController {

  private func setupViews() {
    navigationItem.title = "Info"
    view.backgroundColor = .secondarySystemBackground
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
}
