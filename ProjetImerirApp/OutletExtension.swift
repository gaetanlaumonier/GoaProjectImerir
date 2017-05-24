import UIKit
import ImageIO
import AVFoundation

//Fichier regroupant les extensions des éléments.
//Permet d'importer des gifs ou de modifier la taille de police des éléments
//selon la taille de l'écran utilisé

extension UIImageView {
    
    public func loadGif(name: String, completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
                completion?()
            }
        }
    }
}

extension UILabel {
    func setupLabelDynamicSize(fontSize:CGFloat) {
        let screenSize = UIScreen.main.bounds.size
        var calculatedFont: UIFont?
        let currentFontName = self.font.fontName
        
        if screenSize.height < 500 {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 1)
            self.font = calculatedFont
        } else if screenSize.height < 600{
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 1.1)
            self.font = calculatedFont
        } else if screenSize.height < 700{
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 1.3)
            self.font = calculatedFont
        } else if screenSize.height < 800 {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 1.4)
            self.font = calculatedFont
        } else if screenSize.height < 900 {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 1.5)
            self.font = calculatedFont
        } else if screenSize.height < 1000 {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 2)
            self.font = calculatedFont
        } else if screenSize.height < 1100 {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 2.1)
            self.font = calculatedFont
        } else if screenSize.height < 2000 {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 2.4)
            self.font = calculatedFont
        }else {
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 3)
            self.font = calculatedFont
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIFont {
func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
    let descriptor = self.fontDescriptor
        .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
    return UIFont(descriptor: descriptor!, size: 0)
    }
}

extension UIButton {
    func setupButtonDynamicSize(fontSize:CGFloat) {
        let screenSize = UIScreen.main.bounds.size
        var calculatedFont: UIFont?
        let currentFontName = self.titleLabel?.font.fontName
        
        if screenSize.height < 500 {
            calculatedFont = UIFont(name: currentFontName!, size: fontSize * 1)
            self.titleLabel?.font = calculatedFont!
        } else if screenSize.height < 700{
            calculatedFont = UIFont(name: currentFontName!, size: fontSize * 1.1)
            self.titleLabel?.font = calculatedFont!
        } else if screenSize.height < 900 {
            calculatedFont = UIFont(name: currentFontName!, size: fontSize * 1.3)
            self.titleLabel?.font = calculatedFont!
        } else if screenSize.height < 1100 {
            calculatedFont = UIFont(name: currentFontName!, size: fontSize * 2.1)
            self.titleLabel?.font = calculatedFont!
        } else if screenSize.height < 1400 {
            calculatedFont = UIFont(name: currentFontName!, size: fontSize * 2.5)
            self.titleLabel?.font = calculatedFont!
        }else {
            calculatedFont = UIFont(name: currentFontName!, size: fontSize * 3)
            self.titleLabel?.font = calculatedFont!
        }
    }
}

extension UIImage {
    
    private struct gifProperties {
        static var duration = 0
    }
    
    static var lastLoadedGIFDuration: Int { return gifProperties.duration }
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }

            self.gifProperties.duration = sum - delays.last!
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
        
    }
}

extension UIApplication
{
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            let top = topViewController(nav.visibleViewController)
            return top
        }
        
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                let top = topViewController(selected)
                return top
            }
        }
        
        if let presented = base?.presentedViewController
        {
            let top = topViewController(presented)
            return top
        }
        return base
    }
    
}

extension UIViewController{

    func FonduApparition(myView : UIViewController, myDelai : Float){
    UIView.animate(withDuration: TimeInterval(myDelai), animations: {
    myView.view.alpha = 1
    })
        

    }
    
    func changeColorLabelGood(label: UILabel){
        UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
            label.textColor = UIColor(red: 0, green: 1, blue: 17/255, alpha: 0.9)
        }, completion: { _ in
            UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
                label.textColor = UIColor(red: 1, green: 17/255, blue: 0, alpha: 1)
            })
        })
    }
    
    func changeColorLabelBad(label :UILabel){
        
        UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
            label.textColor = UIColor(red: 1, green: 170/255, blue: 0, alpha: 0.9)
        }, completion: { _ in
            UIView.transition(with: label, duration: 0.2, options: .transitionCrossDissolve, animations: {
                label.textColor = UIColor(red: 1, green: 17/255, blue: 0, alpha: 1)
            })
        })
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func GestionMusic(filename: String) -> AVAudioPlayer{
        var backgroundMusicPlayer = AVAudioPlayer()
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Content can not be played")
            }
        }else{
            print("filename is wrong")
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.volume = 0
        backgroundMusicPlayer.setVolume(1, fadeDuration: 1)
        
        return backgroundMusicPlayer
    }
    
    func GestionBruitage(filename: String, volume : Float) -> AVAudioPlayer{
        var bruitageMusicPlayer = AVAudioPlayer()
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            
            do {
                bruitageMusicPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Content can not be played")
            }
        }else{
            print("filename is wrong")
        }
        bruitageMusicPlayer.numberOfLoops = 0
        bruitageMusicPlayer.volume = volume
        bruitageMusicPlayer.prepareToPlay()
        bruitageMusicPlayer.play()
     
        return bruitageMusicPlayer
    }
    
    func GestionBruitageLoop(filename: String, volume : Float) -> AVAudioPlayer {
        var bruitageMusicPlayer = AVAudioPlayer()
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            do {
                bruitageMusicPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Content can not be played")
            }
        }else{
            print("filename is wrong")
        }
        bruitageMusicPlayer.numberOfLoops = -1
        bruitageMusicPlayer.volume = volume
        bruitageMusicPlayer.prepareToPlay()
        bruitageMusicPlayer.play()
        
        return bruitageMusicPlayer
    }
}
