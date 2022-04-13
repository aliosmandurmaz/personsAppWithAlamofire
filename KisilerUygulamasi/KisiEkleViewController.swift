//
//  KisiEkleViewController.swift
//  KisilerUygulamasi
//
//  Created by Ali Osman DURMAZ on 21.03.2022.
//

import UIKit
import Alamofire

class KisiEkleViewController: UIViewController {

  
    @IBOutlet weak var kisiAdTextField: UITextField!;
    
    
    @IBOutlet weak var kisiTelTextField: UITextField!;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func butonKisiEkle(_ sender: Any) {
        
        if let ad = kisiAdTextField.text , let tel = kisiTelTextField.text {
            
            kisiEkle(kisi_ad: ad, kisi_tel: tel);
            
        }
        
    }
    
    func kisiEkle(kisi_ad:String,kisi_tel:String) {
        
        let parametre:Parameters = ["kisi_ad":kisi_ad,"kisi_tel":kisi_tel];
        
        Alamofire.request("http://aodurmaz.xyz/kisiler/insert_kisiler.php",method: .post,parameters: parametre).responseJSON {
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
