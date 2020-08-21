//
//  CameraViewController.swift
//  ShopTogether
//
//  Created by Bastien Ravalet on 2020-03-06.
//  Copyright © 2020 Ubiq. All rights reserved.
//

import SwiftUI
import AVFoundation
import UIKit
import CameraManager
import AVKit
import UICircularProgressRing
import Photos

final class CameraViewController: UIViewController {
    private static let identifier = "CameraViewController"
    
    @IBOutlet private weak var previewHolderView: UIView!
    @IBOutlet private weak var videoIndicator: UICircularProgressRing!
    @IBOutlet private weak var videoIndicatorHeight: NSLayoutConstraint!
    @IBOutlet private weak var flipCameraButton: UIButton!
    @IBOutlet private weak var flashModebutton: UIButton!
    @IBOutlet private weak var currentProductImage: UIImageView!
    @IBOutlet private weak var currentProductImageHolderView: UIView!
    @IBOutlet private weak var mediaPickerImg: UIImageView!
    @IBOutlet private weak var mediaPickerHolderView: UIView!
    @IBOutlet private weak var importToolTipView: UIView!
    @IBOutlet private weak var importToolTipBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cameraButton: CircleImageView!
    @IBOutlet private weak var cameraButtonHolderView: UIView!
    @IBOutlet private weak var permissionHolderView: UIView!
    
    //Permissions
    @IBOutlet private weak var cameraPermButton: ConfigurableEnabilityButton!
    @IBOutlet private weak var micPermButton: ConfigurableEnabilityButton!

    class func newInstance() -> CameraViewController {
        let instance = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: self.identifier) as! CameraViewController
        instance.modalPresentationStyle = .fullScreen
//        instance.product = product
        return instance
    }
    
//    private lazy var productPickerVC: ReactionProductPickerViewController = {
//        let instance = ReactionProductPickerViewController.newInstance()
//        instance.delegate = self
//        return instance
//    }()
    
    private var animationLongPress: UILongPressGestureRecognizer!
    private var cameraLongPress: UILongPressGestureRecognizer!
    private var tooltipShowed: Bool = false
//    private var mediaManager = MediaManager()
    private var cameraManager = CameraManager()
    private var cameraOutput = AVCapturePhotoOutput()
    private var isRecording: Bool = false
    
//    private var product: Product?

    private lazy var mediaPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.image", "public.movie"]
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.appForegrounded), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //Gestures
        self.configureCameraButtonGestureRecognizers()
        
        //Media picker
        self.importToolTipView.layer.cornerRadius = 10
        self.mediaPickerImg.image = #imageLiteral(resourceName: "upload")
//        PHPhotoLibrary.requestAuthorization() { permission in
//            guard permission == .authorized else { return }
//            self.mediaManager.fetchMostRecentPhotoOrVideo() { image in
//                if let img = image {
//                    self.mediaPickerImg.layer.borderWidth = 1
//                    self.mediaPickerImg.layer.borderColor = UIColor.white.cgColor
//                    self.mediaPickerImg.layer.cornerRadius = 3
//                    self.mediaPickerImg.image = img
//                } else {
//                    self.mediaPickerImg.layer.borderWidth = 0
//                }
//            }
//        }
        
        //Authorizations
        self.verifyPermissionsAndConfigureCameraIfNeeded()
        
        //Camera
        self.resetCameraButton()
        self.videoIndicator.clipsToBounds = false
        self.makeProgressRound()
        self.configureProductImg()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cameraManager.flashMode = .off
        self.resetCameraButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configureGestureRecognizerEnability(isEnabled: true)
