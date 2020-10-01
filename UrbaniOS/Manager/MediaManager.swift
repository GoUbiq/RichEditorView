//
//  MediaManager.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-28.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import Foundation
import AFNetworking
import Photos

enum CapturedMedia {
    case picture(UIImage)
    case video(URL)
    
    var contentType: String {
        switch self {
        case .picture:
            return "image/jpeg"
        default:
            return "video/mp4"
        }
    }
}

class MediaManager {
    static let sharedInstance = MediaManager()
    
    
    //MARK: - Local medias
    func fetchMostRecentPhotoOrVideo(completion: @escaping (UIImage?) -> ()) {
        var image: UIImage? = nil {
            didSet {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let manager = PHImageManager.default()
            
            let lastImg = PHAsset.fetchAssets(with: .image, options: nil).lastObject
            let lastVid = PHAsset.fetchAssets(with: .video, options: nil).lastObject
            guard let lastMedia = (lastImg?.modificationDate ?? .distantPast > lastVid?.modificationDate ?? .distantPast) ? lastImg : lastVid else {
                image = nil
                return
            }
            
            switch lastMedia.mediaType {
            case .image:
                manager.requestImage(for: lastMedia, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: nil, resultHandler: { (result, _) in
                    image = result
                })
            case .video:
                manager.requestAVAsset(forVideo: lastMedia, options: nil, resultHandler: { (asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
                    guard let asset = asset as? AVURLAsset else { return }
                    
                    image = self.imageFromVideo(url: asset.url, at: 0)
                })
            default:
                image = nil
            }
        }
        
    }
    
    func downloadReactionContentMedias(content: [MediaSticker], completionHandler:  @escaping ([URL]) -> ()) {
        let session = AFURLSessionManager(sessionConfiguration: .default)
        let group = DispatchGroup()
        
        var result: [Int: URL] = [:]
        
        content.enumerated().forEach { idx, content in
            guard let url = content.gifUrl else {
//                if let img = content.textInfo.img, let url = self.saveImage(fileName: content.id.uuidString, image: img) {
//                    result[idx] = url
//                }
                return
            }
            group.enter()
            let request = URLRequest(url: url)
            
            session.downloadTask(with: request, progress: { progress in
                print("progress \(progress.completedUnitCount)")
            }, destination: { (url, response) -> URL in
                let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
                // delete original copy
                try? FileManager.default.removeItem(at: destinationURL)
                // copy from temp to Document
                do {
                    try FileManager.default.copyItem(at: url, to: destinationURL)
                    print("DESTINATION \(destinationURL.absoluteString)")
                    return destinationURL
                } catch let error {
                    print("Copy Error: \(error.localizedDescription)")
                    return url
                }
            }, completionHandler: { (response, url, error) in
                group.leave()
                
                guard let url = url else { return }
                
                result[idx] = url
                
                print("DESTINATION \(url.absoluteString)")
                print(response)
            }).resume()
        }
        
        group.notify(queue: .main) {
            completionHandler(result.sorted(by: { $0.0 < $1.0 }).map({ $0.1 }))
        }
    }
    
    func mergeImagesVertically(img1: UIImage, img2: UIImage, ssize: CGSize? = nil) -> UIImage {
        let size = ssize ?? CGSize(width: img1.size.width + img2.size.width, height: img1.size.height)
        
        UIGraphicsBeginImageContext(size)
        img1.draw(in: CGRect(x: 0, y: 0, width: ssize?.width ?? img1.size.width, height: size.height))
        img2.draw(in: CGRect(x: img1.size.width, y: 0, width: img2.size.width, height: size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    private func saveImage(fileName: String, image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(fileName).png") else {
            return nil
        }
        do {
            try data.write(to: url)
            return url
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func imageFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)
        
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
        return UIImage(cgImage: thumbnailImageRef)
    }
    
    //MARK: - Download
    private func upload(data: Data, urlString: String, mimeType: String, completion: @escaping (Bool, Error?) -> Void) {
        let requestURL = URL(string: urlString)!
        let session = AFURLSessionManager(sessionConfiguration: .default)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        session.uploadTask(with: request, from: data, progress: nil, completionHandler: { response, obj, error in
            completion(error == nil, error)
        }).resume()
    }
    
    private func upload(image: UIImage, urlString: String, mimeType: String = "image/jpeg", completion: @escaping (Bool, Error?) -> Void) {
        let data = image.jpegData(compressionQuality: 0.9)!
        self.upload(data: data, urlString: urlString, mimeType: mimeType, completion: completion)
    }
    
    //MARK: - Local
    func verifyAudioAndVideoPermissions(completion: @escaping (_ audio: Bool, _ video: Bool) -> ()) {
        var audioAuthorized = false
        var videoAuthorized = false
        
        self.getPermission(for: .video, completion: { videoGranted in
            videoAuthorized = videoGranted
            self.getPermission(for: .audio, completion: { audioGranted in
                audioAuthorized = audioGranted
                DispatchQueue.main.async {
                    completion(audioAuthorized, videoAuthorized)
                }
            })
        })
    }
    
    private func getPermission(for mediaType: AVMediaType, completion: @escaping (Bool) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: completion)
        default:
            completion(false)
        }
    }
}

