import UIKit
import AVFoundation


class LookVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var text: UILabel!
    
    var index = 0
    
    
    var look : Look?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
            look?.loadImage( completion: { (fetchedImage) in
                DispatchQueue.main.async {
                    self.imageView.image = fetchedImage
                }
            })
        
            self.name.text = look?.celebrityID
            self.text.text = look?.description
    
    }
    
    func setValues(look:Look, index : Int) {
        
        self.look = look
        self.index = index
    }
}

