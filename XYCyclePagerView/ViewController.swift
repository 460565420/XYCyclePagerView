//
//  ViewController.swift
//  XYCyclePagerView
//
//  Created by xieqilin on 2018/6/8.
//  Copyright © 2018年 xieqilin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(pageView)
        view.addSubview(pageView1)
        
    }

    lazy var pageView: XYCyclePageView = {
        let pageView = XYCyclePageView.init(frame: CGRect.init(x: 0, y: 100, width: view.frame.width, height: 200), type:.linear)
        pageView.delegate = self
        return pageView
    }()
    
    lazy var pageView1: XYCyclePageView = {
        let pageView1 = XYCyclePageView.init(frame: CGRect.init(x: 0, y: 400, width: view.frame.width, height: 200), type:.angle)
        pageView.delegate = self
        return pageView1
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: XYCyclePageDelegate {
    func didselectedIndex(_ index: Int) {
        print("\(index)")
    }
}

