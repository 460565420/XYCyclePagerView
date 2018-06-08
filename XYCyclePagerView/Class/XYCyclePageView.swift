//
//  XYCyclePageView.swift
//  Property_switf
//
//  Created by xieqilin on 2018/6/8.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

import UIKit

protocol XYCyclePageDelegate {
    func didselectedIndex(_ index: Int);
}

class XYCyclePageView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let identifier = "PageCollectionViewCell"
    private let maxSection = 3
    private var timer: Timer?
    private var type: FlowLayoutType = .normal
    var delegate: XYCyclePageDelegate?
    var images = [String]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        images = ["邻里美厨","居家花艺","生鲜果蔬"]
        self.addSubview(collection)
        self.addSubview(pageControl)
        //默认滚动到中间的那一组section数据 不要动画
        collection.scrollToItem(at: IndexPath(item: 0, section: maxSection / 2), at: .left, animated: false)
        addTimer()
    }
    
    init(frame: CGRect, type: FlowLayoutType) {
        super.init(frame: frame)
        self.type = type
        images = ["邻里美厨","居家花艺","生鲜果蔬"]
        self.addSubview(collection)
        self.addSubview(pageControl)
        //默认滚动到中间的那一组section数据 不要动画
        collection.scrollToItem(at: IndexPath(item: 0, section: maxSection / 2), at: .left, animated: false)
        addTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        pageControl.snp.makeConstraints { (make) in
//            make.right.equalTo(self.snp.right).offset(-10)
//            make.bottom.equalTo(self.snp.bottom).offset(-10)
//        }
        pageControl.frame = CGRect.init(x: 10, y: self.frame.height - 20, width: 200, height: 20)
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return maxSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //每个section展示相同数据
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PageCollectionViewCell
        cell.imageView.image = UIImage.init(named: images[indexPath.item])
        return cell
    }
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        if (delegate != nil) {
            delegate?.didselectedIndex(indexPath.item)
        }
    }
    
    //在这个方法中算出当前页数 下标
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + (collection.bounds.width) * 0.5) / (collection.bounds.width))
        let currentPage = page % images.count
        pageControl.currentPage = currentPage
    }
    
    //在开始拖拽的时候移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    //结束拖拽的时候重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    //手动滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collection.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 1), at: .left, animated: false)
    }
    
    //MARK: privite
    private func addTimer() {
        timer = Timer(timeInterval: 2, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    @objc private func nextImage() {
        //获取当前indexPath
        let currentIndexPath = collection.indexPathsForVisibleItems.last!
        //获取中间那一组的indexPath
        let middleIndexPath = IndexPath(item: currentIndexPath.item, section: 1)
        //滚动到中间那一组
        collection.scrollToItem(at: middleIndexPath, at: .left, animated: false)
        
        var nextItem = middleIndexPath.item + 1
        var nextSection = middleIndexPath.section
        if nextItem == images.count {
            nextItem = 0
            nextSection += 1
        }
        collection.scrollToItem(at: IndexPath(item: nextItem, section: nextSection), at: .left, animated: true)
    }
    
    //MARK: getter
    lazy var collection: UICollectionView = {
        let xyLayout = XYCyclePageFlowLayout.init(self.type)
        xyLayout.itemSize = CGSize.init(width: self.frame.width, height: 200)
        let collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: xyLayout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        //设置scrollview停顿的速度
//        collection.decelerationRate = 0.8
        collection.register(PageCollectionViewCell.classForCoder(), forCellWithReuseIdentifier:identifier)
        return collection
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        return pageControl
    }()
}
