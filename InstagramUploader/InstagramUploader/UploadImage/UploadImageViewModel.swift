//
//  UploadImageViewModel.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/25.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class UploadImageViewModel {

  enum ImageRatioType {
    case square
    case portrait
    case landscape

    var buttonIcon: UIImage? {
      switch self {
      case .square:
        return UIImage(named: "iconRatio11")
      case .portrait:
        return UIImage(named: "iconRatio45")
      case .landscape:
        return UIImage(named: "iconRatio54")
      }
    }

    var heightRatio: CGFloat {
      switch self {
      case .square:
        return 1.0
      case .portrait:
        return 1.25
      case .landscape:
        return 0.8
      }
    }
  }

  enum BackgroundType {
    case blur
    case color(UIColor)
  }

  let bindableImageRatio = BehaviorRelay<ImageRatioType>(value: .portrait)
  let bindableBackground = BehaviorRelay<BackgroundType>(value: .blur)

  func changeRatio() {
    switch bindableImageRatio.value {
    case .square:
      bindableImageRatio.accept(.portrait)
    case .portrait:
      bindableImageRatio.accept(.landscape)
    case .landscape:
      bindableImageRatio.accept(.square)
    }
  }

  func changeBackground() {
    switch bindableBackground.value {
    case .blur:
      bindableBackground.accept(.color(.black))
    case .color(_):
      bindableBackground.accept(.blur)
    }
  }

}
