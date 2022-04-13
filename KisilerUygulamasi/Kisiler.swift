//
//  Kisiler.swift
//  KisilerUygulamasi
//
//  Created by Ali Osman DURMAZ on 22.03.2022.
//

import Foundation

class Kisiler: Codable {
    
    var kisiId:String?;
    var kisi_ad:String?;
    var kisi_tel:String?
    
    init(kisi_id:String,kisi_ad:String,kisi_tel:String) {
        self.kisiId = kisi_id;
        self.kisi_ad = kisi_ad;
        self.kisi_tel = kisi_tel;
    }
    
    enum CodingKeys: String, CodingKey {
        case kisiId = "person_id"
        case kisi_tel
    }
    
}
