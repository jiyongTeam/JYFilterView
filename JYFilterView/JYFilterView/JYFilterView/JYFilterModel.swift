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
}

/// 筛选子视图数据模型
public struct JYFilterItemModel: JYFilterItemPrototcol {

    public var id: String = ""
    
    public var name: String = ""
    
    public var state: JYFilterState = .normalState

}
/// 筛选视图样式模型
public struct JYFilterViewStyle{
    // 筛选设置
    public var filterOptions = JYFilterOptions()
    // 标题样式
    public var titleStyle = JYFilterViewLabelStyle()
    // 统计样式
    public var statisticsStyle = JYFilterViewLabelStyle()
    // 布局样式
    public var layoutStyle = JYFilterViewLayoutStyle()
    // 子视图样式
    public var itemViewStyle = JYFilterItemViewStyle()
}
/// 筛选选项设置
public struct JYFilterOptions {
    // 筛选模式
    public var filterModel = JYFilterSelectModel.noSelect
    // 选中项取消
    public var isCancelSelectedStatue: Bool = true
    // 是否显示统计选中数据
    public var isShowStatistics: Bool = false
}
/// 筛选视图布局样式模型
public struct JYFilterViewLayoutStyle{
    
    public var itemColumns: Int = 4
    
    public var itemHeight: CGFloat = 36
    
    public var itemXSpacing: CGFloat = 10
    
    public var itemYSpacing: CGFloat = 12
}
/// 筛选视图标题样式模型
public struct JYFilterViewLabelStyle{
    
    public var backgroundColor: UIColor = UIColor.clear
    
    public var textColor: UIColor = UIColor.init(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1)
    
    public var textFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
}
/// 筛选子视图样式模型
public struct JYFilterItemViewStyle{
    
    public var normalStyle = JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)], cornerRadius: 6, borderWidth: 1, borderColor: UIColor.init(red: 255.0/255.0, green: 157.0/255.0, blue: 76.0/255.0, alpha: 1), nameColor: UIColor.init(red: 255.0/255.0, green: 157.0/255.0, blue: 76.0/255.0, alpha: 1), nameFont: UIFont.systemFont(ofSize: 13, weight: .regular))
    
    public var selectedStyle = JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.init(red: 255.0/255.0, green: 166.0/255.0, blue: 77.0/255.0, alpha: 1),UIColor.init(red: 253.0/255.0, green: 144.0/255.0, blue: 75.0/255.0, alpha: 1)], cornerRadius: 6, borderWidth: 0, borderColor: UIColor.init(red: 255.0/255.0, green: 157.0/255.0, blue: 76.0/255.0, alpha: 1), nameColor: UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1), nameFont: UIFont.systemFont(ofSize: 13, weight: .bold))
}
/// 筛选子视图样式模型
public struct JYFilterItemViewStateStyle{
    public var backgroundColors: [UIColor] = [UIColor.lightGray]
    public var cornerRadius: CGFloat = 6
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor? = nil
    public var nameColor: UIColor = UIColor.orange
    public var nameFont: UIFont = UIFont.systemFont(ofSize: 14)
}
