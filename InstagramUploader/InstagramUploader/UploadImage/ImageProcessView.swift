//
//  ImageProcessView.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/23.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class ImageProcessView: UIView {

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
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
