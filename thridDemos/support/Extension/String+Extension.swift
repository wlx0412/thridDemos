//
//  String+Extension.swift
//  furongbook
//
//  Created by wlx on 2020/11/16.
//

import Foundation
import CommonCrypto
import SwiftDate

extension String {
    private static var exKey: String = "stringExtensionKey"
    
    var local: String {
        get {
//            return objc_getAssociatedObject(self, &String.exKey) as! String
            return NSLocalizedString(self, comment: "")
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &String.exKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func stringToUrl() -> URL? {
        if self.isEmpty {
            return nil
        }
        if let str = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) {
            return URL(string: str)
        }
        return nil
    }
    
}

extension String {
    /// 截取第一个到第任意位置
    ///
    /// - Parameter end: 结束的位值
    /// - Returns: 截取后的字符串
    public func stringCut(end: Int) -> String {
        if !(end <= count) { return self }
        let sInde = index(startIndex, offsetBy: end)
        return String(self[..<sInde])
    }
    
    /// 截取任意位置到结束
    ///
    /// - Parameter end:
    /// - Returns: 截取后的字符串
    public func stringCutToEnd(star: Int) -> String {
        if !(star < count) { return self}
        let sRang = index(startIndex, offsetBy: star)..<endIndex
        return String(self[sRang])
    }
    /// 截取最后几位
    ///
    /// - Parameter last:
    /// - Returns: 截取后的字符串
    public func stringCutLastEnd(last: Int) -> String {
        if !(last < count) { return self }
        let sRang = index(endIndex, offsetBy: -last)..<endIndex
        return String(self[sRang])
    }
    /// 字符串任意位置插入
    ///
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 添加后的字符串
    public func stringInsert(content: String,locat: Int) -> String {
        if !(locat < count) { return self + content}
        let str1 = stringCut(end: locat)
        let str2 = stringCutToEnd(star: locat)
        return str1 + content + str2
    }
    /// 计算字符串的尺寸
    ///
    /// - Parameters:
    ///   - text: 字符串
    ///   - rectSize: 容器的尺寸
    ///   - fontSize: 字体
    /// - Returns: 尺寸
    ///
    public func getStringSize(rectSize: CGSize,fontSize: CGFloat) -> CGSize {
        let str: NSString = self as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    /// 计算字符串尺寸
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: 尺寸
    public func getStringSize(fontSize:CGFloat) -> CGSize {
        return self.getStringSize(rectSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), fontSize: fontSize)
    }
    
