//
//  CameraPreviewAndEditViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import AVKit
import UICircularProgressRing

protocol CameraPreviewDelegate: class {
    func shouldDismissView()
}

class CameraPreviewAndEditViewController: UIViewController {
    private static let identifier = "CameraPreviewAndEditViewController"
    
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var trashView: CircleImageView!
    @IBOutlet private weak var progressHolderView: UIView!
    @IBOutlet private weak var circularProgress: UICircularProgressRing!
    @IBOutlet private weak var stickersButton: UIButton!
    
    class func newInstance(media: CapturedMedia, cameraDelegate: MediaManagementDelegate, delegate: CameraPreviewDelegate) -> CameraPreviewAndEditViewController {
        let instance = cameraStoryboard.instantiateViewController(withIdentifier: self.identifier) as! CameraPreviewAndEditViewController
        instance.modalPresentationStyle = .overFullScreen
        instance.modalTransitionStyle = .crossDissolve
        instance.media = media
        instance.delegate = delegate
        instance.cameraDelegate = cameraDelegate
        return instance
    }
    
    private var editingTV: UITextView?
    private var product: Product!
    private var media: CapturedMedia!
    private var delegate: CameraPreviewDelegate!
    private var cameraDelegate: MediaManagementDelegate!
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var contentViews: [DragScaleAndRotateView] {
        return self.overlayView.subviews.compactMap({ $0 as? DragScaleAndRotateView })
    }
    
