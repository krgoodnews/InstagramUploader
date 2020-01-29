//
//  UploadImageViewController.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/22.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit
import Photos

import RxSwift
import SnapKit
import Then

/// 스샷을 Pick하고 업로드하기 위한 VC
final class UploadImageViewController: UIViewController {

  private let viewModel: UploadImageViewModel
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
    self.changeRatioButton
  ]).then {
    $0.distribution = .fillEqually
    $0.spacing = 16
  }

  private lazy var pickImageButton = UIButton().then {
    $0.setImage(UIImage(named: "iconAddPhoto"), for: .normal)
    $0.tintColor = UIColor.label.withAlphaComponent(0.7)
    $0.addTarget(self, action: #selector(didTapPick), for: .touchUpInside)
  }

  private lazy var changeBackgroundButton = UIButton().then {
    $0.tintColor = UIColor.label.withAlphaComponent(0.7)
    $0.addTarget(self, action: #selector(didTapChangeBackground), for: .touchUpInside)
  }

  private lazy var changeRatioButton = UIButton().then {
    $0.tintColor = UIColor.label.withAlphaComponent(0.7)
    $0.addTarget(self, action: #selector(didTapChangeRatio), for: .touchUpInside)
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
    postImageToInstagram(image: imageProcessView.asImage())
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
        self.present(alertController, animated: true, completion: nil)
      }
    }
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
  init(viewModel: UploadImageViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let selectedImage = info[.originalImage] as? UIImage else { return }
      self.imageProcessView.image = selectedImage
      dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
    }
}
