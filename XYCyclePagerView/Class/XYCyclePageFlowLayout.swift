//
//  XYCyclePageFlowLayout.swift
//  Property_switf
//
//  Created by xieqilin on 2018/6/8.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

import UIKit

enum FlowLayoutType {
    case normal
    case linear
    case angle
}

class XYCyclePageFlowLayout: UICollectionViewFlowLayout {
    var flowType = FlowLayoutType.normal
    
    lazy var inset: CGFloat = {
        return (self.collectionView?.bounds.width ?? 0) * 0.5 - self.itemSize.width * 0.5
    }()
    
    override init() {
        super.init()
        //设置滚动方向
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
    }
    
    init(_ type: FlowLayoutType) {
        super.init()
        //设置滚动方向
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.flowType = type
    }
    
    //布局准备
    override func prepare() {
        //设置边距(让第一张图片与最后一张图片出现在最中央)
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     返回true只要显示的边界发生改变就重新布局:(默认是false)
     内部会重新调用prepareLayout和调用layoutAttributesForElementsInRect方法获得部分cell的布局属性
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /**
     用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //取出rect范围内所有的UICollectionViewLayoutAttributes
        var array: Array = [UICollectionViewLayoutAttributes]()
        //解决Logging only once for UICollectionViewFlowLayout cache mismatched frame
        //拷贝一次用作修改
        for attributes in super.layoutAttributesForElements(in: rect)! {
            let itemAttributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
            array.append(itemAttributesCopy)
        }
        //collectionview能在屏幕的显示区域
        let visiableRect = CGRect.init(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        
        //动画效果计算
        let maxCenterMargin = self.collectionView!.bounds.width * 0.5 + self.itemSize.width * 0.5;
        //获得collectionView中央的X值(即显示在屏幕中央的X)
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5;
        if flowType == .linear {
            for attributes in array {
                //如果不在屏幕上，直接跳过
                if !visiableRect.intersects(attributes.frame) {continue}
                let scale = 1 + (0.01 - abs(centerX - attributes.center.x) / maxCenterMargin)
                attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        } else if flowType == .angle {
            for attributes in array {
                //如果不在屏幕上，直接跳过
                if !visiableRect.intersects(attributes.frame) {continue}
                let scale = 1 + (0.1 - abs(centerX - attributes.center.x) / maxCenterMargin)
                attributes.transform = CGAffineTransform(rotationAngle: 10).concatenating(CGAffineTransform(scaleX: scale, y: scale))
            }
        } else if flowType == .normal {
            
        }
        return array
    }
    
    /**
     用来设置collectionView停止滚动那一刻的位置  
     - parameter proposedContentOffset: 原本collectionView停止滚动那一刻的位置
     - parameter velocity:              滚动速度
     - returns: 最终停留的位置
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //实现这个方法的目的是：当停止滑动，时刻有一张图片是位于屏幕最中央的。
        let lastRect = CGRect.init(x: proposedContentOffset.x, y: proposedContentOffset.y, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height)
        //获得collectionVIew中央的X值(即显示在屏幕中央的X)
        let centerX = proposedContentOffset.x + self.collectionView!.frame.width * 0.5;
        //这个范围内所有的属性
        let array = self.layoutAttributesForElements(in: lastRect)
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for attri in array! {
            if abs(attri.center.x - centerX) < abs(adjustOffsetX) {
                adjustOffsetX = attri.center.x - centerX;
            }
        }
        
        return CGPoint.init(x: proposedContentOffset.x + adjustOffsetX, y: proposedContentOffset.y)
    }
}
