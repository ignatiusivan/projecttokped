//
//  FilterShopTypeVC.swift
//  projecttokped
//
//  Created by mac on 15/06/19.
//  Copyright © 2019 ivan. All rights reserved.
//

import UIKit

class FilterShopTypeVC: UIViewController {

    @IBOutlet weak var filterShopTypeTableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    var filterProduct = FilterProduct()
    var shopTypeArray = [ShopType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shop Type"

        filterShopTypeTableView.delegate = self
        filterShopTypeTableView.dataSource = self
        
        initBackButton()
        
        initResetButton()
        
        initShopType()
        
        filterShopTypeTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: filterShopTypeTableView.frame.size.width, height: 1))
    }
    
    func initBackButton(){
        navigationItem.hidesBackButton = true
        let BackButton = UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonPressed))
        BackButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = BackButton
    }
    
    func initResetButton(){
        let resetButton = UIBarButtonItem(title: "Reset", style: UIBarButtonItem.Style.plain, target: self, action: #selector(resetButtonPressed))
        resetButton.tintColor = UIColor.init(red: 58/255, green: 178/255, blue: 93/255, alpha: 1)
        navigationItem.rightBarButtonItem = resetButton
    }
    
    func initShopType(){
        var tempShopType = ShopType()
        
        tempShopType.id = 1
        tempShopType.name = "Gold Merchant"
        
        shopTypeArray.append(tempShopType)
        
        tempShopType = ShopType()
        
        tempShopType.id = 2
        tempShopType.name = "Official Store"
        
        shopTypeArray.append(tempShopType)
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func resetButtonPressed(){
        filterProduct.shopType.removeAll()
        filterShopTypeTableView.reloadData()
    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is FilterProductVC {
                let destination = vc as! FilterProductVC
                destination.filterProduct = filterProduct
                destination.isReload = true
                
                _ = self.navigationController?.popToViewController(destination, animated: true)
                break
            }
        }
    }
    
}

extension FilterShopTypeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilterShopTypeCell
        
        cell.tickView.layer.borderWidth = 1
        cell.tickView.layer.borderColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        
        if let _ = filterProduct.shopType.index(where: {$0.id == shopTypeArray[indexPath.row].id}) {
            cell.tickImageView.isHidden = false
        }
        else{
            cell.tickImageView.isHidden = true
        }
        
        cell.name.text = shopTypeArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = filterProduct.shopType.index(where: {$0.id == shopTypeArray[indexPath.row].id}) {
            filterProduct.shopType.remove(at: index)
        }
        else{
            filterProduct.shopType.append(shopTypeArray[indexPath.row])
        }
        
        filterShopTypeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
