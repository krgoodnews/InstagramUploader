//
//  UIImage+.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/23.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

extension UIImage {
  func blurred(radius: CGFloat) -> UIImage {
    let ciContext = CIContext(options: nil)
    guard let cgImage = cgImage else { return self }
    let inputImage = CIImage(cgImage: cgImage)
    guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
    ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
    ciFilter.setValue(radius, forKey: "inputRadius")
    guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
    guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
    return UIImage(cgImage: cgImage2)
  }
}
