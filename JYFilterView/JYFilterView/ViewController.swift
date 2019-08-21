//
//  ViewController.swift
//  JYFilterView
//
//  Created by 裴雷 on 2019/8/20.
//  Copyright © 2019 JY Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //筛选视图数据源
    private lazy var filterViewData: JYFilterModel = {
        var itemList: [JYFilterItemModel] = []
        for i in 0..<10{
           let item =  JYFilterItemModel.init(id: "\(i)", name: "\(i * 100)", state: .normalState)
            itemList.append(item)
        }
        let model = JYFilterModel.init(id: "1", title: "111", itemList: itemList)
        return model
    }()
    //默认样式 (存展示)
    private lazy var defaultView: JYFilterView = {
        let view = JYFilterView.init(data: self.filterViewData)
        return view
    }()
    //单选
    private lazy var singleSelectView: JYFilterView = {
        var viewStyle = JYFilterViewStyle()
        var filterOptions = JYFilterOptions()
        filterOptions.filterModel = .singleSelcet
        filterOptions.isShowStatistics = false
        viewStyle.filterOptions = filterOptions
        let view = JYFilterView.init(data: self.filterViewData, style: viewStyle)
        return view
    }()
    //多选
    private lazy var multiSelectView: JYFilterView = {
        let view = JYFilterView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        configUI()
        //
        testMultiSelectView()
    }
}
//测试
extension ViewController{
    //测试多选,自定义样式,更新样式和数据.
    private func testMultiSelectView(){
        var viewStyle = JYFilterViewStyle()
        // 选择模式
        var filterOptions = JYFilterOptions()
        filterOptions.filterModel = .multipleSelect(max: 3)
        filterOptions.isShowStatistics = true
        viewStyle.filterOptions = filterOptions
        // 布局样式
        var layout = JYFilterViewLayoutStyle()
        layout.itemColumns = 3
        layout.itemXSpacing = 20
        layout.itemHeight = 50
        viewStyle.layoutStyle = layout
        var titleStyle = JYFilterViewLabelStyle()
        titleStyle.textColor = UIColor.red
        viewStyle.titleStyle = titleStyle
        // item样式,正常/选中
        let itemViewStyle = JYFilterItemViewStyle(normalStyle: JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.lightGray], cornerRadius: 8, borderWidth: 1, borderColor: UIColor.blue, nameColor: UIColor.blue, nameFont: UIFont.systemFont(ofSize: 14, weight: .regular)), selectedStyle: JYFilterItemViewStateStyle.init(backgroundColors: [UIColor.orange], cornerRadius: 8, borderWidth: 0, borderColor: UIColor.blue, nameColor: UIColor.white, nameFont: UIFont.systemFont(ofSize: 14, weight: .regular)))
        viewStyle.itemViewStyle = itemViewStyle
        //更新样式
        multiSelectView.updateViewStyle(viewStyle)
        //更新数据
        multiSelectView.updateData(filterViewData)
    }
}
// UI
extension ViewController{
    func configUI(){
        view.backgroundColor = UIColor.lightGray
        let vd: [String: UIView] = [
            "defaultView": defaultView,
            "singleSelectView": singleSelectView,
            "multiSelectView": multiSelectView,
        ]
        view.addSubview(defaultView)
        view.addSubview(singleSelectView)
        view.addSubview(multiSelectView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[defaultView]-10-|", options: [], metrics: nil, views: vd))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[singleSelectView]-10-|", options: [], metrics: nil, views: vd))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[multiSelectView]-10-|", options: [], metrics: nil, views: vd))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[defaultView]-20-[singleSelectView]-20-[multiSelectView]", options: [], metrics: nil, views: vd))
    }
}
