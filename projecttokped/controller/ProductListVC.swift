//
//  ProductListVC.swift
//  projecttokped
//
//  Created by Mac on 13/06/19.
//  Copyright © 2019 ivan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ProductListVC: UIViewController {

    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    var productArray = [Product]()
    var filterProduct = FilterProduct()
    
    var hasNextPage = false
    var isReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self

        title = "Search"
        
        initFilterProduct()
        
        loadProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isReload == true{
            isReload = false
            productArray.removeAll()
            productListCollectionView.reloadData()
            filterProduct.start = "0"
            loadProduct()
        }
    }
    
    func initFilterProduct(){
        filterProduct.q = "samsung"
        filterProduct.pmin = "100"
        filterProduct.pmax = "10000000"
        filterProduct.wholesale = false
        filterProduct.official = false
        filterProduct.fshop = "2"
        filterProduct.start = "0"
        filterProduct.rows = "10"
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: "filterProduct") as! FilterProductVC
        
        dashboard.filterProduct = filterProduct
        
        self.navigationController?.pushViewController(dashboard, animated: true)
    }
    
    func loadProduct(){
        let url = "https://ace.tokopedia.com/search/v2.5/product?q=\(filterProduct.q)&pmin=\(filterProduct.pmin)&pmax=\(filterProduct.pmax)&wholesale=\(filterProduct.wholesale)&official=\(filterProduct.official)&fshop=\(filterProduct.fshop)&start=\(filterProduct.start)&rows=\(filterProduct.rows)"
        
        Alamofire.request(url, method: .get).responseJSON{
            response in
            
            if response.result.isSuccess{
                let tempJSON: JSON = JSON(response.result.value!)
                _ = self.parseLoadProductJSON(json: tempJSON)
                
                DispatchQueue.main.async {
                    self.productListCollectionView?.reloadData()
                }
            }
            else{
                let alertController = UIAlertController(title: "Oops, something went wrong. try again later!", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    func parseLoadProductJSON(json:JSON)->[Product]{
        if json["status"]["error_code"].intValue == 0{
            let data = json["data"]
            
            if data.count > 0{
                for index in 0 ... data.count-1{
                    
                    let tempProduct = Product()
                    
                    tempProduct.id = data[index]["id"].intValue
                    tempProduct.image_uri = data[index]["image_uri"].stringValue
                    tempProduct.name = data[index]["name"].stringValue
                    tempProduct.price = data[index]["price"].stringValue
                  
                    productArray.append(tempProduct)
                    
                }
                if json["header"]["total_data"].intValue > productArray.count{
                    hasNextPage = true
                }
                else{
                    hasNextPage = false
                }
            }
        }
        else{
            let alertController = UIAlertController(title: "\(json["status"]["message"].stringValue)", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        return productArray
    }
    
}

extension ProductListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductListCell
        
        let pic = URL(string: productArray[indexPath.row].image_uri)
        cell.productImageView.sd_setImage(with: pic, placeholderImage: UIImage(named: "default.jpg"))
        
        cell.productNameLabel.text = productArray[indexPath.row].name
        
        cell.productPriceLabel.text = productArray[indexPath.row].price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (productListCollectionView.frame.width - 5) / 2
        let height = (productListCollectionView.frame.height - 5) / 2
        
        return CGSize(width: width,height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = productArray.count - 1
        
        if indexPath.row == lastElement {
            if hasNextPage == true {
                filterProduct.start = "\(Int(filterProduct.start)! + Int(filterProduct.rows)!)"
                loadProduct()
            }
        }
    }
    
}

