//
//  DragScaleAndRotateView.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import SnapKit

enum DragScaleViewType {
    case text(TextInfo)
    case gif
    case productTag
    
    var canRotateAndScale: Bool {
        switch self {
        case .productTag: return false
        default: return true
        }
    }
    
    var isGestureEnabled: Bool {
        switch self {
        case .text(let textInfo): return !textInfo.isTitle
        default: return true
        }
    }
    
    var isIncludedInFffmpeg: Bool {
        switch self {
        case .productTag: return false
        default: return true
        }
    }
}

protocol DragScalePositionDelegate: class {
    func viewDragStarted(view: DragScaleAndRotateView)
    func viewPositionChanged(view: DragScaleAndRotateView, touchPoint: CGPoint)
    func viewDragEnded(view: DragScaleAndRotateView)
    func viewDidSelect(view: DragScaleAndRotateView)
}


class DragScaleAndRotateView: UIView, UIGestureRecognizerDelegate {

    private var lastLocation: CGPoint = .zero
    private var currentRotation: CGFloat = 0

    private(set) var id: UUID = UUID()
    private(set) var currentScale: CGFloat = 1
    private(set) var positionXRatio: CGFloat = 0.5
    private(set) var positionYRatio: CGFloat = 0.5
    private(set) var isSelected: Bool = false {
        didSet {
//            self.layer.borderWidth = self.isSelected ? 3 : 0
        }
    }
    private(set) var type: DragScaleViewType = .gif
    
    private var delegate: DragScalePositionDelegate?

    var degreeRotation: CGFloat {
        return (self.currentRotation * (180 / .pi)).truncatingRemainder(dividingBy: 360)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureGesture()
    }
    
    init(frame: CGRect, currentScale: CGFloat, type: DragScaleViewType, delegate: DragScalePositionDelegate?) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0
        
        self.type = type
        self.currentScale = currentScale
        self.delegate = delegate
        self.configureGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configureGesture()
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.detectTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        guard self.type.isGestureEnabled else { return }
        
        if self.type.canRotateAndScale {
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinch(sender:)))
            pinch.delegate = self
            self.addGestureRecognizer(pinch)
            
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(self.didRotate(sender:)))
            rotation.delegate = self
            self.addGestureRecognizer(rotation)
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.detectPan))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func clearSelection() {
        self.isSelected = false
    }
    
    func changeTextInfo(newTextInfo: TextInfo) {
        var info = newTextInfo
    
        guard case .text(_) = type, let img = self.imageWith(textInfo: info) else { return }
        
        self.bounds.size = img.size
        self.subviews.forEach({ $0.removeFromSuperview() })
        let imgView = UIImageView(image: img)
        self.addSubview(imgView)
        imgView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        info.img = img
        self.type = .text(info)
    }
    
    private func imageWith(textInfo: TextInfo) -> UIImage? {
        let frame = CGRect(origin: .zero, size: textInfo.text.sizeOfString(usingFont: textInfo.font, maxWidth: UIScreen.main.bounds.width - 100, maxHeight: .infinity))
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        nameLabel.font = textInfo.font
        nameLabel.text = textInfo.text
        nameLabel.textColor = textInfo.textColour
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let view = sender.view!
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
        self.currentScale *= scale
    }
    
    @objc func didRotate(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let view = sender.view!
        let previousTransform = view.transform
        view.transform = previousTransform.rotated(by: rotation)
        sender.rotation = 0
        self.currentRotation += rotation
    }
    
    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)
        if recognizer.state == .began {
            self.superview?.bringSubviewToFront(self)
            self.lastLocation = self.center
            self.delegate?.viewDragStarted(view: self)
        }

        self.center = CGPoint(x: self.lastLocation.x + translation.x, y: self.lastLocation.y + translation.y)
        let screen = self.superview!
        self.positionXRatio = self.center.x / screen.bounds.width
        self.positionYRatio = self.center.y / screen.bounds.height
        self.delegate?.viewPositionChanged(view: self, touchPoint: recognizer.location(in: self.superview))
        
        if recognizer.state == .ended {
            self.delegate?.viewDragEnded(view: self)
        }
    }
    
    @objc func detectTap(_ recognizer: UITapGestureRecognizer) {
        self.isSelected = true
        self.delegate?.viewDidSelect(view: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.superview?.bringSubviewToFront(self)
//        self.lastLocation = self.center
//        self.delegate.viewDragStarted(view: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.viewDragEnded(view: self)
    }
    
    func getProductTag() -> ProductTag? {
        guard case .productTag = self.type, var currentTag = (self.subviews.first as? ProductTagView)?.productTag else { return nil }
        currentTag.positionX = Double(self.positionXRatio)
        currentTag.positionY = Double(self.positionYRatio)
        return currentTag
    }
    
    func configurePositionRatio() {
        let screen = self.superview!
        self.positionXRatio = self.center.x / screen.bounds.width
        self.positionYRatio = self.center.y / screen.bounds.height
    }

}
