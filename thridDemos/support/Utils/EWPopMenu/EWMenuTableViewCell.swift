//
//  EWMenuTableViewCell.swift
//  EWPopMenu
//
//  Created by Ethan.Wang on 2018/9/27.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

/// imageView左侧留白
let kLineXY: CGFloat = 13.0
/// imageView宽度
let kImageWidth: CGFloat = 18.0
/// imageView与label之间留白
let kImgLabelWidth: CGFloat = 10.0

class EWMenuTableViewCell: UITableViewCell {
    static let identifier = "EWMenuTableViewCell"
    lazy var line: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.backgroundColor()
        return lineView
    }()

    private lazy var iconImg: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: kLineXY, y: (itemHeight - kImageWidth)/2, width: kImageWidth, height: kImageWidth))
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    public lazy var conLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 42, y: 0, width: itemWidth - 57, height: itemHeight))
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.tertiaryLabelColor()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //红点lab
    public lazy var numberLab: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.mainTHemeColor
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        drawMyView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawMyView() {
        self.addSubview(iconImg)
        iconImg.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(kLineXY)
            make.centerY.equalToSuperview()
            make.size.equalTo(Size.kAdaptSize(size: CGSize(width: kImageWidth, height: kImageWidth)))
        }
        self.addSubview(conLabel)
        conLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(kLineXY + kImgLabelWidth + kImageWidth)
            make.right.equalToSuperview().offset(kLineXY)
            make.centerY.equalToSuperview()
            make.height.equalTo(itemHeight)
        }
        
        self.addSubview(numberLab)
        numberLab.snp_makeConstraints { (make) in
            make.left.equalTo(conLabel.snp.right).offset(2)
            make.centerY.equalToSuperview()
            make.size.equalTo(Size.kAdaptSize(size: CGSize(width: 8, height: 8)))
        }
        numberLab.setBorder(radius: Size.kAdaptWidth(4))
        
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(Size.size10)
            make.right.equalToSuperview().offset(-Size.size10)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    public func setContentBy(titArray: [String], imgArray: [String], row: Int) {
        if imgArray.isEmpty {
            self.iconImg.isHidden = true
            conLabel.snp_remakeConstraints { (make) in
                make.center.equalToSuperview()
            }
        } else {
            self.iconImg.isHidden = false
            self.conLabel.frame = CGRect(x: self.iconImg.frame.maxX + kImgLabelWidth, y: 0, width: itemWidth - kImgLabelWidth - kLineXY - kImageWidth - 15 , height: itemHeight)
            self.iconImg.image = UIImage(named: imgArray[row])
        }
    }
}
