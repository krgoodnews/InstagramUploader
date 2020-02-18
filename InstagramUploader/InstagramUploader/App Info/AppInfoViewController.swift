//
//  AppInfoViewController.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/29.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

final class AppInfoViewController: UIViewController {

  // MARK: - Views

  private let guideLabel = UILabel().then {
    $0.text = """
    이 앱의 모든 소스코드와
    디자인 리소스는 공개되어 있습니다.
    여러분의 스타와 이슈, PR은
    제게 큰 원동력이 됩니다 :)

    개발: 국윤수
    디자인: 국윤수
    기획: 국윤수
    """
    $0.numberOfLines = 0
  }

  private lazy var githubButton = UIButton().then {
    $0.setTitle("Github 저장소 열기", for: .normal)
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.backgroundColor = .systemGray3
    $0.addTarget(self, action: #selector(didTapGithub), for: .touchUpInside)
  }

  @objc private func didTapGithub() {
    guard let url = URL(string: "https://github.com/krgoodnews/InstagramUploader") else {
      return
    }
    UIApplication.shared.open(url, options: [:])
  }

  private func setupViews() {
    navigationItem.title = "Info"
    view.backgroundColor = .secondarySystemBackground

    view.addSubviews(guideLabel, githubButton)

    guideLabel.snp.makeConstraints {
      $0.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
    }

    githubButton.snp.makeConstraints {
      $0.top.equalTo(guideLabel.snp.bottom).offset(16)
      $0.left.right.equalTo(guideLabel)
      $0.height.equalTo(56)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
}
