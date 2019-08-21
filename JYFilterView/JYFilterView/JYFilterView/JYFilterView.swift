//
//  JYFilterView.swift
//  rts
//
//  Created by 裴雷 on 2019/2/2.
//  Copyright © 2019 张冬. All rights reserved.
//

import UIKit

/**
 *  筛选视图
 */
public class JYFilterView: UIView {
    /// 选择事件回调
    private var selectFilterViewBlock:((_ itemID: String) -> Void)?
    /// 筛选模式
    private var filterModel = JYFilterSelectModel.singleSelcet{
        didSet{
            switch filterModel {
            case .noSelect:
                self.maxSelectCount = 0
            case .singleSelcet:
                self.maxSelectCount = 1
            case .multipleSelect(let max):
                self.maxSelectCount = max
            }
        }
    }
    /// 最大选中个数
    private var maxSelectCount: Int = 0
    /// 数据源
    private var data: JYFilterPrototcol?
    /// 选中集合
    private var selectedItems: [JYFilterItemPrototcol] = []{
        didSet{
            self.statisticalLabel.text = "\(selectedItems.count)/\(maxSelectCount)"
        }
    }
    /// 筛选子视图集合
    private var itemViewList: [JYFilterItemView] = []
    /// 样式
    private var style = JYFilterViewStyle()
    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.init(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1)
        return label
    }()
    /// 子视图容器
    private lazy var itemsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// 统计选中个数标签
    private lazy var statisticalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1)
        return label
    }()
    /// 标题底部的间距(与子视图容器的间距)
    private var titleBottomConstraint: NSLayoutConstraint?
    /// 初始化
    ///
    /// - Parameters:
    ///   - data: data
    ///   - style: style
    convenience init(data: JYFilterPrototcol, style: JYFilterViewStyle = JYFilterViewStyle()){
        self.init()
        self.data = data
        self.style = style
        configSelectedData()
        configTitleView()
        configFilterMode()
        configStatisticalView()
        configItemsContainerView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInitializeUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: ----获取
extension JYFilterView{
    /// 获取页面数据
    ///
    /// - Returns: 页面数据
    public func getData() -> JYFilterPrototcol?{
        return self.data
    }
    /// 获取选中数据
    ///
    /// - Returns: selected item view data list
    public func getSelectedDataList() -> [JYFilterItemPrototcol]{
        guard self.data != nil else {
            return []
        }
        return selectedItems
    }
}
//MARK:----设置
extension JYFilterView{
    /// 更新数据(所有数据源)
    ///
    /// - Parameters:
    ///   - data: 数据源
    public func updateData(_ data: JYFilterPrototcol) {
        self.data = data
        self.configSelectedData()
        configTitleData()
        configItemsContainerView()
    }
    /// 更新选中数据(注意: 内部清空之前的)
    ///
    /// - Parameter items: 新的选中集合
    public func updateSelectedItems(_ items: [JYFilterItemPrototcol]) {
        guard let data = self.data, data.itemList.count == itemViewList.count  else {
            return
        }
        selectedItems.removeAll()
        selectedItems.append(contentsOf: items)
        for index in 0..<data.itemList.count{
            let itemModel = data.itemList[index]
            let itemView = itemViewList[index]
            if selectedItems.firstIndex(where: {$0.id == itemModel.id}) != nil {
                itemView.updateStatus(by: .selectState)
            }else{
                itemView.updateStatus(by: .normalState)
            }
        }
    }
    /// 更新选中数据,使用id (注意: 内部清空之前的)
    ///
    /// - Parameter items: 新的选中集合
    public func updateSelectedItemsById(_ itemIds: [String]) {
        guard let data = self.data, data.itemList.count == itemViewList.count  else {
            return
        }
        selectedItems.removeAll()
        for index in 0..<data.itemList.count{
            let itemModel = data.itemList[index]
            let itemView = itemViewList[index]
            if itemIds.firstIndex(where: {$0 == itemModel.id}) != nil {
                itemView.updateStatus(by: .selectState)
                selectedItems.append(itemModel)
            }else{
                itemView.updateStatus(by: .normalState)
            }
        }
    }
    /// 更新样式
    ///
    /// - Parameter style: 样式
    public func updateViewStyle(_ style: JYFilterViewStyle) {
        self.style = style
        configTitleStyle()
        configFilterMode()
        configStatisticalView()
        guard itemViewList.count > 0 else {
            return
        }
        //约束更新的处理: 删除子视图相关的所有约束
        let associatedConstraints = itemsContainerView.constraints.filter {
            $0.identifier == "JYFilterItemView"
        }
        NSLayoutConstraint.deactivate(associatedConstraints)
        itemsContainerView.removeConstraints(associatedConstraints)
        
        itemViewList.forEach {
            let itemConstraints = $0.constraints.filter {
                $0.identifier == "JYFilterItemView"
            }
            NSLayoutConstraint.deactivate(itemConstraints)
            $0.removeConstraints(itemConstraints)
        }
        for item in itemViewList{
            item.updateViewStyle(style.itemViewStyle)
        }
        configItems()
    }
    /// 更新标题内容
    ///
    /// - Parameter attributedText: 富文本内容
    public func updateTitle(by attributedText: NSAttributedString? ){
        titleLabel.attributedText = attributedText
    }
    /// 更新标题底部的间距
    ///
    /// - Parameter spcing: 距离
    public func updateTitleBottomSpacing(_ spcing: CGFloat) {
        titleBottomConstraint?.constant = spcing
    }
    /// 设置选中事件
    ///
    /// - Parameter block: itemID 选择的item的唯一标识ID
    public func setSelectFilterViewAction(block:((_ itemID: String) -> Void)?) {
        self.selectFilterViewBlock = block
    }
}
//MARK: ----JYFilterItemViewDelegate
extension JYFilterView: JYFilterItemViewDelegate{
    /// item 状态/选择逻辑控制
    ///
    /// - Parameters:
    ///   - filterView: item JYFilterItemView
    ///   - currentState: item 当前状态
    /// - Returns: item nextState
    public func getNextState(itemView filterView: JYFilterItemView, currentState: JYFilterState) -> JYFilterState {
        // 判断能否反选
        if style.filterOptions.isCancelSelectedStatue == false , currentState == .selectState {
            return currentState
        }
        // 状态/单选多选处理
        var nextState = currentState
        switch filterModel {
        case .noSelect:
               return currentState
        case .singleSelcet:
            switch currentState {
            case .normalState:
                nextState =  .selectState
            default:
                nextState = .normalState
            }
            updateItemsStateForSingleSelectMode()
            recordItemsSelectState(by: filterView)
        case .multipleSelect(let max):
            // 状态改变条件(小于最大值和已选中的)
            if isItemInSelectedList(by: filterView) || self.selectedItems.count  < max{
                switch currentState {
                case .normalState:
                    nextState =  .selectState
                default:
                    nextState = .normalState
                }
            }
            // 先选择判断
            recordItemsSelectState(by: filterView)
        }
        //
        if let data =  self.data?.itemList , let index = itemViewList.firstIndex(of: filterView) , index < data.count {
            selectFilterViewBlock?(data[index].id)
        }
        return nextState
    }
}
//MARK: ----私有方法
extension JYFilterView{
    /// 设置选中的集合
    private func configSelectedData(){
        selectedItems.removeAll()
        for itemModel in self.data?.itemList ?? []{
            if itemModel.state == .selectState{
                self.selectedItems.append(itemModel)
            }
        }
    }
    /// 判断当前item view数据
    ///
    /// - Parameters:
    ///   - itemView: 当前itemView
    ///   - text: 内容
    private func updateItemsContent(by itemView: JYFilterItemView, text: String){
        guard var data = self.data else {
            return
        }
        let itemList = data.itemList
        let index = itemView.tag
        var itemModel = itemList[index]
        // 更新所有集合数据源
        itemModel.name = text
        data.itemList[index] = itemModel
        // 更新选中集合数据源
        let itemId = itemModel.id
        let selectList = selectedItems
        if let index = selectList.firstIndex(where: {$0.id == itemId}) {
            var itemModel = selectList[index]
            itemModel.name = text
            selectedItems[index] = itemModel
        }
    }
    /// 更新单选模式状态
    private func updateItemsStateForSingleSelectMode(){
        itemViewList.forEach { (item) in
            item.updateStatus(by: .normalState)
        }
    }
    /// 记录选中的items
    ///
    /// - Parameter filterView: 当前点击的item view
    private func recordItemsSelectState(by itemView: JYFilterItemView){
        guard let data = self.data else {
            return
        }
        var itemList = data.itemList
        var selectList = selectedItems
        let index = itemView.tag
        let itemId = itemList[index].id
        // 选择控制逻辑
        if let index = selectList.firstIndex(where: {$0.id == itemId}) {
            selectList.remove(at: index)
        }else{
            switch filterModel{
            case .singleSelcet:
                selectList.removeAll()
                selectList.append(itemList[index])
            case .multipleSelect(let max):
                if selectedItems.count < max{
                    selectList.append(itemList[index])
                }
            default:
                break
            }
        }
        selectedItems = selectList
    }
    /// 判断当前item view是否已选中
    ///
    /// - Parameter filterView: 当前点击的item view
    private func isItemInSelectedList(by itemView: JYFilterItemView) -> Bool{
        var result = false
        guard let data = self.data else {
            return result
        }
        let itemList = data.itemList
        let index = itemView.tag
        let itemId = itemList[index].id
        result = selectedItems.contains(where: {$0.id == itemId})
        return result
    }
}
//MARK: ----UI
extension JYFilterView{
    /// 设置筛选模式
    private func configFilterMode(){
        filterModel = style.filterOptions.filterModel
    }
    /// 设置标题
    private func configTitleView(){
        configTitleStyle()
        configTitleData()
    }
    private func configTitleData(){
        guard let data = self.data else {
            return
        }
        titleLabel.text = data.title
        if titleLabel.text == nil || titleLabel.text?.isEmpty ?? true{
            titleBottomConstraint?.constant = 0
        }
    }
    private func configTitleStyle(){
        titleLabel.textColor = self.style.titleStyle.textColor
        titleLabel.font = self.style.titleStyle.textFont
        titleLabel.backgroundColor = self.style.titleStyle.backgroundColor
    }
    /// 设置统计标签
    private func configStatisticalView(){
        configStatisticalLabelData()
        configStatisticalLabelStyle()
    }
    private func configStatisticalLabelData(){
        statisticalLabel.text = "\(selectedItems.count)/\(maxSelectCount)"
    }
    private func configStatisticalLabelStyle(){
        statisticalLabel.isHidden = !style.filterOptions.isShowStatistics
        statisticalLabel.textColor = self.style.statisticsStyle.textColor
        statisticalLabel.font = self.style.statisticsStyle.textFont
        statisticalLabel.backgroundColor = self.style.statisticsStyle.backgroundColor
    }
    /// Layout
    private func configInitializeUI(){
        self.backgroundColor = UIColor.white
        configInitializeUILayout()
    }
    private func configInitializeUILayout(){
        self.translatesAutoresizingMaskIntoConstraints = false
        let vd = [
            "titleLabel": titleLabel,
            "itemsContainerView": itemsContainerView,
            "statisticalLabel": statisticalLabel
        ]
        self.addSubview(titleLabel)
        self.addSubview(itemsContainerView)
        self.addSubview(statisticalLabel)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[titleLabel]-(>=0)-[statisticalLabel]|", options: [.alignAllCenterY], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[itemsContainerView]|", options: [], metrics: nil, views: vd))
        //
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[itemsContainerView]|", options: [], metrics: nil, views: vd))
        titleBottomConstraint = itemsContainerView.topAnchor .constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        titleBottomConstraint?.isActive = true
    }
    /// config itemsContainerView's JYFilterItemView list
    private func configItemsContainerView(){
        creatItems()
        configItems()
    }
    /// 创建
    private func creatItems(){
        guard let data = self.data else {
            return
        }
        //清空&创建&赋值
        itemViewList.forEach { $0.removeFromSuperview() }
        itemViewList.removeAll()
        for index in 0..<data.itemList.count{
            let item = JYFilterItemView.init(data: data.itemList[index], style: style.itemViewStyle)
            item.tag = index
            item.delegate = self
            self.itemsContainerView.addSubview(item)
            self.itemViewList.append(item)
        }
    }
    /// 布局
    private func configItems(){
        guard let data = self.data, itemViewList.count > 0, style.layoutStyle.itemColumns >= 1 else {
            return
        }
        let columns = style.layoutStyle.itemColumns
        let totalCount = data.itemList.count
        let rows = (totalCount / columns) + (totalCount % columns == 0 ? 0 : 1)
        let itemHeight = style.layoutStyle.itemHeight
        let itemXSpacing = style.layoutStyle.itemXSpacing
        let itemYSpacing = style.layoutStyle.itemYSpacing
        // 计算item width 与 整个视图的比例关系 , 相差间隙部分
        //|-1[][]-1| 水平方向空出间距, 视觉效果边框显示才OK.
        let horizontalMagin: CGFloat = 1
        let itemWidthScale = CGFloat(1) / CGFloat(columns)
        let spacingTotalWidth = CGFloat((columns - 1)) * itemXSpacing + horizontalMagin * 2
        let spacingItemGapWidth = spacingTotalWidth / CGFloat(columns)
        for i in 0..<rows{
            var lastItem: JYFilterItemView?
            for j in 0..<columns{
                let index = i * columns + j
                if index + 1 > totalCount{
                    return
                }
                let currentItem = itemViewList[index]
                // 每个的约束,追加identifier
                let topConstraint =  currentItem.topAnchor.constraint(equalTo: self.itemsContainerView.topAnchor, constant: (itemHeight + itemYSpacing) * CGFloat(i))
                topConstraint.identifier = "JYFilterItemView"
                topConstraint.isActive = true
                let widthConstraint = currentItem.widthAnchor.constraint(equalTo: self.itemsContainerView.widthAnchor, multiplier: itemWidthScale, constant:  -spacingItemGapWidth)
                widthConstraint.identifier = "JYFilterItemView"
                widthConstraint.isActive = true
                let heightConstraint = currentItem.heightAnchor.constraint(equalToConstant: itemHeight)
                heightConstraint.identifier = "JYFilterItemView"
                heightConstraint.isActive = true
                if lastItem == nil{
                    let leftConstraint =
                        currentItem.leftAnchor.constraint(equalTo: self.itemsContainerView.leftAnchor, constant: horizontalMagin)
                    leftConstraint.identifier = "JYFilterItemView"
                    leftConstraint.isActive = true
                }else{
                    let leftConstraint = currentItem.leftAnchor.constraint(equalTo: (lastItem?.rightAnchor)!, constant: itemXSpacing)
                    leftConstraint.identifier = "JYFilterItemView"
                    leftConstraint.isActive = true
                }
                // 最后一行
                if i == rows - 1{
                    let bottomConstraint = currentItem.bottomAnchor.constraint(equalTo: self.itemsContainerView.bottomAnchor, constant: 0)
                    bottomConstraint.identifier = "JYFilterItemView"
                    bottomConstraint.isActive = true
                }
                lastItem = currentItem
            }
        }
    }
}



