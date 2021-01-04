//
//  YLDatePickerPopup.swift
//  YLDatePicker
//
//  Created by Yeonluu on 2018/7/10.
//  Copyright © 2018年 Yeonluu. All rights reserved.
//

import UIKit
import Foundation

class YLDatePickerPopup: YLPopup {
    /// 时间滚轮
    public var datePicker: YLDatePickerView!
    
    /// 是否自动更新当前时间
    public var isAutoUpdateNowTime = true

    init(dateRangeType: YLDatePickerView.DateRangeType, beginDate: Date?, endDate: Date?) {
        datePicker = YLDatePickerView.init(dateRangeType: dateRangeType, beginDate: beginDate, endDate: endDate)
        super.init()
    }
    
    /// 构造方法
    ///
    /// - Parameters:
    ///   - dateRangeType: 时间范围类型
    ///   - beginDate: 起始时间 传nil表示当前时间 （可以刚好选至该时间）
    ///   - endDate: 结束时间 传nil表示当前时间 （可以刚好选至该时间）
    ///   - hourRange: 小时范围 默认为0...23
    ///   - minuteInterval: 分钟间隔 默认为1分钟
    init(dateRangeType: YLDatePickerView.DateRangeType, beginDate: Date?, endDate: Date?, hourRange: CountableClosedRange<Int> = 0...23, minuteInterval: Int = 1) {
        datePicker = YLDatePickerView.init(dateRangeType: dateRangeType, beginDate: beginDate, endDate: endDate, hourRange: hourRange, minuteInterval: minuteInterval)
        super.init()
    }
        
    override func setup() {
        super.setup()
        title = "选择时间"
        if datePicker == nil {
            datePicker = YLDatePickerView.init(dateRangeType: .fullDateAndTime, beginDate: nil, endDate: nil)
        }
        datePicker.frame = contentView.bounds
        contentView.addSubview(datePicker)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        datePicker.frame = contentView.bounds
    }
    
    /// 选中时间
    public func setSelectedDate(_ date: Date?) {
        datePicker.setSelectedDate(date)
    }
    
    /// 获取选中的时间
    public func getSelectedDate() -> Date {
        return datePicker.getSelectedDate()
    }
    
    /// 获取选中的时间字符串
    public func getSelectedDateString() -> String {
        return datePicker.getSelectedDateString()
    }
    
    override func showView() {
        if isAutoUpdateNowTime {
            datePicker.updateNowDate()
        }
        super.showView()
    }
}