//        self.productPickerVC.delegate = self
//        self.showProductPickerIfNeeded()
        self.showImportToolTip()
    }
    
    @objc func appForegrounded() {
        self.cameraManager.resumeCaptureSession()
    }
    
    //MARK: - Private
    private func configureCameraButtonGestureRecognizers() {
        self.animationLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.animationAndTakePictureRecognizer(_:)))
        self.cameraLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.recordGestureRecognizer(_:)))
        self.cameraLongPress.minimumPressDuration = 0.5
        self.animationLongPress.minimumPressDuration = 0
        self.cameraLongPress.delegate = self
        self.animationLongPress.delegate = self
        self.cameraButton.addGestureRecognizer(self.cameraLongPress)
        self.cameraButton.addGestureRecognizer(self.animationLongPress)
    }
    
    private func configureGestureRecognizerEnability(isEnabled: Bool) {
        self.animationLongPress.isEnabled = isEnabled
        self.cameraLongPress.isEnabled = isEnabled
    }
    
    private func resetCameraButton() {
        self.configureGestureRecognizerEnability(isEnabled: true)
        self.videoIndicatorHeight.constant = 70
        self.view.layoutIfNeeded()
    }
    
    private func verifyPermissionsAndConfigureCameraIfNeeded() {
        self.configureCamera()
//        ReactionManager.sharedInstance.verifyAudioAndVideoPermissions() { audioPerm, videoPerm in
//            print(audioPerm, videoPerm)
//            if audioPerm && videoPerm {
//                self.configureCamera()
//            } else {
//                self.showPermissionView(videoPerm: videoPerm, audioPerm: audioPerm)
//            }
//        }
    }
    
    private func showPermissionView(videoPerm: Bool, audioPerm: Bool) {
        self.flipCameraButton.isHidden = true
        self.cameraButtonHolderView.isHidden = true
        self.flashModebutton.isHidden = true
        self.permissionHolderView.isHidden = false
        
        self.cameraPermButton.setTitle(localized("camera.permission.authorized"), for: .disabled)
        self.cameraPermButton.setTitle(localized("camera.permission.notAuthorized"), for: .normal)
        self.micPermButton.setTitle(localized("microphone.permission.authorized"), for: .disabled)
        self.micPermButton.setTitle(localized("microphone.permission.notAuthorized"), for: .normal)
        
        self.cameraPermButton.isEnabled = !videoPerm
        self.micPermButton.isEnabled = !audioPerm
    }
    
    private func configureCamera() {
        self.cameraManager.addPreviewLayerToView(self.previewHolderView, newCameraOutputMode: .videoWithMic)
        self.cameraManager.shouldEnableExposure = false
        self.cameraManager.writeFilesToPhoneLibrary = false
        self.cameraManager.flashMode = .off
        self.cameraManager.shouldRespondToOrientationChanges = false
        
        self.cameraOutput.isHighResolutionCaptureEnabled = true
        self.cameraManager.captureSession?.addOutput(self.cameraOutput)
    }
    
    private func makeProgressRound() {
        self.videoIndicator.layer.cornerRadius = max(self.videoIndicator.bounds.height, self.videoIndicator.bounds.width) / 2
    }
    
    private func configureProductImg() {
//        self.currentProductImage.sd_setImage(with: URL(string: self.product?.images.first ?? ""), size: .small)
    }
    
//    @discardableResult
//    private func showProductPickerIfNeeded() -> Product? {
//        guard let product = self.product else {
//            if self.productPickerVC.presentingViewController == nil {
//                self.present(self.productPickerVC, animated: true, completion: nil)
//            }
//            return nil
//        }
//        return product
//    }
    
    private func configureMediaPickerAccess() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            self.mediaPickerHolderView.isHidden = true
            return
        }
        
        self.mediaPickerHolderView.isHidden = false
        
        self.mediaPickerImg.image = #imageLiteral(resourceName: "upload")
