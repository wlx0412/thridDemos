//
//  UIImage+Extension.swift
//  furongbook
//
//  Created by wlx on 2020/11/18.
//

import UIKit

extension UIImage {
    
    public static func image(_ name: String) -> UIImage {
        return UIImage(named: name) ?? UIImage(named: "placeholder")!
    }
    
    public static var placeholderImage = UIImage.image("placeholder")
}

extension UIImage {
    static func createImage(with bgName: String, size: CGSize, qrUrl: String?, qrLogoName: String?, qrRect: CGRect) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        let i1 = UIImage.image(bgName)
        i1.draw(in: CGRect(x: 0, y: 0, width: Size.screenWidth, height: (size.height / size.width) * Size.screenWidth))
        
        if let url = qrUrl, let logo = qrLogoName {
            let i2 = self.createQR(from: url, centerImage: logo, size: CGSize(width: 145, height: 145))
            i2!.draw(in: qrRect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// 画图
    static func drawImage(bgName: String, size: CGSize,_ qrUrl: String?,_ qrLogoName: String?,_ qrRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        _ = UIGraphicsGetCurrentContext()
//        content?.setFillColor(UIColor.white.cgColor)
//        content?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let i1 = UIImage.image(bgName)
        i1.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if let url = qrUrl, let logo = qrLogoName {
            let i2 = self.createQR(from: url, centerImage: logo, size: qrRect.size)
            i2!.draw(in: qrRect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 创建二维码
    /// - Parameters:
    ///   - urlStr: 二维码链接
    ///   - centerImage: 二维码中间的图片
    static func createQR(from urlStr: String?, centerImage: String?, size: CGSize) -> UIImage? {
        if let url = urlStr {
            let urlData = url.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            // 创建一个二维码滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(urlData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrImage = qrFilter?.outputImage
            let codeImage = setupHighDefinitionUIImage(qrImage!, size: size.width)
            
            // 中间图片
            if let iconImage = UIImage(named: centerImage!) {
                let rect = CGRect(x:0, y:0, width:codeImage.size.width,
                                  height:codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                 
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width:rect.size.width * 0.25,
                                        height:rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x:x, y:y, width:avatarSize.width,
                                          height:avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                 
                UIGraphicsEndImageContext()
                return resultImage
            }
            
            return codeImage
        }
        
        return nil
    }
    
    //MARK: - 生成高清的UIImage
    static func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    
    //创建二维码
    static func createQR2(from urlStr: String?) -> CIImage? {
        guard let url = urlStr else { return nil }
        //将信息生成二维码
        //1.创建滤镜
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        
        //2.给滤镜设置内容
        guard let inputData = url.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        
        fileter?.setValue(inputData, forKeyPath: "inputMessage")
        
        //获取生成的二维码
        guard let outPutImage = fileter?.outputImage else {
            return nil
        }
        
        return outPutImage
    }
    
    
    //返回高清图片
    static func createHDQRImage(originalImage : CIImage, width: CGFloat) -> UIImage {
        //创建Transform
        let scale = width / originalImage.extent.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        //放大/缩小图片
        let hdImage = originalImage.transformed(by: transform)
        return UIImage(ciImage: hdImage)
    }
    
    //把前景图片画到背景图片
    static func createFgImage(bgImage : UIImage , fgImage : UIImage, fgSize: CGSize, hOffset: CGFloat?, vOffset: CGFloat?) -> UIImage? {
        //开启上下文
        UIGraphicsBeginImageContext(bgImage.size)
        
        //把二维码画到上下文
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        
        //把前景图画到二维码上
        let w : CGFloat = fgSize.width
        let h : CGFloat = fgSize.height
        let x : CGFloat = (bgImage.size.width - w) * 0.5 + (hOffset ?? 0)
        let y : CGFloat = (bgImage.size.height - h) * 0.5 + (vOffset ?? 0)
        fgImage.draw(in: CGRect(x: x, y: y, width: w, height: h))
        
        //获取新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        return newImage
    }
}

