//
//  JYFilterItemViewConfig.swift
//  AppTest
//
//  Created by 裴雷 on 2019/1/25.
//  Copyright © 2019 张冬. All rights reserved.
//

import Foundation
import UIKit

/**
 *  筛选视图协议枚举
 */
/// 筛选数据协议
public protocol JYFilterPrototcol {
    /// 标识
    var id: String {set get}
    /// 名称
    var title: String {set get}
    /// 子集合
    var itemList: [JYFilterItemPrototcol] {set get}
}
/// 筛选子数据协议
public protocol JYFilterItemPrototcol {
    /// 标识
    var id: String {set get}
    /// 名称
    var name: String {set get}
    /// 状态
    var state: JYFilterState {set get}
}
/// 筛选状态
///
/// - normalState: default state
/// - selectState: select state
public enum JYFilterState: Int {
    case normalState
    case selectState
}
/// 筛选模式
///
/// - noSelect:
/// - singleSelcet: 单选
/// - multipleSelect: 多选(最大值)
public enum JYFilterSelectModel: Equatable{
    case noSelect
    case singleSelcet
    case multipleSelect(max: Int)
}