    /// 字符串高度
    /// - Parameters:
    ///   - str: 字符串
    ///   - width: 宽
    ///   - attr: 样式
    public func getStringHeight(width: CGFloat, attr: [NSAttributedString.Key: Any]) -> CGFloat {
        let ocStr:NSString = self.removeHeadAndTailSpace as NSString
        let rect = ocStr.boundingRect(with: CGSize(width: width, height: 10000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attr, context: nil)
        return rect.height
    }
    
    /// 输入字符串 输出数组
    /// e.g  "qwert" -> ["q","w","e","r","t"]
    /// - Returns: ["q","w","e","r","t"]
    public func stringToArr() -> [String] {
        let num = count
        if !(num > 0) { return [""] }
        var arr: [String] = []
        for i in 0..<num {
            let tempStr: String = self[self.index(self.startIndex, offsetBy: i)].description
            arr.append(tempStr)
        }
        return arr
    }
    /// 字符串截取         3  6
    /// e.g let aaa = "abcdefghijklmnopqrstuvwxyz"  -> "cdef"
    /// - Parameters:
    ///   - start: 开始位置 3
    ///   - end: 结束位置 6
    /// - Returns: 截取后的字符串 "cdef"
    public func startToEnd(start: Int,end: Int) -> String {
        if !(end < count) || start > end { return "取值范围错误" }
        var tempStr: String = ""
        for i in start...end {
            let temp: String = self[self.index(self.startIndex, offsetBy: i - 1)].description
            tempStr += temp
        }
        return tempStr
    }
    /// 字符串修改部分为密文
    ///
    /// - Parameters:
    ///   - start: 开始位置
    ///   - end: 结束为止
    /// - Returns: 修改后的字符串
    func stringAddSecret(start: Int, end: Int) -> String {
        if !(end < count) || start > end { return "取值范围错误" }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        let string = self.replacingCharacters(in: startIndex...endIndex, with: "****")
        return string
    }

    /// 字符URL格式化,中文路径encoding
    ///
    /// - Returns: 格式化的 url
    public func stringEncoding() -> String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url!
    }
    ///是否包含字符串
    public func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    ///去除String前后空格
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
}

extension NSString {
    ///修改字符串中数字样式
    @objc
    public func attributeNumber(_ fontsize :CGFloat,color:UIColor,hcolor:UIColor,B:Bool) -> NSMutableAttributedString {
       return (self as String).attributeNumber(fontsize, color: color, hcolor: hcolor, B: B)
    }
}
extension String {
    /// 删除字符串中Unicode.Cc/Cf字符,类似于\0这种
    public func stringByRemovingControlCharacters() -> String {
        let controlChars = CharacterSet.controlCharacters
        var range = self.rangeOfCharacter(from: controlChars)
        var mutable = self
        while let removeRange = range {
            mutable.removeSubrange(removeRange)
            range = mutable.rangeOfCharacter(from: controlChars)
        }
        return mutable
    }
    /// 修改字符串中数字样式,将其加粗,变黑,加大4个字号,同时修改行间距
    ///
    /// - Parameters:
    ///   - fontsize: 非数字字号
    ///   - color: 非数字颜色
    ///   - lineSpace: 行间距
    /// - Returns: 修改完成的AttributedString
    public func attributeNumber(BoldFontSize fontsize:CGFloat, color:UIColor,lineSpace:CGFloat?) -> NSMutableAttributedString {
        let AttributedStr = NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: fontsize), .foregroundColor: color])
        for i in 0 ..< self.count {
            let char = self.utf8[self.index(self.startIndex, offsetBy: i)]
            if (char > 47 && char < 58) {
                AttributedStr.addAttribute(.foregroundColor, value: UIColor(red: 33 / 255.0, green: 34 / 255.0, blue: 35 / 255.0, alpha: 1), range: NSRange(location: i, length: 1))
                AttributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontsize + 4), range: NSRange(location: i, length: 1))
            }
        }
        if let space = lineSpace {
            let paragraphStyleT = NSMutableParagraphStyle()
            paragraphStyleT.lineSpacing = space
            AttributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyleT, range: NSRange(location: 0, length: self.count))
        }
        return AttributedStr
    }
    /// 给字符串中数字变样式
    ///
    /// - Parameters:
    ///   - fontsize: 字体大小
    ///   - color: 非数字颜色
    ///   - hcolor: 数字颜色
    ///   - B: 是否加粗变大
    /// - Returns: 修改完成字符串
    public func attributeNumber(_ fontsize :CGFloat,color:UIColor,hcolor:UIColor,B:Bool) -> NSMutableAttributedString {
        let AttributedStr = NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: fontsize), .foregroundColor: color])
        for i in 0 ..< self.count {
            let char = self.utf8[self.index(self.startIndex, offsetBy: i)]
            if (char > 47 && char < 58) {
                AttributedStr.addAttribute(.foregroundColor, value: hcolor, range: NSRange(location: i, length: 1))
                if B {
                    AttributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontsize + 2), range: NSRange(location: i, length: 1))
                }
            }
        }
        return AttributedStr
    }
}
// swiftlint:disable missing_docs
extension String {
    /// 字符串长度
    public var length: Int {
        ///更改成其他的影响含有emoji协议的签名
        return self.utf16.count
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    public var intValue: Int32 {
        return (self as NSString).intValue
    }
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var integerValue: Int {
        return (self as NSString).integerValue
    }
    public var longLongValue: Int64 {
        return (self as NSString).longLongValue
    }
    public var boolValue: Bool {
        return (self as NSString).boolValue
    }
}

/// String转换成URL
public protocol URLConvertibleProtocol {
    var URLValue: URL? { get }
    var URLStringValue: String { get }
}
extension String: URLConvertibleProtocol {
    /// String转换成URL
    public var URLValue: URL? {
        if let URL = URL(string: self) {
            return URL
        }
        let set = CharacterSet()
            .union(.urlHostAllowed)
            .union(.urlPathAllowed)
            .union(.urlQueryAllowed)
            .union(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }
    public var URLStringValue: String {
        return self
    }
}

extension String {
    /**
     将当前字符串拼接到cache目录后面
     */
    public func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        return (path as NSString).appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到doc目录后面
     */
    public func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        return (path as NSString).appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到tmp目录后面
     */
    public func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
}

extension String {
    ///判断String是否存在汉字
    public func isIncludeChineseIn() -> Bool {
        for value in self {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    //range转换为NSRange
     func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
           return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
}

// MARK: - get String height
extension String {
    func getLableHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        let dic = [NSAttributedString.Key.font:font] // swift 4.0
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        return ceil(strSize.height) + 1
    }
    ///获取字符串的宽度
    func getLableWidth(font:UIFont,height:CGFloat) -> CGFloat {
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        let dic = [NSAttributedString.Key.font:font] // swift 3.0
        let cString = self.cString(using: String.Encoding.utf8)
        let str = String.init(cString: cString!, encoding: String.Encoding.utf8)
        let strSize = str?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return strSize?.width ?? 0
    }
}






// MARK: - get NSAttributedString height
extension NSAttributedString {
    /// 根据给定的范围计算宽高，如果计算宽度，则请把宽度设置为最大，计算高度则设置高度为最大
    /// - Parameters:
    ///   - width: 宽度的最大值
    ///   - height: 高度的最大值
    /// - Returns: 文本的实际size
    func getSize(width: CGFloat,height: CGFloat) -> CGSize {
        let attributed = self
        _ = CTFramesetterCreateWithAttributedString(attributed)
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        let framesetter = CTFramesetterCreateWithAttributedString(attributed)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange.init(location: 0, length: attributed.length), nil, rect.size, nil)
        return CGSize.init(width: size.width + 1, height: size.height + 1)
    }
    
