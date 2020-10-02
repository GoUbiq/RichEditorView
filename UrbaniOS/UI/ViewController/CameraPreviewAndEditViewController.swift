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
    private var stickers: [MediaSticker] = []
    
    private var editingTxtViewId: UUID? = nil {
        didSet {
            if oldValue == nil, let id = self.editingTxtViewId, case .text(let textInfo) = self.contentViews.first(where: { $0.id == id })?.type {
                let vc = TextStickerEditionViewController.newInstance(stickerId: id, textInfo: textInfo, delegate: self)
                self.present(vc, animated: true)
            }
            
            self.contentViews.forEach({ $0.isHidden = $0.id == self.editingTxtViewId })
        }
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
        self.playerLayer?.videoGravity = .resizeAspectFill
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
        let view = DragScaleAndRotateView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)), currentScale: 1, type: .gif, delegate: self)
        view.center = self.view.center
        
        let productView: ProductTagView = .fromNib()
        productView.configureView(product: .init(id: "", title: "Product title lol lololooololololol"))
        self.overlayView.addSubview(productView)
        productView.center = self.view.center
//        view.addSubview(productView)

//        productView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    @IBAction func addTextButtonPressed(_ sender: Any) {
        let view = DragScaleAndRotateView(frame: .zero, currentScale: 1, type: .text(.init(text: "Text")), delegate: self)
        self.overlayView.addSubview(view)
        view.center = self.view.center
        self.editingTxtViewId = view.id
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

extension CameraPreviewAndEditViewController: TextStickerEditionDelegate {
    func editingDoneWith(stickerId: UUID, newText: String) {
        self.editingTxtViewId = nil
        self.contentViews.first(where: { $0.id == stickerId })?.changeTextAndLoadImg(newText: newText)
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
    
    func viewDidSelect(view: DragScaleAndRotateView) {
        switch view.type {
        case .text: self.editingTxtViewId = view.id
        default: break
        }
        self.contentViews.first(where: { $0 !== view && view.isSelected })?.clearSelection()
    }
}


