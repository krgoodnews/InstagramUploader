//
//  ProcessImageViewModel.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/25.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import Photos
import UIKit

import RxCocoa
import RxSwift
import Then

final class ProcessImageViewModel: NSObject {

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

  func postImageToInstagram(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }

  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      print(error)
      return
    }

    let fetchOptions = PHFetchOptions().then {
      $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }

    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    if let lastAsset = fetchResult.firstObject {
      let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!

      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        if var topController = keyWindow?.rootViewController {
          while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
          }
          topController.present(alertController, animated: true, completion: nil)
        }

      }
    }
  }

}
