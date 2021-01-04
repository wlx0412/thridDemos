//
//  YLPickerPopup.swift
//  YLDatePicker
//
//  Created by Yeonluu on 2018/6/14.
//  Copyright © 2018年 Yeonluu. All rights reserved.
//

import UIKit

class YLPickerPopup: YLPopup, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerView = UIPickerView()
    
    override func setup() {
        super.setup()
//        pickerView.showsSelectionIndicator = true
        pickerView.frame = contentView.bounds
        pickerView.delegate = self
        pickerView.dataSource = self
        contentView.addSubview(pickerView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