    func getImageRunFrame(run: CTRun, lineOringinPoint: CGPoint, offsetX: CGFloat) -> CGRect {
        /// 计算位置 大小
        var runBounds = CGRect.zero
        var h: CGFloat = 0
        var w: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var asecnt: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        
        let cfRange = CFRange.init(location: 0, length: 0)
        w = CGFloat(CTRunGetTypographicBounds(run, cfRange, &asecnt, &descent, &leading))
        h = asecnt + descent + leading
        /// 获取具体的文字距离这行原点的距离 || 算尺寸用的
        x = offsetX + lineOringinPoint.x
        /// y
        y = lineOringinPoint.y - descent
        runBounds = CGRect.init(x: x, y: y, width: w, height: h)
        return runBounds
    }
}

extension String {
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.trim().addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    /// 删除特殊字符
    func deleteSpecialCharacters(_ regex: String? = nil) -> String {
        var pattern: String = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}]"
        if let str = regex {
            pattern = str
        }
        let express = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return express.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
}


extension String {
    /// MD5加密
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    /// MD5加密大写
    var md5_uppercased: String{
        return self.md5.uppercased()
    }
}


extension String{
    /// 字符串日期是否早于当前时间
       /// - Parameters:
       ///   - time: "2020-12-31 23:59:59"字符串日期
       ///   - style: "yyyy-MM-dd HH:mm:ss"
    func isBeforeNow(_ style: String = "yyyy-MM-dd HH:mm:ss") -> Bool{
        let endDate = self.toDate(style: StringToDateStyles.custom(style))
        let now = DateInRegion.init(Date(), region: Region.current)
        if endDate?.isBeforeDate(now, granularity: Calendar.Component.minute) == true {
            return true
        } else {
            return false
        }
    }
}

extension String {
    /// 获取当前设备IP
    static func getOperatorsIP() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    //获取本机无线局域网ip
    static func getWifiIP() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}

extension String {
    /// 获取随机字符串
    /// - Parameter length: 随机字符串的长度
    static func getRandomString(length: Int) -> String {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(str.count)))
            let start = str.index(str.startIndex, offsetBy: index)
            let end = str.index(str.startIndex, offsetBy: index + 1)
            let char = str[start..<end]
            ranStr.append(contentsOf: char)
        }
        return ranStr
    }
    
    
    /// 阿拉伯数字转汉字
    /// - Parameter number: 整型数字
    static func intToString(number: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style(rawValue: UInt(CFNumberFormatterRoundingMode.roundHalfDown.rawValue))!
        let string:String = formatter.string(from: NSNumber(value: number))!
        return string
    }
    
    /// 汉字转拼音
    /// - Parameter str: 汉字字符串
    func hanZiTransformToPinYin() -> String {
        let mutabString = NSMutableString(string: self)
        //1.先转换为带声调的拼音
        CFStringTransform(mutabString, nil, kCFStringTransformMandarinLatin, false)
        //2.去掉音调
        CFStringTransform(mutabString, nil, kCFStringTransformStripCombiningMarks, false)
        return String(mutabString)
    }
}

