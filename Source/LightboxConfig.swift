import UIKit
import AVKit
import AVFoundation
//import Imaginary

public class LightboxConfig {
  /// Whether to show status bar while Lightbox is presented
  public static var hideStatusBar = true
  
  public typealias LoadImageCompletion = (_ error: NSError?, _ image: UIImage?) -> Void
    
  /// Provide a closure to handle selected video
  public static var handleVideo: (_ from: UIViewController, _ videoURL: URL) -> Void = { from, videoURL in
    let videoController = AVPlayerViewController()
    videoController.player = AVPlayer(url: videoURL)

    from.present(videoController, animated: true) {
      videoController.player?.play()
    }
  }
    
  /// How to load image onto UIImageView
  public static var loadImage: (_ imageView: UIImageView, _ URL: URL, _ httpHeaders: [String: String]?, _ completion: LoadImageCompletion?) -> Void = {
    imageView, URL, httpHeaders, completion in
        
    var imageRequest: URLRequest = URLRequest(url: URL)
    imageRequest.allHTTPHeaderFields = httpHeaders
        
    let sessionManager: URLSession = {
      let configuration =  URLSessionConfiguration.default
      let cache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
      configuration.urlCache = cache
      return URLSession(configuration: configuration)
    }()
        
    let task = sessionManager.dataTask(with: imageRequest, completionHandler: { (data, _, error) -> Void in
        guard let data = data, let image = UIImage(data: data) else {
            completion?(error as NSError?, nil)
            return
        }
        DispatchQueue.main.sync {
            imageView.image = image
        }
        completion?(error as NSError?, image)
    })
    
    task.resume()
    
  }

  /// Indicator is used to show while image is being fetched
  public static var makeLoadingIndicator: () -> UIView = {
    return LoadingIndicator()
  }

  /// Number of images to preload.
  ///
  /// 0 - Preload all images (default).
  public static var preload = 0

  public struct PageIndicator {
    public static var enabled = true
    public static var separatorColor = UIColor(hex: "3D4757")

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor(hex: "899AB8"),
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct CloseButton {
    public static var enabled = true
    public static var size: CGSize?
    public static var text = NSLocalizedString("Close", comment: "")
    public static var image: UIImage?

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 16),
      .foregroundColor: UIColor.white,
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct DeleteButton {
    public static var enabled = false
    public static var size: CGSize?
    public static var text = NSLocalizedString("Delete", comment: "")
    public static var image: UIImage?

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 16),
      .foregroundColor: UIColor(hex: "FA2F5B"),
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct InfoLabel {
    public static var enabled = true
    public static var textColor = UIColor.white
    public static var ellipsisText = NSLocalizedString("Show more", comment: "")
    public static var ellipsisColor = UIColor(hex: "899AB9")

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor(hex: "DBDBDB")
    ]
  }

  public struct Zoom {
    public static var minimumScale: CGFloat = 1.0
    public static var maximumScale: CGFloat = 3.0
  }
}
