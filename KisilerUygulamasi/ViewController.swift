//
//  ViewController.swift
//  KisilerUygulamasi
//
//  Created by Ali Osman DURMAZ on 21.03.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!;
    
    
    @IBOutlet weak var kisilerTableView: UITableView!;
    
    var kisilerListe = [Kisiler]();
    
    var aramaYapiliyorMu = false;
    
    var aramaKelimesi:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        kisilerTableView.delegate = self;
        kisilerTableView.dataSource = self;
        
        searchBar.delegate = self;
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indeks = sender as? Int;
        
        if segue.identifier == "toDetay" {
            let gidilecekViewcontroller = segue.destination as! KisiDetayViewController;
            gidilecekViewcontroller.kisi = kisilerListe[indeks!];
        }
        
        if segue.identifier == "toGuncelle" {
            let gidilecekViewcontroller = segue.destination as! KisiGuncelleViewController;
            gidilecekViewcontroller.kisi = kisilerListe[indeks!];
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if aramaYapiliyorMu {
            aramaYap(aramaKelimesi: aramaKelimesi!)
        }else {
            tumKisilerAl();

        }
        
    }
    
    func tumKisilerAl() {
        
        Alamofire.request("http://aodurmaz.xyz/kisiler/tum_kisiler.php",method: .get).responseJSON {
            response in
            
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(KisiCevap.self, from: data);
                    
                    if let gelenKisiListesi = cevap.kisiler{
                        
                        self.kisilerListe = gelenKisiListesi;
                    
                    }else {
                        
                        self.kisilerListe = [Kisiler](); // else bloğu DB'de hiç veri kalmadığında table                                   view arayüzünde de hiç verinin kalmadığını gösterir
                    }
                    
                    DispatchQueue.main.async {
                        self.kisilerTableView.reloadData();
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }

    func aramaYap(aramaKelimesi:String) {
        
        let parametre:Parameters = ["kisi_ad":aramaKelimesi];
        
        Alamofire.request("http://aodurmaz.xyz/kisiler/tum_kisiler_arama.php",method: .post,parameters: parametre).responseJSON {
            response in
            
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(KisiCevap.self, from: data);
                    
                    if let gelenKisiListesi = cevap.kisiler{
                        self.kisilerListe = gelenKisiListesi;
                    }else {
                        
                        self.kisilerListe = [Kisiler](); // else bloğu DB'de hiç veri kalmadığında table                                   view arayüzünde de hiç verinin kalmadığını gösterir
                    }
                    
                    DispatchQueue.main.async {
                        self.kisilerTableView.reloadData();
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    func kisiSil(kisi_id:Int) {
        
        let parametre:Parameters = ["kisi_id":kisi_id];
        
        Alamofire.request("http://aodurmaz.xyz/kisiler/delete_kisiler.php",method: .post,parameters: parametre).responseJSON {
            response in
            
            if let data = response.data {
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(json);
                         
                        // if bloğu arama yapılırken kişi silerken geri döndüğünde arama yapılan kişileri göstermek için kullanıılır.
                        
                        if self.aramaYapiliyorMu {
                            self.aramaYap(aramaKelimesi: self.aramaKelimesi!)
                        }else {
                            self.tumKisilerAl(); // kişiyi sildikten sonra arayüzü tekrar güncellemek için                           kullanılır
                        }
                                                    
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListe.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kisi = kisilerListe[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiHucre", for: indexPath) as! KisiHucreTableViewCell;
        
        cell.kisiYaziLabel.text = "\(kisi.kisi_ad) - \(kisi.kisi_tel)";
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let silAction = UITableViewRowAction(style: .default, title: "Sil", handler: {
            (action:UITableViewRowAction,indexPath:IndexPath) -> Void in
            
          
            let kisi = self.kisilerListe[indexPath.row];
            
            if let k_id = Int(kisi.kisiId!) {
                
                self.kisiSil(kisi_id: k_id);
                
            }
            
        })
        
        
        let guncelleAction = UITableViewRowAction(style: .normal, title: "Güncelle", handler: {
            (action:UITableViewRowAction,indexPath:IndexPath) -> Void in
            
            print("Güncelle tıklandı\(self.kisilerListe[indexPath.row])");
            
            self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row);

        })
        
        
        return [silAction,guncelleAction];
        
    }
    
}


extension ViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama sonucu : \(searchText)");
        
        aramaKelimesi = searchText
        
        if aramaKelimesi == "" {
            aramaYapiliyorMu = false
        }else {
            aramaYapiliyorMu = true;
        }
        
        aramaYap(aramaKelimesi: aramaKelimesi!);
    }
    
}
