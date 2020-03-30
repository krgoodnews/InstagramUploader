//
//  UIFont+.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/03/30.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

extension UIFont {

  /**
   디자인 Zeplin에 명시된 사이즈를 이용해 preferredFont를 반환한다.
   기대효과: iOS기기 옵션에서 텍스트 크기를 변경했을 때 폰트 사이즈가 동적으로 변경된다. .systemFont(CGFloat)로는 변경되지 않음.
   단점: Range를 이용해 적절한 Font Size를 적용하기에 제플린처럼 정확하진 않음.
   */
  static func preferred(ofSize fontSize: CGFloat, weight: Weight = .regular) -> UIFont {
    switch fontSize {
    case 34 ... CGFloat.greatestFiniteMagnitude:
      return .preferredFont(for: .largeTitle, weight: weight)

    case 28 ..< 34:
      return .preferredFont(for: .title1, weight: weight)

    case 22 ..< 28:
      return .preferredFont(for: .title2, weight: weight)

    case 18 ..< 22:
      return .preferredFont(for: .title3, weight: weight)

    case 17 ..< 18:
      return .preferredFont(for: .body, weight: weight)

    case 16 ..< 17:
      return .preferredFont(for: .callout, weight: weight)

    case 14 ..< 16:
      return .preferredFont(for: .subheadline, weight: weight)

    case 13 ..< 14:
      return .preferredFont(for: .footnote, weight: weight)

    case 12 ..< 13:
      return .preferredFont(for: .caption1, weight: weight)

    default:
      return .preferredFont(for: .caption2, weight: weight)
    }

  }

  static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
    return metrics.scaledFont(for: font)
  }
}

