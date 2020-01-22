//
//  UploadImageViewController.swift
//  InstagramUploader
//
//  Created by Yunsu Guk on 2020/01/22.
//  Copyright © 2020 Yunsu Guk. All rights reserved.
//

import UIKit
import Photos

import SnapKit
import Then

/// 스샷을 Pick하고 업로드하기 위한 VC
final class UploadImageViewController: UIViewController {

  // MARK: - View Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  // MARK: - Views

  private lazy var imagePicker = UIImagePickerController().then {
    $0.sourceType = .photoLibrary
    $0.delegate = self
  }

  private lazy var pickImageButton = UIButton().then {
    $0.setTitle("이미지 고르기", for: .normal)
    $0.backgroundColor = .systemRed
    $0.layer.cornerRadius = 12
    $0.addTarget(self, action: #selector(didTapPick), for: .touchUpInside)
  }

  private let imageProcessView = ImageProcessView()

  private func setupViews() {
    // setup Nav Bar
    let shareBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapShare))
    navigationItem.rightBarButtonItem = shareBarButton

    // setup Layout
    view.addSubviews(pickImageButton, imageProcessView)

    pickImageButton.snp.makeConstraints {
      $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.height.equalTo(52)
    }

    imageProcessView.snp.makeConstraints {
      $0.centerY.equalToSuperview().offset(-26)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(imageProcessView.snp.width)
    }
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
