//
//  KisiGuncelleViewController.swift
//  KisilerUygulamasi
//
//  Created by Ali Osman DURMAZ on 21.03.2022.
//

import UIKit
import Alamofire

class KisiGuncelleViewController: UIViewController {
    
    @IBOutlet weak var kisiAdTextField: UITextField!
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    var kisi: Kisiler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let k = kisi {
            kisiAdTextField.text = k.kisi_ad;
            kisiTelTextField.text = k.kisi_tel;
            
        }
    }
    
    @IBAction func butonGuncelle(_ sender: Any) {
        
        if let k = kisi , let ad = kisiAdTextField.text , let tel = kisiTelTextField.text {
            
            if let k_id = Int(k.kisiId!) {
                
                kisiGuncelle(kisi_id: k_id, kisi_ad: ad, kisi_tel: tel)
            }
        }
    }
    
    func kisiGuncelle(kisi_id:Int,kisi_ad:String,kisi_tel:String) {
        
        let parametre:Parameters = ["kisi_id":kisi_id,"kisi_ad":kisi_ad,"kisi_tel":kisi_tel];
        
        Alamofire.request("http://aodurmaz.xyz/kisiler/update_kisiler.php",method: .post,parameters: parametre).responseJSON {
            response in
            
            if let data = response.data {
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(json);
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    
}
