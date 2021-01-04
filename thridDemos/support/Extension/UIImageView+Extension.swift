//
//  UIImageView+Extension.swift
//  furongbook
//
//  Created by wlx on 2020/11/18.
//

import UIKit
import SDWebImage

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    //设置网络图片
    func setImageFromUrlString(str: String?,_ type: Int? = nil) {
        if let string = str?.trim(), let decode = string.removingPercentEncoding {
            var url:URL?
            if type == 1 {
                url = URL(string: decode.urlEncoded())
            }else{
                url = decode.stringToUrl()
            }
            if let u = url {
                self.sd_setImage(with: u, completed: { (img, error, type, url) in
                    if let err = error {
                        Util.printX("\(String(describing: url))图片错误: \(err)")
                    }
                })
            }else{
                self.image = UIImage.placeholderImage
            }
        }else {
            self.image = UIImage.placeholderImage
        }
    }
    
    //设置本地图片
    func setImageFromName(name: String?) {
        if name != nil && name != ""{
            if let image = UIImage(named: name!) {
                self.image = image
                return
            }else {
                self.isHidden = true
            }
        }
        self.isHidden = true
    }
    
    /// 创建纯色d图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - rect: 大小
    static func imageWithColor(color:UIColor,_ rect: CGRect? = CGRect(x: 0, y: 0, width: Size.screenWidth, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(rect!.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect!);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension SDAnimatedImageView {
    func setGifImage(name: String?) {
        guard let n = name else {
            return
        }
        if let path = Bundle.main.path(forResource: n, ofType: "gif"), let data = NSData(contentsOfFile: path) {
            self.image = UIImage.sd_image(withGIFData: data as Data)
        }
    }
}

