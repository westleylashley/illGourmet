//
//  ViewController.swift
//  fits
//
//  Created by Vibes on 3/17/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import Interstellar
import EZSwipeController
import Firebase




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    
    var pageViewControllers = [FitPageVC]()
    
    private let main = OperationQueue.main
    
    private let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 8
        return operationQueue
    }()
    
    @IBOutlet weak var table: UITableView!
    
    var looks : [Look] = []
    
    override func viewDidLoad() {
        
        
        
        table.rowHeight = 0.88 * view.frame.size.height
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Firebase.shared.getLooks { looks in
            
            let newLooks = looks.filter({ (look) -> Bool in
                return !self.looks.contains(look)
            })
            
            self.looks.append(contentsOf: newLooks)
            
            
//            self.looks = looks
            
            for look in newLooks {
                
                let fitPageVC = FitPageVC()
                
                fitPageVC.look = look
                
                Firebase.shared.getProducts(productIDs: look.productIDs) { products in
                    fitPageVC.products = products
                    fitPageVC.pageControl.numberOfPages = products.count + 1
                    
                }
                
                
                self.pageViewControllers.append(fitPageVC)
                print(self.pageViewControllers.count)
                
//                DispatchQueue.main.async {
//                    self.table.reloadData()
//                }
                
            }
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    
    func handle(error: Error) {
        print("Uh oh, something went wrong while fetchig data from Contentful")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageViewControllers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fitCell", for: indexPath)
        cell.backgroundColor = UIColor.green
        let pageViewController = pageViewControllers[indexPath.row]
        addChildViewController(pageViewController)
        pageViewController.view.frame = cell.contentView.bounds
        pageViewController.didMove(toParentViewController: self)
        cell.contentView.addSubview(pageViewController.view)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let pageViewController = pageViewControllers[indexPath.row]
        pageViewController.removeFromParentViewController()
        pageViewController.view.removeFromSuperview()
        
    }
    
    @IBAction func addLookPress(_ sender: Any) {
        let secondStoryboard = UIStoryboard(name: "AddLook", bundle: nil)
        guard let viewController = secondStoryboard.instantiateInitialViewController() else { return }
        present(viewController, animated: true, completion: nil)
    }
    
    
    
    
}


public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
