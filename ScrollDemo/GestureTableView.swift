//
//  GestureTableView.swift
//  ScrollDemo
//
//  Created by Dylan Chen on 2019/10/8.
//  Copyright © 2019 ScrollDemo. All rights reserved.
//

import UIKit

class GestureTableView: UITableView, UIGestureRecognizerDelegate {

    var isCanScroll: Bool = false
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
