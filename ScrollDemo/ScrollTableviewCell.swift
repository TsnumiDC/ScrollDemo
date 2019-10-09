//
//  ScrollTableviewCell.swift
//  ScrollDemo
//
//  Created by Dylan Chen on 2019/10/8.
//  Copyright © 2019 ScrollDemo. All rights reserved.
//

import UIKit

class ScrollTableviewCell: UITableViewCell {
    
    private let containerScrollView = UIScrollView()
    private let leftTableView = GestureTableView()
    private let rightTableView = GestureTableView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        rightTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        leftTableView.dataSource = self
        rightTableView.dataSource = self
        leftTableView.delegate = self
        rightTableView.delegate = self
        leftTableView.bounces = true
        rightTableView.bounces = true

        addSubview(containerScrollView)
        containerScrollView.isPagingEnabled = true
        containerScrollView.addSubview(leftTableView)
        containerScrollView.addSubview(rightTableView)
        containerScrollView.bounces = false
        
        containerScrollView.delegate = self
        
        leftTableView.automaticallyAdjustsScrollIndicatorInsets = false
        rightTableView.automaticallyAdjustsScrollIndicatorInsets = false
        containerScrollView.automaticallyAdjustsScrollIndicatorInsets = false

        NotificationCenter.default.addObserver(forName: .subTableViewScrollVisible, object: nil, queue: OperationQueue.current) {  [weak self] _ in
            guard let self = self else {
                return
            }
            self.leftTableView.isCanScroll = true
            self.rightTableView.isCanScroll = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var bounds = self.bounds
        containerScrollView.frame = bounds
        leftTableView.frame = bounds
        
        bounds.origin.x = bounds.size.width
        rightTableView.frame = bounds
        containerScrollView.contentSize = CGSize(width: bounds.size.width * 2, height: bounds.size.height)
    }
}

extension ScrollTableviewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "第\(indexPath.row)列"
        return cell
    }
}

extension ScrollTableviewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == leftTableView {
            if leftTableView.isCanScroll {
                if leftTableView.contentOffset.y <= 0 {
                    leftTableView.isCanScroll = false
                    rightTableView.isCanScroll = false

                    NotificationCenter.default.post(name: .outterTableViewScrollVisible, object: nil)
                    leftTableView.contentOffset = CGPoint(x: 0, y: 0)
                    rightTableView.contentOffset.y = 0
                }
            } else {
                leftTableView.contentOffset = CGPoint(x: 0, y: 0)
            }
            return
        }
        
        if scrollView == rightTableView {
            if rightTableView.isCanScroll {
                if rightTableView.contentOffset.y <= 0 {
                    rightTableView.isCanScroll = false
                    leftTableView.isCanScroll = false
                    NotificationCenter.default.post(name: .outterTableViewScrollVisible, object: nil)
                    rightTableView.contentOffset = CGPoint(x: 0, y: 0)
                    leftTableView.contentOffset.y = 0
                }
            } else {
                rightTableView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == containerScrollView {
            leftTableView.isScrollEnabled = false
            rightTableView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == containerScrollView {
            leftTableView.isScrollEnabled = true
            rightTableView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == containerScrollView {
            if !decelerate {
                leftTableView.isScrollEnabled = true
                rightTableView.isScrollEnabled = true
            }
        }
    }
}
