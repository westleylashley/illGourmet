

import UIKit
import Interstellar
import EZSwipeController

//let SPACE_ID_UserProfileVC = "omalhxi5j9ol"
//let ACCESS_TOKEN_UserProfileVC = "53feb22a0f6700e51ae6308aaa809fba1c700e13a9f65d9395132d8b812f5a1f"

class UserProfileVC: UIViewController {

    @IBOutlet weak var myFavoritesView: UIView!
    @IBOutlet weak var myLooksView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emptyStateMyFavoritesImage: UIImageView!
    @IBOutlet weak var emptyStateMyFavoritesLabel: UILabel!
    @IBOutlet weak var emptyStateMyLooksImage: UIImageView!
    @IBOutlet weak var emptyStateMyLooksLabel: UILabel!
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            myFavoritesView.isHidden = false
            myLooksView.isHidden = true
//            emptyStateMyFavoritesImage.isHidden = false
//            emptyStateMyFavoritesLabel.isHidden = false
//            emptyStateMyLooksImage.isHidden = true
//            emptyStateMyLooksLabel.isHidden = true
        case 1:
            myFavoritesView.isHidden = true
            myLooksView.isHidden = false
//            emptyStateMyLooksImage.isHidden = false
//            emptyStateMyLooksLabel.isHidden = false
//            emptyStateMyFavoritesImage.isHidden = true
//            emptyStateMyFavoritesLabel.isHidden = true
        default: break
        }
    }
    
    
    

//    var stuff = ["something", "something else"]
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if stuff.count > 0 {
//            emptyStateTableView.isHidden = false
//            emptyStateImage.isHidden = true
//            //emptyStateTableView.reloadData()
//        } else {
//            emptyStateTableView.isHidden = true
//            emptyStateImage.isHidden = false
//        }
//    }

        override func viewDidLoad() {

    
        }

}
