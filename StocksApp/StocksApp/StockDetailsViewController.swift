//
//  StockDetailsViewController.swift
//  StocksApp
//
//  Created by Мария Манкевич on 4/5/21.
//

import UIKit

class StockDetailsViewController: UIViewController {
    
    var stock: (object: StockObject, image: UIImage?, isFavourite:Bool)?
    

    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logoImageView.image = stock?.image
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