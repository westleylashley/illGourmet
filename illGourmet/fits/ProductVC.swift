import UIKit
import AVFoundation


class ProductVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func button(_ sender: UIButton) {
        
        self.button.setTitle("Added!", for: UIControlState.normal)
        Firebase.shared.addToCart(productID: (product?.productID)!)
        
    }
    
    var product : Product?
    
    var index = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.name.text = product?.brandName
        self.text.text = product?.productName
        self.button.setTitle("$ " + "\(product!.price)" + " - Add to Bag", for: UIControlState.normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        product?.loadImage( completion: { (fetchedImage) in
            DispatchQueue.main.async {
                self.imageView.image = fetchedImage
            }
        })
        
    }
    
    func setValues(product:Product, index : Int) {
        
        self.product = product
        self.index = index
        
        product.loadImage( completion: { (fetchedImage) in
            DispatchQueue.main.async {
                self.imageView.image = fetchedImage
            }
        })
    }
}