    private var mediaManager: MediaManager {
        return MediaManager.sharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewImage.isHidden = true
        self.trashView.layer.borderWidth = 1
        self.trashView.layer.borderColor = UIColor.white.cgColor
        self.trashView.isHidden = true
        self.progressHolderView.isHidden = true
        
        self.stickersButton.isHidden = true
        
        switch self.media {
            case .picture(let image):
                self.previewImage.isHidden = false
                self.previewImage.image = image
            case .video:
                 // background event
                NotificationCenter.default.addObserver(self, selector: #selector(self.setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)

                 // foreground event
                 NotificationCenter.default.addObserver(self, selector: #selector(self.reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)

                // add these 2 notifications to prevent freeze on long Home button press and back
                 NotificationCenter.default.addObserver(self, selector: #selector(self.setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: nil)

                 NotificationCenter.default.addObserver(self, selector: #selector(self.reinitializePlayerLayer), name: UIApplication.didBecomeActiveNotification, object: nil)

                self.configurePlayer()
            case .none:
                break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.player?.pause()
        self.player = nil
    }
    
    //MARK: - Private
    @objc fileprivate func configurePlayer() {
        guard case .video(let url) = self.media else { return }

        self.player = AVPlayer.init(url: url)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.playerLayer?.frame = view.layer.frame

        self.player?.actionAtItemEnd = .none

        self.player?.play()

        self.view.layer.insertSublayer(self.playerLayer!, at: 0)

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: CMTime.zero)
        }
    }
    
    @objc fileprivate func setPlayerLayerToNil(){
        // first pause the player before setting the playerLayer to nil. The pause works similar to a stop button
        self.player?.pause()
        self.playerLayer = nil
    }
    
    @objc fileprivate func reinitializePlayerLayer() {
        if let player = self.player {
            self.playerLayer = AVPlayerLayer(player: player)
            player.play()
        }
    }
    
    
    //MARK: - IBActions
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func emojiButtonPressed(_ sender: Any) {
//        self.present(self.giphy, animated: true, completion: nil)
    }
    
    @IBAction func addTextButtonPressed(_ sender: Any) {
//        let view = DragScaleAndRotateView(frame: .zero, currentScale: 1, delegate: self)
//        self.overlayView.addSubview(view)
//        view.center = self.view.center
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 30)
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.returnKeyType = .done
        tv.isScrollEnabled = false
        tv.delegate = self
        tv.isUserInteractionEnabled = false
        self.overlayView.addSubview(tv)
        
        tv.becomeFirstResponder()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        func processDone() {
            self.dismiss(animated: false)
            self.delegate.shouldDismissView()
        }
        
        func uploadProcessDone(url: String?) {
            guard let url = url else {
                processDone()
                return
            }

//            let hud = Utils.showMessageHud(message: "Posting reaction", onViewController: self)
//            ReactionManager.sharedInstance.postReaction(productId: self.product.id, mediaUrl: url, content: []) { reaction in
//                Utils.dismissMessageHud(hud)
//                guard let reaction = reaction, let url = URL(string: reaction.mediaUrl) else { return processDone() }
//
//                let player = AVPlayer(url: url)
//                let pc = AVPlayerViewController()
//                pc.player = player
//                self.present(pc, animated: true, completion: {
//                    pc.player!.play()
//                })
//            }
//            self.showSimpleAlertPopup(message: localized("reactionCreated.popup.message"), buttonTitle: localized("ok"), buttonAction: {
//                processDone()
//            })
        }
  
        switch self.media {
        case .video(let url):
//            let content = self.contentViews.compactMap { (dragView) -> ReactionContent? in
//                guard let mediaView = dragView.subviews.first as? GPHMediaView, let media = mediaView.media else { return nil }
//                return ReactionContent(positionX: Double(dragView.positionXRatio), positionY: Double(dragView.positionYRatio), rotation: Double(dragView.degreeRotation), scale: Double(dragView.currentScale * (1920 / UIScreen.main.bounds.height)), content: media.images?.original?.gifUrl ?? "", type: .video)
//            }

//            let hud = Utils.showMessageHud(message: "Processing video", onViewController: self)
            FFMPEGManager.sharedInstance.buildMedia(url: url, content: []) { vFile in
                let url = URL(fileURLWithPath: vFile)
                self.cameraDelegate?.didCreateMedia(media: .init(url: url, preview: url.imageFromVideo(at: 0) ?? #imageLiteral(resourceName: "play-button")))
                processDone()
//                Utils.dismissMessageHud(hud)
            }
        default: return
        }
    }
    
    @IBAction func overlayViewTap(_ sender: Any) {
        self.contentViews.forEach({ $0.clearSelection() })
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension CameraPreviewAndEditViewController: UITextViewDelegate {
    private func stopEditingTV(textView: UITextView) {
//        textView.removeAllConstraints()
//        if textView.text.isEmpty {
//            textView.removeFromSuperview()
//        } else {
//            let textViewFrame = textView.frame.size
//            textView.removeFromSuperview()
//            let view = DragScaleAndRotateView(frame: CGRect(origin: .zero, size: textViewFrame), currentScale: 1, type: .text, delegate: self)
//            self.overlayView.addSubview(view)
//            view.backgroundColor = .black
//            view.addSubview(textView)
//            textView.snp.makeConstraints { $0.edges.equalTo(view) }
//            view.center = self.view.center
//        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if let sv = textView.superview as? DragScaleAndRotateView {
//            textView.removeAllConstraints()
//            sv.removeFromSuperview()
//            textView.removeFromSuperview()
//            self.overlayView.addSubview(textView)
//        }
//
//        textView.snp.makeConstraints {
//            $0.leading.leading.greaterThanOrEqualTo(self.overlayView).offset(30)
//            $0.centerX.equalTo(self.overlayView)
//            $0.bottom.equalTo(self.overlayView.snp.centerY)
//        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if let sv = textView.superview as? DragScaleAndRotateView {
////            sv.backgroundColor = .yellow
//            print(sv.superview === self.overlayView)
//            print(self.overlayView.subviews.count)
//            textView.removeAllConstraints()
//            sv.removeFromSuperview()
//            print(self.overlayView.subviews.count)
//
////            sv.isHidden = true
////            textView.removeFromSuperview()
////            self.overlayView.addSubview(textView)
//        }
////        self.editingTV = textView
//        textView.snp.makeConstraints {
//            $0.leading.leading.equalTo(self.overlayView).offset(30)
//            $0.centerX.equalTo(self.overlayView)
//            $0.bottom.equalTo(self.overlayView.snp.centerY)
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.stopEditingTV(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
//            self.stopEditingTV(textView: textView)
            return false
        }
        return true
    }
}


extension CameraPreviewAndEditViewController: DragScalePositionDelegate {
    func viewDragStarted(view: DragScaleAndRotateView) {
        self.trashView.isHidden = false
        self.contentViews.forEach({ $0.clearSelection() })
    }
    
    func viewPositionChanged(view: DragScaleAndRotateView, touchPoint: CGPoint) {
        if (self.trashView.frame.contains(touchPoint)) {
            view.isHidden = true
            self.trashView.tintColor = .gray
            self.trashView.backgroundColor = .white
        } else {
            view.isHidden = false
            self.trashView.tintColor = .white
            self.trashView.backgroundColor = .clear
        }
    }
    
    func viewDragEnded(view: DragScaleAndRotateView) {
        if view.isHidden == true {
            view.removeFromSuperview()
        }
        self.trashView.isHidden = true
    }
    
    func viewWillSelect(view: DragScaleAndRotateView) {
        switch view.type {
        case .gif: break
        case .text:
            if view.isSelected {
                (view.subviews.first(where: { $0 is UITextView }) as? UITextView)?.becomeFirstResponder()
            }
        }
    }
    
    func viewDidSelect(view: DragScaleAndRotateView) {
//        switch view.type {
//        case .gif: break
//        case .text:
//            (view.subviews.first(where: { $0 is UITextView }) as? UITextView)?.becomeFirstResponder()
//        }
        self.contentViews.first(where: { $0 !== view && view.isSelected })?.clearSelection()
    }
}


