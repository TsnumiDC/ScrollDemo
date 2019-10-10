# ScrollDemo

[Github Demo 地址](https://github.com/TsnumiDC/ScrollDemo)
1. 业务场景各种首页经常会有上下滚动,左右滚动的场景,如以下效果

![应用场景](https://github.com/TsnumiDC/ScrollDemo/blob/master/showImages/0.GIF?raw=true "应用场景")

2. 实现效果

![实现效果](https://github.com/TsnumiDC/ScrollDemo/blob/master/showImages/1.GIF?raw=true "实现效果")

3. 层级结构

![结构介绍](https://github.com/TsnumiDC/ScrollDemo/blob/master/showImages/struct.png?raw=true "结构介绍")

4. 滚动逻辑

![逻辑介绍](https://github.com/TsnumiDC/ScrollDemo/blob/master/showImages/mind.png?raw=true "逻辑介绍")

5. 代码实现中的一些细节处理

让内层的tableView滑动手势可以传出去,这时候需要一个继承UITableView,以下是`GestureTableView.swift`文件
```
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

```

内层防止左右滚动的时候可以上下滚动
```
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
```




