//
//  FFMPEGManager.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import mobileffmpeg
import UIKit

class FFMPEGManager: NSObject, LogDelegate {
    static let sharedInstance = FFMPEGManager()
    
    private var mediaManager = MediaManager.sharedInstance
    
    override init() {
        super.init()
        MobileFFmpegConfig.setLogDelegate(self)
    }
    
    private func getResultVideoPath() -> String? {
        let docFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return docFolder?.appending("/video.mp4")
    }
    
    func buildMedia(url: URL, content: [MediaSticker], completionHandler: @escaping (String) -> ()) {
        guard let videoPath = getResultVideoPath() else { return }

        try? FileManager.default.removeItem(atPath: videoPath)

        self.mediaManager.downloadReactionContentMedias(content: content, completionHandler: { inputs in
            var processedInputs: String = ""// inputs.map({ "-ignore_loop 0 -i \($0.absoluteString) " }).joined()
            let filers = content.enumerated().map() { idx, content in
                processedInputs.append("\(content.ffmpegInputOptions) -i \(inputs[idx].absoluteString) ")
                let scale = content.scale * (1920 / UIScreen.main.bounds.height)
                return ";\(self.generateContent(filter: "scale", options: "w=iw*\(scale):h=ih*\(scale)", inputs: ["\(idx + 1):v"], outputs: ["\(idx)"]))" +
                    ";\(self.generateContent(filter: "rotate", options: "a=\(content.rotation)*PI/180:c=black@0:ow=rotw(iw):oh=roth(ih)", inputs: ["\(idx)"], outputs: ["\(idx)"]))" +
                ";\(self.generateContent(filter: "overlay", options: "x=(W*\(content.positionRatio.x))-(w/2):y=(H*\(content.positionRatio.y))-(h/2)\(content.ffmpegScalingoptions)", inputs: ["root", "\(idx)"], outputs: ["root"]))"
            }.joined()

            let cmd = "-i \(url) \(processedInputs) -filter_complex \"\(self.generateContent(filter: "transpose", options: "dir=1:passthrough=portrait", inputs: ["0:v"], outputs: ["root"]))" +
                ";\(self.generateContent(filter: "scale", options: "w=-2:h=1920", inputs: ["root"], outputs: ["root"]))" +
                "\(filers)\"" +
                " -map \"[root]\" -map 0:a -c:a aac -c:v libx264 -preset ultrafast -crf 25 -b:v 1024k \(videoPath)"

            print("starts ffmpeg \(cmd) \(Date().timeIntervalSince1970)")
            let result = MobileFFmpeg.execute(cmd)

            print("FFmpeg process done \(result) \(Date().timeIntervalSince1970)")
            completionHandler(videoPath)
        })
    }
    
    func logCallback(_ executionId: Int, _ level: Int32, _ message: String!) {
        print(message)
    }
    
    private func generateContent(filter: String, options: String, inputs: [String], outputs: [String]) -> String {
        let inputs = inputs.map({ "[\($0)]" }).joined() 
        let outputs = outputs.map({ "[\($0)]" }).joined()
        return "\(inputs)\(filter)=\(options)\(outputs)"
    }
}

