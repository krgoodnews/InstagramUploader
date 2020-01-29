//
//  ProcessImageViewController.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/22.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit
import Then

private let contentColor = UIColor.label.withAlphaComponent(0.7)

/// 스샷을 Pick하고 업로드하기 위한 VC
final class ProcessImageViewController: UIViewController {

  private let viewModel: ProcessImageViewModel
  private let disposeBag = DisposeBag()

  private func setupObserver() {
    viewModel.bindableImageRatio.bind { [weak self] ratio in
      guard let self = self else { return }
      self.changeRatioButton.setImage(ratio.buttonIcon, for: .normal)
      self.imageProcessView.snp.remakeConstraints {
        $0.centerY.equalToSuperview().offset(-68)
        $0.left.right.equalToSuperview()
        $0.height.equalTo(self.imageProcessView.snp.width).multipliedBy(ratio.heightRatio)
      }
      UIView.animate(withDuration: 0.2) {
        self.view.layoutIfNeeded()
      }
    }.disposed(by: disposeBag)

    viewModel.bindableBackground.bind { [weak self] background in
      guard let self = self else { return }
      switch background {
      case .blur:
        self.changeBackgroundButton.setTitle("블러", for: .normal)
      case .color(_):
        self.changeBackgroundButton.setTitle("컬러", for: .normal)
      }
    }.disposed(by: disposeBag)
  }

  // MARK: - Views

  private lazy var imagePicker = UIImagePickerController().then {
    $0.sourceType = .photoLibrary
    $0.delegate = self
  }

  private lazy var buttonsStackView = UIStackView(arrangedSubviews: [
    self.pickImageButton,
    self.changeBackgroundButton,
    self.changeRatioButton,
    self.shareButton
  ]).then {
    $0.distribution = .fillEqually
    $0.spacing = 16
  }

  private lazy var pickImageButton = UIButton().then {
    $0.setImage(UIImage(named: "iconAddPhoto"), for: .normal)
    $0.tintColor = contentColor
    $0.addTarget(self, action: #selector(didTapPick), for: .touchUpInside)
  }

  private lazy var changeBackgroundButton = UIButton().then {
    $0.isHidden = true
    $0.tintColor = contentColor
    $0.setTitleColor(contentColor, for: .normal)
    $0.addTarget(self, action: #selector(didTapChangeBackground), for: .touchUpInside)
  }

  private lazy var changeRatioButton = UIButton().then {
    $0.isHidden = true
    $0.tintColor = contentColor
    $0.addTarget(self, action: #selector(didTapChangeRatio), for: .touchUpInside)
  }

  private lazy var shareButton = UIButton().then {
    $0.isHidden = true
    $0.setTitle("Share", for: .normal)
    $0.setTitleColor(contentColor, for: .normal)
    $0.tintColor = contentColor
    $0.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
  }

  private lazy var imageProcessView = ImageProcessView(viewModel: viewModel)

  private func setupViews() {
    // setup Nav Bar
    let infoButton = UIButton(type: .infoLight).then {
      $0.contentHorizontalAlignment = .right
      $0.frame = .init(x: 0, y: 0, width: 52, height: 44)
      $0.tintColor = .label
      $0.addTarget(self, action: #selector(didTapSetting), for: .touchUpInside)
    }

    let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
    navigationItem.rightBarButtonItem = infoBarButtonItem

    navigationController?.navigationBar.do {
      $0.backgroundColor = .clear
      $0.isTranslucent = false
    }

    view.backgroundColor = .secondarySystemBackground

    // setup Layout
    view.addSubviews(buttonsStackView, imageProcessView)

    buttonsStackView.snp.makeConstraints {
      $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.height.equalTo(60)
    }

    // Deco
    let stackViewsBackgroundView = UIView().then {
      $0.layer.cornerRadius = 12
      $0.backgroundColor = .systemGray5
    }
    view.insertSubview(stackViewsBackgroundView, belowSubview: buttonsStackView)

    stackViewsBackgroundView.snp.makeConstraints {
      $0.edges.equalTo(buttonsStackView)
    }

  }

  @objc private func didTapSetting() {
    let appInfoVC = AppInfoViewController()
    navigationController?.pushViewController(appInfoVC, animated: true)
  }

  @objc private func didTapShare() {
    viewModel.postImageToInstagram(image: imageProcessView.asImage())
  }

  @objc private func didTapPick() {
    present(imagePicker, animated: true, completion: nil)
  }

  @objc private func didTapChangeRatio() {
    viewModel.changeRatio()
  }

  @objc private func didTapChangeBackground() {
    viewModel.changeBackground()
  }

  // MARK: - View Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupObserver()
  }

  // MARK: - Init
  init(viewModel: ProcessImageViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension ProcessImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let selectedImage = info[.originalImage] as? UIImage else { return }
    self.imageProcessView.image = selectedImage
    changeRatioButton.isHidden = false
    changeBackgroundButton.isHidden = false
    shareButton.isHidden = false
    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
