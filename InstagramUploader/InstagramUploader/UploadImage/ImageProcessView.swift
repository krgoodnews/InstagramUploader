//
//  ImageProcessView.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/23.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class ImageProcessView: UIView {

  private let viewModel: ProcessImageViewModel
  private let disposeBag = DisposeBag()

  private func setupObserver() {
    viewModel.bindableBackground.bind { [weak self] background in
      guard let self = self else { return }
      UIView.animate(withDuration: 0.2) {
        self.updateBackground(background)
      }
    }.disposed(by: disposeBag)
  }

  private func updateBackground(_ background: ProcessImageViewModel.BackgroundType) {
    switch background {
    case .blur:
      self.imageView.backgroundColor = .clear
    case .color(let color):
      self.imageView.backgroundColor = color
    }
  }

  var image: UIImage? {
    didSet {
      backgroundImageView.image = image?.blurred(radius: 50)
      imageView.image = image
    }
  }

  // MARK: - Views

  private let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private func setupView() {
    clipsToBounds = true
    addSubviews(backgroundImageView, imageView)

    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  // MARK: - Init
  init(viewModel: ProcessImageViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupView()
    setupObserver()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
