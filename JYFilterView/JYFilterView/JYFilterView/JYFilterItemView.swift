//
//  JYFilterItemView.swift
//  rts
//
//  Created by 裴雷 on 2019/1/24.
//  Copyright © 2019 张冬. All rights reserved.
//

import UIKit

/// 筛选子视图协议
public protocol JYFilterItemViewDelegate: class {
    /// 返回最新状态
    ///
    /// - view: self
    /// - Parameter currentState: 当前状态
    /// - Returns: 变化后的状态
    func getNextState(itemView: JYFilterItemView, currentState: JYFilterState) -> JYFilterState
}

/**
 *  筛选子视图
 */
public class JYFilterItemView: UIView {
    /// 代理
    public weak var delegate: JYFilterItemViewDelegate?
    /// 数据源
    private var data: JYFilterItemPrototcol?
    /// 状态
    private var currentStatus: JYFilterState = .normalState{
        didSet{
            configViewState()
        }
    }
    /// 样式
    private var style = JYFilterItemViewStyle()
    
    /// 渐变layer,默认水平方向渐变
    private lazy var gradiednt: CAGradientLayer = {
        let g = CAGradientLayer()
        g.startPoint = CGPoint(x: 0, y: 0.5)
        g.endPoint = CGPoint(x: 1, y: 0.5)
        return g
    }()
    /// 名称
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textField.textColor = UIColor.init(red: 255.0/255.0, green: 157.0/255.0, blue: 76.0/255.0, alpha: 1)
        textField.textAlignment = .center
        return textField
    }()
    
    /// 初始化
    public convenience init(data: JYFilterItemPrototcol, style: JYFilterItemViewStyle) {
        self.init()
        self.style = style
        self.data = data
        configData()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.insertSublayer(gradiednt, at: 0)
        nameTextField.delegate = self
        configInitializeLayout()
    }
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        gradiednt.frame = self.bounds
    }
}
// MARK: --- 页面数据交互
extension JYFilterItemView{
    
    /// 更新界面数据
    ///
    /// - Parameter data: 界面数据源
    public func updateViewData(_ data: JYFilterItemPrototcol){
        self.data = data
        configData()
    }
    
    /// 设置item的状态
    ///
    /// - Parameter status: 选择状态
    public func updateStatus(by status: JYFilterState) {
        self.currentStatus = status
    }
    
    /// 更新界面样式
    ///
    /// - Parameters:
    ///   - defaultStyle: 默认状态样式
    ///   - slectStyle: 选中状态样式
    public func updateViewStyle(_ style: JYFilterItemViewStyle){
        self.style = style
        configViewState()
    }
}

// MARK: ----UITextField delegate
extension JYFilterItemView: UITextFieldDelegate{
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let nextState = self.delegate?.getNextState(itemView: self, currentState: currentStatus) {
            /// 更新状态样式
            if nextState != self.currentStatus{
                self.currentStatus = nextState
                self.data?.state = self.currentStatus
            }
        }
        return false
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //结束编辑更新为默认状态
        let content = textField.text ?? ""
        self.data?.state = .normalState
        self.data?.name = content
        currentStatus = .normalState
    }
}

// MARK: --- 页面状态
extension JYFilterItemView{
    /// 更新数据
    ///
    /// - Parameter data: 数据源
    private func configData(){
        guard let data = self.data else {
            return
        }
        self.currentStatus = data.state
        nameTextField.text = data.name
    }
    /// 更新页面状态
    private func configViewState(){
        if self.currentStatus == .selectState{
            setStyle(style.selectedStyle)
        }else{
            setStyle(style.normalStyle)
        }
    }
    /// 更新样式
    ///
    /// - Parameter style: UI样式
    private func setStyle(_ style: JYFilterItemViewStateStyle){
        self.layer.cornerRadius = style.cornerRadius
        self.layer.borderWidth = style.borderWidth
        self.layer.borderColor = style.borderColor?.cgColor
        self.layer.masksToBounds = true
        var cgColorsArr: [CGColor] = []
        for item in style.backgroundColors{
            cgColorsArr.append(item.cgColor)
        }
        if cgColorsArr.count == 1 {
            cgColorsArr = cgColorsArr + cgColorsArr
        }else if cgColorsArr.count == 0{
            cgColorsArr = [UIColor.white.cgColor, UIColor.white.cgColor]
        }
        gradiednt.colors = cgColorsArr
        nameTextField.textColor = style.nameColor
        nameTextField.font = style.nameFont
    }
}
// MARK: - UI
extension JYFilterItemView{
    /// 初始化必须布局
    private func configInitializeLayout(){
        self.translatesAutoresizingMaskIntoConstraints = false
        let vd = ["nameTextField": nameTextField]
        self.addSubview(nameTextField)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[nameTextField]|", options: [], metrics: nil, views: vd))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameTextField]|", options: [], metrics: nil, views: vd))
    }
}

