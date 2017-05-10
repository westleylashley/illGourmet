//
//  FitPageVC.swift
//  fits
//
//  Created by Vibes on 3/20/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

class FitPageVC: UIPageViewController {
    
    var look : Look?
    var products : [Product]?
    
    var selectedPageIndex  = 0
    
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.width - 70, y: 0.684 * UIScreen.main.bounds.height, width: 30, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        setViewControllers([viewControllerAtIndex(0)], direction: .forward, animated: true, completion: nil)
        
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init() {
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewControllerAtIndex (_ index:Int) -> UIViewController {
        
        if index == 0 {
        let lookVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LookVC") as! LookVC
        lookVC.setValues(look : look!, index : index)
        selectedPageIndex = index
        return lookVC
            
        } else {
            
            let productVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
            productVC.setValues(product : products![index-1], index : index)
            selectedPageIndex = index
            return productVC
        }
    }


}

extension FitPageVC : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = 0
        
        if let VC = viewController as? LookVC {
            
            index = VC.index
            
        } else if let VC = viewController as? ProductVC {
            
            index = VC.index

        }

        self.pageControl.currentPage = index

        if index == 0 {
            
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = 0
        
        if let VC = viewController as? LookVC {
            
            index = VC.index
            
        } else if let VC = viewController as? ProductVC {
            
            index = VC.index
            
        }

        self.pageControl.currentPage = index

        index += 1

        if index == (products?.count)! + 1 {
            return nil
        }
        
        return viewControllerAtIndex(index)
                
    }

}
