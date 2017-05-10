import UIKit
import Eureka
import AVFoundation
import Firebase

class AddProductVCViewController: FormViewController {

    @IBOutlet weak var saveBtn: UIButton!
    
    var collectionView: UICollectionView!
    
    var productData: ProductData!
    var lookData: LookData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(lookData.celebrityID)
        
        
//MARK: SETUP NAVBAR
        
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Add a Product")
        let cancelbtn = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.done, target: nil, action: #selector(cancelPress))
        navItem.leftBarButtonItem = cancelbtn
        navItem.leftBarButtonItem?.tintColor = illOrange
        navBar.setItems([navItem], animated: false)
        
        
//MARK: SETUP IMAGE ROWS
        
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        
        
//MARK: CREATE FORM
        
        
        form +++ Section("")
            <<< TextRow(){ row in
                row.title = "Brand Name"
                row.tag = "brand"
                row.value = productData.brandName
//                if let productData.brandName.characters.count > 2 {
//                    row.value = productData.brandName
//                }
            }
            <<< TextRow(){
                $0.title = "Product Name"
                $0.tag = "productName"
                $0.value = productData.brandName
            }
            
//            +++ Section() { section in
//                var header = HeaderFooterView<TVC>(.nibFile(name: "TVC", bundle: nil)) //<MyHeaderNibFile>(.nibFile(name: "TVC", bundle: nil))
//                
//                // Will be called every time the header appears on screen
//                header.onSetupView = { view, _ in
//                    for i in view.subviews[0].subviews {
//                        if let collectionView = i as? UICollectionView {
//                            self.collectionView = collectionView
//                        }
//                    }
//                    // Commonly used to setup texts inside the view
//                    // Don't change the view hierarchy or size here!
//                }
//                section.header = header
//            }

            
            <<< ImageRow() {
                $0.title = "Image"
                $0.tag = "productImage"
                $0.value = productData.image
            }
            
            <<< DecimalRow() {
                $0.useFormatterDuringInput = true
                $0.title = "Price"
                $0.value = productData.price
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                $0.tag = "price"
            }
            <<< TextRow(){
                $0.title = "Tags"
                $0.placeholder = "Seperated by Commas"
                $0.tag = "tags"
                $0.value = productData.tags
            }
        
        
//MARK: ADDITIONAL VIEW SETUP
        
        
        view.bringSubview(toFront: saveBtn)
        tableView?.frame = CGRect(x: 0, y: 65, width: view.frame.width, height: (view.frame.height - 65))
    }
    
    
    @IBAction func cancelPress() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePress(_ sender: Any) {

        
//MARK: GET ROW VALUES
        
        
        self.productData.productID = UUID().uuidString
        lookData.productIDs += [self.productData.productID]
        
        let brand: TextRow? = self.form.rowBy(tag: "brand")
        self.productData.brandName = (brand?.value)!
        
        let product: TextRow? = self.form.rowBy(tag: "productName")
        self.productData.productName = (product?.value)!
        
        let image: ImageRow? = self.form.rowBy(tag: "productImage")
        self.productData.image = image?.value?.resized(toWidth: 700)
        
        let price: DecimalRow? = self.form.rowBy(tag: "price")
        self.productData.price = (price?.value)!
        
        let tag: TextRow? = self.form.rowBy(tag: "tags")
        self.productData.tags = (tag?.value)!

        
//MARK: CREATE IMAGE PATH
        
        
        self.productData.imageURL = "gs://ill-gourmet.appspot.com/" + FIRAuth.auth()!.currentUser!.uid + "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"

        
//MARK: INCREMENT PRODUCT ARRAY
        
        
        lookData.products += [productData]
        
        
//MARK: IMAGE TO BINARY
        
        
        let data = UIImageJPEGRepresentation(self.productData.image!, 0.8)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        lookData.userID = User.shared.username
        
        
//MARK: DEFINE OBJECTS
        
        
        let look = ["\(lookData.lookID)": ["celebrityID": lookData.celebrityID, "imageURL": lookData.imageURL, "productIDs": lookData.productIDs, "description": lookData.description, "postedByUserID": lookData.userID, "approved": true]]
        
        let productReady = ["\(self.productData.productID)": [  "brandName": self.productData.brandName, "productName": self.productData.productName, "price": self.productData.price, "imageURL": self.productData.imageURL, "tag": self.productData.tags, "lookID": self.lookData.lookID, "productID": "\(self.productData.productID)"]]
        
        
//MARK: UPDATE FIREBASE DATABASE
        
        
        Firebase.shared.ref.child("look").updateChildValues(look)
        Firebase.shared.ref.child("product").updateChildValues(productReady)
        
        
//MARK: UPDATE FIREBASE STORAGE
        
        
        Firebase.shared.storageRef.child(productData.imageURL).put(data!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print ("error uploading: \(error)")
                return
            }
        }
        performSegue(withIdentifier: "unwindFromProductToLook", sender: nil)
    }
    
}


//MARK: SET IMAGE 700px


extension UIImage {
    func imageWithImage(scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}


//MARK: FORMAT CURRENCY ROW


class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
    }
}
