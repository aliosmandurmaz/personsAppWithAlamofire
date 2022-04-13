//
//  KisiDetayViewController.swift
//  KisilerUygulamasi
//
//  Created by Ali Osman DURMAZ on 21.03.2022.
//

import UIKit

class KisiDetayViewController: UIViewController {

    
    @IBOutlet weak var labelKisiAd: UILabel!;
    
    
    @IBOutlet weak var labelKisiTel: UILabel!;
    
    var kisi:Kisiler?;
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if let k = kisi {
            
            labelKisiAd.text = k.kisi_ad;
            labelKisiTel.text = k.kisi_tel;
            
        }
        
    }
    

    

}
