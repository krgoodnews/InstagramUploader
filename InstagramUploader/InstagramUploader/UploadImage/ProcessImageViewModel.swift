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
                return UIImage(named: "iconRatioSquare")
            case .portrait:
                return UIImage(named: "iconRatioPortrait")
            case .landscape:
                return UIImage(named: "iconRatioLandscape")
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

    // Inputs
    let backgroundTapEvent = PublishRelay<Void>()
    let ratioTapEvent = PublishRelay<Void>()
    let selectImageEvent = PublishRelay<UIImage?>()

    // Outputs
    let bindableImageRatio = BehaviorRelay<ImageRatioType>(value: .portrait)
    let bindableBackground = BehaviorRelay<BackgroundType>(value: .blur)
    let bindableImage = BehaviorRelay<UIImage?>(value: nil)

    private let disposeBag = DisposeBag()

    override init() {
        super.init()
        setupRx()
    }

    private func setupRx() {
        backgroundTapEvent.subscribe(onNext: { [weak self] _ in
            self?.changeBackground()
        }).disposed(by: disposeBag)

        ratioTapEvent.subscribe(onNext: { [weak self] _ in
            self?.changeRatio()
        }).disposed(by: disposeBag)

        selectImageEvent.subscribe(onNext: { [weak self] image in
            self?.bindableImage.accept(image)
        }).disposed(by: disposeBag)
    }

    private func changeRatio() {
        switch bindableImageRatio.value {
        case .square:
            bindableImageRatio.accept(.portrait)
        case .portrait:
            bindableImageRatio.accept(.landscape)
        case .landscape:
            bindableImageRatio.accept(.square)
        }
    }

    private func changeBackground() {
        switch bindableBackground.value {
        case .blur:
            bindableBackground.accept(.color(.black))
        case .color(_):
            bindableBackground.accept(.blur)
        }
    }
}
