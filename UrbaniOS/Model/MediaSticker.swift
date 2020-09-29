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
    var img: UIImage? = nil
    var imgUrl: URL? = nil
    var text: String
    var font: UIFont = .systemFont(ofSize: 50)
}

public struct MediaSticker {
    var id: UUID = UUID()
    var originalSize: CGSize = .zero
    var positionX: CGFloat = UIScreen.main.bounds.width / 2
    var positionY: CGFloat = UIScreen.main.bounds.height / 2
    var rotation: Double = 0
    var scale: CGFloat = 1
    var type: StickerType
    var textInfo: TextInfo = TextInfo(img: nil, imgUrl: nil, text: "Text")
    var gifUrl: URL? = nil
    var product: Product? = nil

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