public struct PasswordType: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let number: PasswordType = PasswordType(rawValue: 1 << 0)
    public static let special: PasswordType = PasswordType(rawValue: 1 << 1)
    public static let capLetter: PasswordType = PasswordType(rawValue: 1 << 2)
    public static let lowLetter: PasswordType = PasswordType(rawValue: 1 << 3)
    public static let letter: PasswordType = PasswordType(rawValue: 1 << 4)
}

extension String {
    /// ZJaDe: 是否是密码 passwordType表示密码的字符类型，如果传[] 表示不限制类型
    public func isPassword(minLength: Int, maxLength: Int?, passwordType: PasswordType = []) -> Bool {
        guard self.count >= minLength && self.count <= maxLength ?? Int.max else {
            return false
        }
        if passwordType == [] {
            return true
        }
        var result: Bool = true
        if passwordType.contains(.number) != checkContainsNumber() {
            result = false
        }
        if passwordType.contains(.letter) != checkContainsLetter() {
            result = false
        }
        if passwordType.contains(.letter) == false {
            if passwordType.contains(.lowLetter) != checkContainsLowLetter() {
                result = false
            }
            if passwordType.contains(.capLetter) != checkContainsCapLetter() {
                result = false
            }
        }
        if passwordType.contains(.special) != checkContainsSpecialChar() {
            result = false
        }
        return result
    }
    public func checkContainsNumber() -> Bool {
        return self.isValidate(by: "^.*[0-9].*$")
    }
    public func checkContainsLetter() -> Bool {
        return self.isValidate(by: "^.*[a-zA-Z].*$")
    }
    public func checkContainsLowLetter() -> Bool {
        return self.isValidate(by: "^.*[a-z].*$")
    }
    public func checkContainsCapLetter() -> Bool {
        return self.isValidate(by: "^.*[A-Z].*$")
    }
    public func checkContainsSpecialChar() -> Bool {
        return self.isValidate(by: "^.*[^a-zA-Z0-9].*$")
    }
}

