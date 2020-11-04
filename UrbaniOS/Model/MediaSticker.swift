//
//  MediaSticker.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit


enum StickerType {
    case text
    case gif
    case productTag
}

public struct TextInfo {
    var text: String
    var font: UIFont = .systemFont(ofSize: 50)
    var img: UIImage?
    var isTitle: Bool = false
}

public struct MediaSticker {
    var id: UUID = UUID()
    var originalSize: CGSize = .zero
    var positionX: CGFloat = 0.5
    var positionY: CGFloat = 0.5
    var rotation: Double = 0
    var scale: CGFloat = 1
    var type: StickerType
    var textInfo: TextInfo? = nil
    var gifUrl: URL? = nil
    var product: Product? = nil

    init(dragView: DragScaleAndRotateView) {
        self.positionX = dragView.positionXRatio
        self.positionY = dragView.positionYRatio
        self.rotation = Double(dragView.degreeRotation)
        self.scale = dragView.currentScale
        self.type = .text
        
        switch dragView.type {
        case .text(let textInfo):
            self.textInfo = textInfo
            self.originalSize = textInfo.img?.size ?? .zero
        default: break
        }
    }
    
    var positionRatio: CGPoint {
        let screen = UIScreen.main
        return CGPoint(x: self.positionX / screen.bounds.width, y: self.positionY / screen.bounds.height)
    }
    
    var ffmpegInputOptions: String {
        guard self.gifUrl != nil else { return "" }
        return "-ignore_loop 0"
    }
    
    var ffmpegScalingoptions: String {
        guard self.gifUrl != nil else { return "" }
        return ":shortest=1"
    }
}
