//
//  JYFilterItemModel.swift
//  rts
//
//  Created by 裴雷 on 2019/1/28.
//  Copyright © 2019 张冬. All rights reserved.
//

import Foundation
import UIKit
/**
 *  筛选视图数据结构
 */
/// 筛选视图数据模型：数据源
public struct JYFilterModel: JYFilterPrototcol{
    
    public var id: String = ""
    
    public var title: String = ""
    
    public var itemList: [JYFilterItemPrototcol] = []
    
    public init(id: String = "", title: String = "", itemList: [JYFilterItemPrototcol] = []){
        self.id = id
        self.title = title
        self.itemList = itemList
    }
}

/// 筛选子视图数据模型
public struct JYFilterItemModel: JYFilterItemPrototcol {

    public var id: String = ""
    
    public var name: String = ""
    
    public var state: JYFilterState = .normalState
    
    public init(id: String = "", name: String = "", state: JYFilterState = .normalState){
        self.id = id
        self.name = name
        self.state = state
    }
}
/// 筛选视图样式模型
public struct JYFilterViewStyle{
    // 筛选设置
    public var filterOptions: JYFilterOptions = JYFilterOptions()
    // 标题样式
    public var titleStyle: JYFilterViewLabelStyle = JYFilterViewLabelStyle()
    // 统计样式
    public var statisticsStyle: JYFilterViewLabelStyle = JYFilterViewLabelStyle()
    // 布局样式
    public var layoutStyle: JYFilterViewLayoutStyle = JYFilterViewLayoutStyle()
    // 子视图样式
    public var itemViewStyle: JYFilterItemViewStyle = JYFilterItemViewStyle()
    //
    public init(filterOptions: JYFilterOptions = JYFilterOptions(), titleStyle: JYFilterViewLabelStyle = JYFilterViewLabelStyle(), statisticsStyle: JYFilterViewLabelStyle = JYFilterViewLabelStyle(), layoutStyle: JYFilterViewLayoutStyle = JYFilterViewLayoutStyle(), itemViewStyle: JYFilterItemViewStyle = JYFilterItemViewStyle()){
        self.filterOptions = filterOptions
        self.titleStyle = titleStyle
        self.statisticsStyle = statisticsStyle
        self.layoutStyle = layoutStyle
        self.itemViewStyle = itemViewStyle
    }
}
/// 筛选选项设置
public struct JYFilterOptions {
    // 筛选模式
    public var filterModel: JYFilterSelectModel = JYFilterSelectModel.noSelect
    // 选中项取消
    public var isCancelSelectedStatue: Bool = true
    // 是否显示统计选中数据
    public var isShowStatistics: Bool = false
    //
    public init(filterModel: JYFilterSelectModel = JYFilterSelectModel.noSelect, isCancelSelectedStatue: Bool = true, isShowStatistics: Bool = false){
        self.filterModel = filterModel
        self.isCancelSelectedStatue  = isCancelSelectedStatue
        self.isShowStatistics = isShowStatistics
    }
}
/// 筛选视图布局样式模型
public struct JYFilterViewLayoutStyle{
    
    public var itemColumns: Int = 4
    
    public var itemHeight: CGFloat = 36
    
    public var itemXSpacing: CGFloat = 10
    
    public var itemYSpacing: CGFloat = 12
    //
    public init(itemColumns: Int = 4, itemHeight: CGFloat = 36, itemXSpacing: CGFloat = 10, itemYSpacing: CGFloat = 12){
        self.itemColumns = itemColumns;
        self.itemHeight = itemHeight;
        self.itemXSpacing = itemXSpacing
        self.itemYSpacing = itemYSpacing
    }
}
/// 筛选视图标题样式模型
public struct JYFilterViewLabelStyle{
    // 背景色
    public var backgroundColor: UIColor = UIColor.clear
    // 字体颜色
    public var textColor: UIColor = UIColor.init(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1)
    // 字体大小
    public var textFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    // 初始化
    public init(backgroundColor: UIColor = UIColor.clear, textColor: UIColor = UIColor.init(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1), textFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)){
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textFont = textFont
    }
}
/// 筛选子视图样式模型
public struct JYFilterItemViewStyle{
    // 正常状态
    public var normalStyle: JYFilterItemViewStateStyle = JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)], cornerRadius: 6, borderWidth: 1, borderColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameFont: UIFont.systemFont(ofSize: 13, weight: .regular))
    // 选中状态
    public var selectedStyle:JYFilterItemViewStateStyle = JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.init(red: 0.8, green: 0.68, blue: 0.49, alpha: 1),UIColor.init(red: 1, green: 0.91, blue: 0.79, alpha: 1)], cornerRadius: 6, borderWidth: 0, borderColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameFont: UIFont.systemFont(ofSize: 13, weight: .regular))
    // 初始化
    public init(
        normalStyle: JYFilterItemViewStateStyle = JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)], cornerRadius: 6, borderWidth: 1, borderColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameFont: UIFont.systemFont(ofSize: 13, weight: .regular)),
        selectedStyle:JYFilterItemViewStateStyle = JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.init(red: 0.8, green: 0.68, blue: 0.49, alpha: 1),UIColor.init(red: 1, green: 0.91, blue: 0.79, alpha: 1)], cornerRadius: 6, borderWidth: 0, borderColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameColor: UIColor.init(red: 0.5, green: 0.31, blue: 0.14, alpha: 1), nameFont: UIFont.systemFont(ofSize: 13, weight: .regular))){
        self.normalStyle = normalStyle
        self.selectedStyle = selectedStyle
    }
}
/// 筛选子视图样式模型
public struct JYFilterItemViewStateStyle{
    public var backgroundColors: [UIColor] = [UIColor.lightGray]
    public var cornerRadius: CGFloat = 6
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor? = nil
    public var nameColor: UIColor = UIColor.orange
    public var nameFont: UIFont = UIFont.systemFont(ofSize: 14)
    // 初始化
    public init(backgroundColors: [UIColor] = [UIColor.lightGray], cornerRadius: CGFloat = 6, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, nameColor: UIColor = UIColor.orange, nameFont: UIFont = UIFont.systemFont(ofSize: 14)){
        self.backgroundColors = backgroundColors
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.nameColor = nameColor
        self.nameFont = nameFont
    }
}
