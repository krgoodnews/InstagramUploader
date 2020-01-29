//
//  UIView+.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/23.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    for subview in views {
      addSubview(subview)
    }
  }

  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}
