//
//  FilterProductVC.swift
//  projecttokped
//
//  Created by Mac on 13/06/19.
//  Copyright © 2019 ivan. All rights reserved.
//

import UIKit
import MultiSlider
import MiniLayout

class FilterProductVC: UIViewController {

    @IBOutlet weak var sliderView: UIView!
    
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var maximumPriceLabel: UILabel!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    @IBOutlet weak var shopTypeCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    
    var filterProduct = FilterProduct()
    let horizontalMultiSlider = MultiSlider()
    var isReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Filter"
        
        shopTypeCollectionView.delegate = self
        shopTypeCollectionView.dataSource = self
        
        initBackButton()
        
        initResetButton()
        
        initFilter()
        
        initSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isReload == true{
            isReload = false
            shopTypeCollectionView.reloadData()
        }
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
    
    func initFilter(){
        minimumPriceLabel.text = "Rp \(formatPrice(price: Int(filterProduct.pmin) ?? 100))"
        maximumPriceLabel.text = "Rp \(formatPrice(price: Int(filterProduct.pmax) ?? 10000000))"
        wholeSaleSwitch.isOn = filterProduct.wholesale
    }
    
    func initSlider(){
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.minimumValue = 100
        horizontalMultiSlider.maximumValue = 10000000
        horizontalMultiSlider.outerTrackColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
        horizontalMultiSlider.value = [CGFloat(Int(filterProduct.pmin) ?? Int(horizontalMultiSlider.minimumValue)), CGFloat(Int(filterProduct.pmax) ?? Int(horizontalMultiSlider.maximumValue))]
        horizontalMultiSlider.tintColor = UIColor.init(red: 58/255, green: 178/255, blue: 93/255, alpha: 1)
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.snapStepSize = 100
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        sliderView.addConstrainedSubview(horizontalMultiSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
        sliderView.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }
    
    func formatPrice(price: Int)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        var formattedPrice = numberFormatter.string(from: NSNumber(value:price))!
        formattedPrice = formattedPrice.replacingOccurrences(of: ",", with: ".")
    
        return formattedPrice
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func resetButtonPressed(){horizontalMultiSlider.value = [horizontalMultiSlider.minimumValue, horizontalMultiSlider.maximumValue]
        
        minimumPriceLabel.text = "Rp \(formatPrice(price: Int(horizontalMultiSlider.minimumValue)))"
        maximumPriceLabel.text = "Rp \(formatPrice(price: Int(horizontalMultiSlider.maximumValue)))"
        
        filterProduct.pmin = "\(Int(horizontalMultiSlider.minimumValue))"
        filterProduct.pmax = "\(Int(horizontalMultiSlider.maximumValue))"
        
        wholeSaleSwitch.isOn = false
        
        filterProduct.wholesale = false
        
        filterProduct.shopType.removeAll()
        shopTypeCollectionView.reloadData()
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        minimumPriceLabel.text = "Rp \(formatPrice(price: Int(slider.value[0])))"
        maximumPriceLabel.text = "Rp \(formatPrice(price: Int(slider.value[1])))"
        
        filterProduct.pmin = "\(Int(slider.value[0]))"
        filterProduct.pmax = "\(Int(slider.value[1]))"
    }
    
    @IBAction func wholeSaleValueChanged(_ sender: UISwitch) {
        filterProduct.wholesale = wholeSaleSwitch.isOn
    }
    
    @IBAction func shopTypeButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: "filterShopType") as! FilterShopTypeVC
        
        dashboard.filterProduct = filterProduct
        
        self.navigationController?.pushViewController(dashboard, animated: true)
    }
    
    @IBAction func deleteShopTypeButtonPressed(_ sender: UIButton) {
        let index = sender.layer.value(forKey: "index") as! Int
        filterProduct.shopType.remove(at: index)
        shopTypeCollectionView.reloadData()
    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        if let _ = filterProduct.shopType.index(where: {$0.id == 1}) {
            filterProduct.fshop = "1"
        }
        else{
            filterProduct.fshop = "2"
        }
        
        if let _ = filterProduct.shopType.index(where: {$0.id == 2}) {
            filterProduct.official = true
        }
        else{
            filterProduct.official = false
        }
        
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is ProductListVC {
                let destination = vc as! ProductListVC
                destination.filterProduct = filterProduct
                destination.isReload = true
                
                _ = self.navigationController?.popToViewController(destination, animated: true)
                break
            }
        }
    }
    
    
    
}

extension FilterProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterProduct.shopType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShopTypeCell
        
        cell.background.layer.borderWidth = 1
        cell.background.layer.borderColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        cell.background.layer.cornerRadius = cell.deleteButton.frame.height / 2
        
        cell.name.text = filterProduct.shopType[indexPath.row].name
        
        cell.deleteButton.layer.borderWidth = 1
        cell.deleteButton.layer.borderColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        cell.deleteButton.layer.cornerRadius = cell.deleteButton.frame.height / 2
        cell.deleteButton.backgroundColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        cell.deleteButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (shopTypeCollectionView.frame.width - 10) / 2
        let height = CGFloat(40)

        return CGSize(width: width,height: height)
    }
}
