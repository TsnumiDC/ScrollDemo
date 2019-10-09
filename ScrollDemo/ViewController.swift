//
//  ViewController.swift
//  ScrollDemo
//
//  Created by Dylan Chen on 2019/9/30.
//  Copyright © 2019 ScrollDemo. All rights reserved.
//

import UIKit

extension Notification.Name {
    /// 两个scrollview联动结构
    static let subTableViewScrollVisible = Notification.Name("subTableViewScrollVisible")
    static let outterTableViewScrollVisible = Notification.Name("outterTableViewScrollVisible")
}

class ViewController: UIViewController {

    enum Constraint {
        static let headerViewHeight: CGFloat = 100.0
        static let sectionHeaderHeight: CGFloat = 44
    }
    
    private let tableView = UITableView()
    private var canScroll = true
    private let segment = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        tableView.register(ScrollTableviewCell.classForCoder(), forCellReuseIdentifier: "ScrollTableviewCell")
        tableView.dataSource = self
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        view.addSubview(tableView)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: Constraint.headerViewHeight))
        headerView.backgroundColor = UIColor.red
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(forName: .outterTableViewScrollVisible, object: nil, queue: OperationQueue.current) { [weak self] _ in
            self?.canScroll = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var bounds = view.bounds
        bounds.origin.y = view.safeAreaInsets.top
        bounds.size.height = bounds.size.height - view.safeAreaInsets.top
        tableView.frame = bounds
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollTableviewCell") else {
            return ScrollTableviewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView()
        sectionHeaderView.backgroundColor = UIColor.yellow
        var bounds = view.bounds
        bounds.size.height = Constraint.sectionHeaderHeight
        sectionHeaderView.frame = bounds
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constraint.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = tableView.bounds.size.height
        height = height - Constraint.sectionHeaderHeight
        return height
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        let leading = Constraint.headerViewHeight
        if contentOffset.y > leading {
            scrollView.contentOffset = CGPoint(x: 0.0, y: leading)
            if self.canScroll {
                self.canScroll = false
                NotificationCenter.default.post(name: .subTableViewScrollVisible, object: nil)
            }
        } else {
            if !self.canScroll {
                scrollView.contentOffset = CGPoint(x: 0.0, y: leading)
            }
        }
    }
}

