

import UIKit

class TVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    

//Or should I put this in 
    @IBOutlet weak var productCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productCollection.register(UINib(nibName: "CVC", bundle: nil), forCellWithReuseIdentifier: "CVC")
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVC", for: indexPath) as? CVC
        cell?.productImage.image = #imageLiteral(resourceName: "illgourmet")
        return cell!
    }
   
    
}

