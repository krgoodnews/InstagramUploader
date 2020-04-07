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

  private func bindOutput() {
      viewModel.bindableImageRatio.bind { [weak self] ratio in
          guard let self = self else { return }
          self.didSetRatio(ratio)
      }.disposed(by: disposeBag)
  }
  
  private func bindInput() {
      changeBackgroundButton
          .rx
          .tap
          .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
          .bind(to: viewModel.backgroundTapEvent)
          .disposed(by: disposeBag)
      
      changeRatioButton
          .rx
          .tap
          .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
          .bind(to: viewModel.ratioTapEvent)
          .disposed(by: disposeBag)
  }
    
  // MARK: - Inputs

  @objc private func didTapAppInfo() {
    let appInfoVC = AppInfoViewController()
    navigationController?.pushViewController(appInfoVC, animated: true)
  }

  // MARK: Buttons stack view

  @objc private func didTapShare(_ sender: UIButton) {
    let activityVC = UIActivityViewController(
      activityItems: [imageProcessView.asImage()],
      applicationActivities: nil)

    activityVC.popoverPresentationController?.do {
      $0.sourceView = sender
      $0.sourceRect = sender.bounds
    }

    self.present(activityVC, animated: true, completion: nil)
  }

  @objc private func didTapPick() {

    present(imagePicker, animated: true, completion: nil)
  }

  // MARK: - Outputs

  private func didSetRatio(_ ratio: ProcessImageViewModel.ImageRatioType) {
    changeRatioButton.setImage(ratio.buttonIcon, for: .normal)
    imageProcessView.snp.remakeConstraints {
      $0.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(16)
      $0.left.greaterThanOrEqualTo(view.safeAreaLayoutGuide)
      $0.right.lessThanOrEqualTo(view.safeAreaLayoutGuide)
      $0.bottom.lessThanOrEqualTo(buttonsStackView.snp.top).offset(-16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(imageProcessView.snp.width).multipliedBy(ratio.heightRatio)
      $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-34)
    }
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    }
  }

  // MARK: - Views

  /// for Photo Select
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
    $0.alignment = .center
  }

  private lazy var pickImageButton = CenteredButton().then {
    $0.setTitle("New Image", for: .normal)
    $0.titleLabel?.font = .preferred(ofSize: 10
      , weight: .regular)
    $0.setTitleColor(contentColor, for: .normal)
    $0.setImage(UIImage(named: "iconAddPhoto"), for: .normal)
    $0.tintColor = contentColor
    $0.addTarget(self, action: #selector(didTapPick), for: .touchUpInside)
  }

  private let changeBackgroundButton = CenteredButton().then {
    $0.setTitle("Background", for: .normal)
    $0.titleLabel?.font = .preferred(ofSize: 10, weight: .regular)
    $0.setTitleColor(contentColor, for: .normal)
    $0.isHidden = true
    $0.tintColor = contentColor
    $0.setImage(UIImage(named: "iconBackground"), for: .normal)
  }

  private let changeRatioButton = CenteredButton().then {
    $0.setTitle("Ratio", for: .normal)
    $0.titleLabel?.font = .preferred(ofSize: 10, weight: .regular)
    $0.setTitleColor(contentColor, for: .normal)
    $0.isHidden = true
    $0.tintColor = contentColor
  }

  private lazy var shareButton = CenteredButton().then {
    $0.setTitle("Share", for: .normal)
    $0.titleLabel?.font = .preferred(ofSize: 10, weight: .regular)
    $0.setTitleColor(contentColor, for: .normal)
    $0.isHidden = true
    $0.setImage(UIImage(named: "iconAction"), for: .normal)
    $0.tintColor = contentColor
    $0.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
  }

  /// 실제 편집된 이미지가 표시되는 View
  private lazy var imageProcessView = ImageProcessView(viewModel: viewModel)

  private let guideLabel = UILabel().then {
    $0.text = "아래 버튼으로 사진을 불러오세요"
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }

  private func setupViews() {
    // setup Nav Bar
    let infoButton = UIButton(type: .infoLight).then {
      $0.contentHorizontalAlignment = .right
      $0.frame = .init(x: 0, y: 0, width: 52, height: 44)
      $0.tintColor = .label
      $0.addTarget(self, action: #selector(didTapAppInfo), for: .touchUpInside)
    }

    let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
    navigationItem.rightBarButtonItem = infoBarButtonItem

    navigationController?.navigationBar.do {
      $0.backgroundColor = .clear
      $0.isTranslucent = false
    }

    view.backgroundColor = .systemGray

    // setup Layout
    view.addSubviews(buttonsStackView, guideLabel, imageProcessView)

    buttonsStackView.snp.makeConstraints {
      $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
      $0.height.equalTo(52)
    }

    guideLabel.snp.makeConstraints {
      $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.bottom.equalTo(buttonsStackView.snp.top).offset(-16)
    }

    // Deco
    let stackViewsBackgroundView = UIView().then {
      $0.layer.cornerRadius = 12
      $0.backgroundColor = .systemGray5
    }
    view.insertSubview(stackViewsBackgroundView, belowSubview: buttonsStackView)

    stackViewsBackgroundView.snp.makeConstraints {
      $0.edges.equalTo(buttonsStackView).inset(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
    }
  }

  // MARK: - View Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    bindInput()
    bindOutput()
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
    self.guideLabel.text = ""
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