//        self.mediaManager.fetchMostRecentPhotoOrVideo() { image in
//            if let img = image {
//                self.mediaPickerImg.layer.borderWidth = 1
//                self.mediaPickerImg.layer.borderColor = UIColor.white.cgColor
//                self.mediaPickerImg.layer.cornerRadius = 3
//                self.mediaPickerImg.image = img
//            } else {
//                self.mediaPickerImg.layer.borderWidth = 0
//            }
//        }
    }
    
    private func showImportToolTip() {
        guard !self.tooltipShowed else { return }
        
        self.importToolTipBottomConstraint.constant = 5
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
            self.importToolTipView.alpha = 1
        }
        
        self.tooltipShowed = true
    }
    
    private func takePicture() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: UIScreen.main.bounds.size.width,
            kCVPixelBufferHeightKey as String: UIScreen.main.bounds.size.height
            ] as [String : Any]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    //MARK: - Gesture Recognizer
    @objc func animationAndTakePictureRecognizer(_ sender: UILongPressGestureRecognizer) {
//        guard let _ = self.showProductPickerIfNeeded() else { return }
        self.importToolTipView.isHidden = true

        switch sender.state {
        case .began:
            print("start animation")
            self.videoIndicatorHeight.constant = 120
            UIView.animate(withDuration: 0.5, animations: {
                self.makeProgressRound()
                self.view.layoutIfNeeded()
            })
        case .ended:
            print("end animation")
            self.configureGestureRecognizerEnability(isEnabled: false)
            self.stopCapturing()
            self.videoIndicatorHeight.constant = 70
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        case .cancelled:
            print("cancel animation")
            self.stopCapturing()
            self.resetCameraButton()
        default:
            break
        }
    }
    
    @objc func recordGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            self.flipCameraButton.isHidden = true
            self.cameraManager.startRecordingVideo()
            self.videoIndicator.resetProgress()
            self.videoIndicator.startProgress(to: 100, duration: 10) {
                self.stopCapturing()
            }
        case .ended:
            print("long press ended")
        default:
            break
        }
    }
    
    private func stopCapturing() {
//        guard let product = self.product else { return }
        
        self.videoIndicator.resetProgress()
        self.flipCameraButton.isHidden = false
        
        self.configureGestureRecognizerEnability(isEnabled: false)
        
        guard (self.cameraManager.captureSession?.outputs.first(where: { $0 is AVCaptureMovieFileOutput }) as? AVCaptureMovieFileOutput)?.isRecording ?? false else {
            self.cameraManager.stopVideoRecording(nil)
            print("take picture")
            self.takePicture()
            return
        }

        print("take video")
        self.cameraManager.stopVideoRecording({ (url, error) -> Void in
            guard let url = url else { return }
            DispatchQueue.main.async {
//                let vc = CameraPreviewAndEditViewController.newInstance(media: .video(url), product: product, productPickerVC: self.productPickerVC, delegate: self)
//                self.present(vc, animated: true, completion: nil)
//                self.resetCameraButton()
            }
        })
    }
    
    //MARK: - IBActions
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func flashModeButtonPressed(_ sender: Any) {
        switch self.cameraManager.flashMode {
        case .on:
            self.cameraManager.flashMode = .auto
        case .off:
            self.cameraManager.flashMode = .on
        case .auto:
            self.cameraManager.flashMode = .off
        }

        self.flashModebutton.setImage(self.cameraManager.flashMode.image, for: .normal)
    }
    
    @IBAction func flipCameraButtonPressed(_ sender: Any) {
        self.cameraManager.cameraDevice = (self.cameraManager.cameraDevice == .front) ? .back : .front
    }
    
    @IBAction func currentProductPickerButtonPressed(_ sender: Any) {
//        self.present(self.productPickerVC, animated: true, completion: nil)
    }
    
    @IBAction func importMediaButtonPressed(_ sender: Any) {
//        guard let _ = self.showProductPickerIfNeeded() else { return }
        self.importToolTipView.isHidden = true
        self.present(self.mediaPicker, animated: true)
    }
    
    @IBAction func goToPermissionButtonPressed(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        } else {
//            self.showSimpleAlertPopup(message: localized("permissions.access.settings.denied"))
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {

    // iOS 11+ processing
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let outputData = photo.fileDataRepresentation() else {
            print("Photo Error: \(String(describing: error))")
            self.resetCameraButton()
            return
        }

        print("captured photo...")
        loadImage(data: outputData)
    }

    // iOS < 11 processing
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        if #available(iOS 11.0, *) {
            // use iOS 11-only feature
            // nothing to do here as iOS 11 uses the callback above
        } else {
            guard error == nil else {
                print("Photo Error: \(String(describing: error))")
                self.resetCameraButton()
                return
            }

            guard let sampleBuffer = photoSampleBuffer,
                let previewBuffer = previewPhotoSampleBuffer,
                let outputData =  AVCapturePhotoOutput
                .jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) else {
                        print("Image creation from sample buffer/preview buffer failed.")
                    self.resetCameraButton()
                        return
            }

            print("captured photo...")
            loadImage(data: outputData)
        }
    }

    /// Creates a UIImage from Data object received from AVCapturePhotoOutput
    /// delegate callback and sends to the VideoFeedDelegate for handling.
    ///
    /// - Parameter data: Image data.
    private func loadImage(data: Data) {
        guard let dataProvider = CGDataProvider(data: data as CFData), let cgImageRef: CGImage = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {
            print("load image crash")
            self.resetCameraButton()
            return
        }
        let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: .right)
        
//        let vc = CameraPreviewAndEditViewController.newInstance(media: .picture(image), product: product, productPickerVC: self.productPickerVC, delegate: self)
//        self.present(vc, animated: true, completion: nil)
        self.resetCameraButton()
    }
}

//extension CameraViewController: CameraPreviewDelegate {
//    func shouldDismissView() {
//        self.dismiss(animated: true)
//    }
//
//    func pre Product(product: Product) {
//        self.product = product
//        self.configureProductImg()
//    }
//}

extension CameraFlashMode {
    var image: UIImage {
        switch self {
        case .on:
            return #imageLiteral(resourceName: "flashOn")
        case .off:
            return #imageLiteral(resourceName: "flashOff")
        case .auto:
            return #imageLiteral(resourceName: "flashAuto")
        }
    }
}
//
//extension CameraViewController: ReactionProductPickerDelegate {
//    func didSelect(product: Product) {
//        self.product = product
//        self.configureProductImg()
//        self.showImportToolTip()
//    }
//}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    private func pickerController(_ controller: UIImagePickerController, didSelect media: CapturedMedia?) {
//        controller.dismiss(animated: true, completion: nil)
        
//        guard let media = media else { return }
//
//        let vc = CameraPreviewAndEditViewController.newInstance(media: media, product: product, productPickerVC: self.productPickerVC, delegate: self)
//        self.present(vc, animated: true, completion: nil)
//    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
//        if let image = info[.originalImage] as? UIImage {
//            self.pickerController(picker, didSelect: .picture(image))
//        } else if let videoUrl = info[.mediaURL] as? URL {
//            self.pickerController(picker, didSelect: .video(videoUrl))
//        } else {
//            self.pickerController(picker, didSelect: nil)
//        }
    }
}

extension CameraViewController: UIViewControllerRepresentable{
    public typealias UIViewControllerType = CameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
        return CameraViewController.newInstance()
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
    }
}

extension CameraViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

func localized(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: "")
}