extension String {
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: count))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    public var isNumber: Bool {
        return NumberFormatter().number(from: self) != nil
    }
    /// ZJaDe: 是否包含 Emoji
    public var includesEmoji: Bool {
        for i in 0...count {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    /// 验证日期是否合法
    public var isValidateDate: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.date(from: self) != nil
    }
}
// MARK: - NSPredicate
extension String {
    public func isValidate(by regex: String) -> Bool {
        // swiftlint:disable force_try
        return try! Regex(regex).test(testStr: self)
//        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
//        return pre.evaluate(with: self)
    }
    /// ZJaDe: 是否可以转换成数字
    public var isPureInt: Bool {
        let scan = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val)
    }
    /// ZJaDe: 是否全是小写字母
    public var isLowercase: Bool {
        let regex = "^[a-z]+$"
        return self.isValidate(by: regex)
    }
    /// ZJaDe: 是否全是大写字母
    public var isCapitalized: Bool {
        let regex = "^[A-Z]+$"
        return self.isValidate(by: regex)
    }
    /// ZJaDe: 是否是价格
    public var isPrice: Bool {
//        let regex = "^\\d*\\.?\\d{0,2}$"
        let regex = "^(?:0\\.\\d{0,1}[1-9]|(?!0)\\d{1,6}(?:\\.\\d{0,1}[1-9])?)$"
        return self.isValidate(by: regex)
    }
    
    /// 是否是有效的url字符串
    public var isValidateUrlString: Bool {
//        let regex = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        let regex = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return self.isValidate(by: regex)
    }
}
// MARK: - Regex
extension String {
    /// syk: 是否是手机号
    public var isMobilePhone: Bool {
        var result: Bool = false
        if self.isValidate(by: "^(1[0-9][0-9])[0-9]{8}$") {
            result = true
        }
        return result
    }
    /// syk: 是否是验证码
    public var isCode: Bool {
        var result: Bool = false
        if self.isValidate(by: "^[0-9]{6}$") {
            result = true
        }
        return result
    }
    /// syk: 判断名字是否正确
    public var isTrueName: Bool {
        return self.isValidate(by: "^[\\u4e00-\\u9fa5]{2,}$")
    }
    /// syk: 判断是否含有中文
    public var isContainChinese: Bool {
        return self.isValidate(by: "^.*[\\u4e00-\\u9fa5].*$")
    }
    /// syk: 纯英文
    public var isPureEnglish: Bool {
        let regex = "^[a-zA-Z]+$"
        return self.isValidate(by: regex)
    }
    /// syk: 纯英文或者纯数字
    public var isPureEnglishOrInt: Bool {
        let regex = "^[a-zA-Z]+$|^[0-9]+$"
        return self.isValidate(by: regex)
    }
}

// MARK: - Others
extension String {
    //判断是否为有效银行卡号
    public var isValidBankCard: Bool {
        /// ZJaDe: 判断是不是数字
        guard self.isNumber else {
            return false
        }
        /// ZJaDe: 判断位数对不对
        let numberLength = self.count
        guard numberLength >= 13 && numberLength <= 19 else {
            return false
        }
        /// ZJaDe: 反转并转换成数字数组
        guard let array = self.reversed().map({$0.wholeNumberValue}) as? [Int] else {
            return false
        }
        struct Result {
            var oddNumber: Int = 0 //奇数位和
            var evenNumber: Int = 0 //偶数位和
        }
        /// ZJaDe: 数组从1开始计数，奇数位累加到oddNumber, 偶数位累加到evenNumber
        let result: Result = array.lazy.enumerated().reduce(into: .init()) { (result, arg1) in
            var (offSet, element) = arg1
            if (offSet + 1) % 2 == 0 {
                element *= 2
                if element >= 10 {
                    element -= 9
                }
                result.evenNumber += element
            } else {
                result.oddNumber += element
            }
        }
        return (result.oddNumber + result.evenNumber) % 10 == 0
    }
}
extension String {
    /// 判断输入是否为身份证号码
    public var isIdentificationNo: Bool {
        var result: Bool = false
        if self.isValidate(by: "^[0-9]{15}$|^[0-9]{18}$|^[0-9]{17}([0-9]|X|x)$") && calculateIdentificationNo {
            result = true
        }
        return result
    }
    subscript (r: Range<Int>) -> Substring {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }
    private var calculateIdentificationNo: Bool {
        let count = self.count
        if count == 15 {
            return ("19" + self[6..<12]).isValidateDate
        }
        guard count == 18 else {
            return false
        }
        guard String(self[6..<14]).isValidateDate else {
            return false
        }
        //将前17位加权因子保存在数组里
        let weightingCoefficient = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        let validateNums = ["1", "0", "x", "9", "8", "7", "6", "5", "4", "3", "2"]

        //用来保存前17位各自乖以加权因子后的总和 并 取余数计算出校验码所在数组的位置
        let remainder: Int = zip(weightingCoefficient, self).reduce(0) { (result, arg1) -> Int in
            let (num, char) = arg1
            return result + (char.wholeNumberValue ?? 0) * num
        } % 11
        //得到最后一位身份证号码 校验
        return validateNums[remainder] == self.last!.lowercased()
    }
}

extension String {
    /// 获取匹配的字符串
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - targetString: 目标字符串
    public func matchesStrings(pattern: String) -> [String]? {
        var strs:[String] = []
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        guard let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.length)) else { return nil }
        for result in results {
            let str = (self as NSString).substring(with: result.range)
            strs.append(str)
        }
        
        return strs
    }
}




