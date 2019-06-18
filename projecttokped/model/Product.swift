//
//  Product.swift
//  projecttokped
//
//  Created by Mac on 13/06/19.
//  Copyright © 2019 ivan. All rights reserved.
//

import Foundation

class Product{
    
    var id = -1
    var name = ""
    var uri = ""
    var image_uri = ""
    var image_uri_700 = ""
    var price = ""
    var price_range = ""
    var category_breadcrumb = ""
    var condition = -1
    var preorder = -1
    var department_id = -1
    var rating = -1
    var is_featured = -1
    var count_review = -1
    var count_talk = -1
    var count_sold = -1
    var top_label = ""
    var bottom_label = ""
    var original_price = ""
    var discount_expired = ""
    var discount_start = ""
    var discount_percentage = -1
    var stock = -1
    var shop = Shop()
    var wholesalePriceArray = [WholesalePrice]()
    var labelsArray = [Labels]()
    var badgesArray = [Badges]()
    
}
