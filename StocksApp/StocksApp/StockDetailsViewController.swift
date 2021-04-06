//
//  StockDetailsViewController.swift
//  StocksApp
//
//  Created by Мария Манкевич on 4/5/21.
//

import UIKit

class StockDetailsViewController: UIViewController {
    
    var stock: (object: StockObject, image: UIImage?, isFavourite:Bool)?
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "-"
        websiteLabel.text = "-"
        addressLabel.text = "-"
        descriptionLabel.text = "-"
        requestData()
        

        // Do any additional setup after loading the view.
        logoImageView.image = stock?.image
    }
    
    
    private func requestData(){
        let stockManager = StockManager()
        let components = stockManager.makeDescriptionURL(ticker: (stock?.object.quote.symbol)!)

        guard let url = components.url else{
                return
            }
            print(url)
            let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
                if let data = data, (response as? HTTPURLResponse)?.statusCode == 200, error == nil{
                    self?.parseData(from: data)
                }
                else{
                    print("Network error!")
                }
            }
            
            dataTask.resume()
    }
    
    private func parseData(from data: Data) {

        do{
            let res = try JSONDecoder().decode(CompanyDescription.self,from: data)
            print(res)
            DispatchQueue.main.async{ [weak self] in self?.displayCompanyInfo(description: res)}
        }
        catch{
                print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayCompanyInfo(description: CompanyDescription){
        nameLabel.text = description.companyName
        websiteLabel.text = description.website
        addressLabel.text = "\(description.city ?? ""), \(description.country ?? "")"
        descriptionLabel.text = description.description
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
