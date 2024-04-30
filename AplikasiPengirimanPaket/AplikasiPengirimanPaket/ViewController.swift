//
//  ViewController.swift
//  AplikasiPengirimanPaket
//
//  Created by Markus Nugraha on 03/10/23.
//

import UIKit
import Foundation

// Untuk menyimpan hasil result dari cost
class ServiceDetails {
    var service: String
    var description: String
    var costValue: Int
    var etd: String
    
    init(service: String, description: String, costValue: Int, etd: String) {
        self.service = service
        self.description = description
        self.costValue = costValue
        self.etd = etd
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBOutlet weak var inputKotaAsal: UITextField!
    @IBOutlet weak var inputKotaTujuan: UITextField!
    @IBOutlet weak var inputBeratPaket: UITextField!
    @IBOutlet weak var inputJenisKurir: UITextField!
    
    // Untuk menyimpan hasil result dari func cekCost
    var listResultCekCost: [ServiceDetails] = []
    
    @IBAction func cekButton(_ sender: UIButton) {
        print("Tertekan lhoo..")
        
        // Mengambil nilai untuk kota asal
        var idKotaAsal: String = ""
        var inputNamaKota = String(describing: inputKotaAsal.text!)
        cariIDDariNamaKota(inputNamaKota: inputNamaKota) { idKota in
            if let idKota = idKota {
                idKotaAsal = idKota
                print("ID Kota: \(idKota)")
            } else {
                print("Kota \(inputNamaKota) tidak ditemukan")
            }
        }
        
        // Mengambil nilai untuk kota tujuan
        var idKotaTujuan: String = ""
        inputNamaKota = String(describing: inputKotaTujuan.text!)
        cariIDDariNamaKota(inputNamaKota: inputNamaKota) { idKota in
            if let idKota = idKota {
                idKotaTujuan = idKota
                print("ID Kota: \(idKota)")
            } else {
                print("Kota \(inputNamaKota) tidak ditemukan")
            }
        }
        
        // Mengambil nilai berat paket
        let beratPaket = String(describing: inputBeratPaket.text!)
        if let beratPaketInt = Int(beratPaket) {
            print("Berat Paket: \(beratPaketInt)")
        } else {
            print("Berat paket harus berupa angka bulat")
        }

        
        
        // Mengambil jenis kurir
        var jenisKurir = String(describing: inputJenisKurir.text!).lowercased()
        
        // Cek kurir (yang diperbolehkan hanya 3 JNE, TIKI, dan POS Indonesia)
        if (jenisKurir == "jne" || jenisKurir == "tiki" || jenisKurir == "pos indonesia") {
            print("Jenis Kurir: \(jenisKurir)")
        } else {
            jenisKurir = "JNE"  // Untuk pengguna RajaOngkir kelas starter yang tersedia hanya 3 jenis kurir (sehingga default valuenya JNE)
            print("Kurir tidak tersedia")
        }
        
        
        // Memanggil fugnsi cekCost untuk menemukan semua resultnya
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [self] in
            cekCost(idKotaAsal: idKotaAsal, idKotaTujuan: idKotaTujuan, beratPaket: beratPaket, jenisKurir: jenisKurir)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { [self] in
            performSegue(withIdentifier: "moveToDetailCostPaket", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailCostViewController {
            let vc = segue.destination as? DetailCostViewController
            vc?.importListResultCekCost = self.listResultCekCost
        }
    }
    
    
    func cariIDKota(namaKota: String, dari dataKota: [[String: Any]]) -> (String?) {
        var idKota: String?

        for kota in dataKota {
            if let nama = kota["city_name"] as? String, nama.lowercased() == namaKota.lowercased() {
                idKota = kota["city_id"] as? String
                break
            }
        }
        return idKota
    }

    func cariIDDariNamaKota(inputNamaKota: String, completion: @escaping (String?) -> Void) {
        let headers = ["key": "057a6744b9354fe7e9e8ffd1d45ff34b"]
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/city")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error: \(error)")
                completion(nil) // Mengembalikan nil jika terjadi error
            } else if let data = data {
                do {
                    // Mencari ID Kota dari nama Kota
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let rajaongkir = json["rajaongkir"] as? [String: Any],
                    let results = rajaongkir["results"] as? [[String: Any]] {

                        // Memanggil fungsi untuk mencari ID kota
                        let idKota = self.cariIDKota(namaKota: inputNamaKota, dari: results)
                        completion(idKota) // Mengembalikan ID Kota
                    }
                } catch {
                    print("Gagal menguraikan data JSON: \(error)")
                    completion(nil) // Mengembalikan nil jika terjadi error
                }
            }
        })
        dataTask.resume()
    }
    
    
    func cekCost(idKotaAsal: String, idKotaTujuan: String, beratPaket: String, jenisKurir: String) {
        let headers = [
            "key": "057a6744b9354fe7e9e8ffd1d45ff34b",
            "content-type": "application/x-www-form-urlencoded"
        ]

        let postData = NSMutableData(data: "origin=\(idKotaAsal)".data(using: String.Encoding.utf8)!)
        postData.append("&destination=\(idKotaTujuan)".data(using: String.Encoding.utf8)!)
        postData.append("&weight=\(beratPaket)".data(using: String.Encoding.utf8)!)
        postData.append("&courier=\(jenisKurir)".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/cost")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let rajaongkir = json["rajaongkir"] as? [String: Any],
                        let results = rajaongkir["results"] as? [[String: Any]] {

                        for result in results {
                            if let code = result["code"] as? String,
                                let name = result["name"] as? String,
                                let costs = result["costs"] as? [[String: Any]] {

                                print("Code: \(code)")
                                print("Name: \(name)")

                                for cost in costs {
                                    if let service = cost["service"] as? String,
                                        let description = cost["description"] as? String,
                                        let costDetails = cost["cost"] as? [[String: Any]],
                                        let costValue = costDetails.first?["value"] as? Int,
                                        let etd = costDetails.first?["etd"] as? String {

                                        print("Service: \(service)")
                                        print("Description: \(description)")
                                        print("Cost Value: \(costValue)")
                                        print("ETD: \(etd)")
                                        
                                        self.listResultCekCost.append(ServiceDetails(service: service, description: description, costValue: costValue, etd: etd))
                                    }
                                }
                                print(listResultCekCost)
                            }
                        }
                    }
                } catch {
                    print("Gagal menguraikan data JSON: \(error)")
                }
            }
        })
        dataTask.resume()
    }
}



