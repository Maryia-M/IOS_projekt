//
//  ViewController.swift
//  StocksApp
//
//  Created by Мария Манкевич on 3/14/21.
//

import UIKit

class ViewController: UIViewController{
    
       
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private lazy var tickers = [
            "AAPL",
            "MSFT",
            "GOOG",
            "AMZN",
            "FB",
            "INTC",
            "YNDX",
            "CSCO",
            "ORCL",
            "BKNG",
            "UBER",
            "FDX",
            "BIDU"
        ]
    
    private var stockArray: [(object: StockObject, image: UIImage?, isFavourite:Bool)]?{
        didSet{
            DispatchQueue.main.async{
                self.tableView.reloadData();
            }
        }
    }
    private var currentStockArray: [(object: StockObject, image: UIImage?, isFavourite:Bool)]?
    
   
    private var isFiltered = false
    private var isFavourite = false
    
    private var search = ""
    
    private var ticker_to_id = [String: Int]()
    
    override func viewDidLoad() {
           
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(tickers)
        requestInitialData()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
    }
    
    private func requestInitialData(){
            let companies = tickers.joined(separator: ",")
            print(companies)
            let token = "pk_2daee599f0244e859f0a0f11989760c4"
            
            guard let url = URL(string:
                                    "https://cloud.iexapis.com/stable/stock/market/batch?symbols=\(companies)&types=quote,logo&token=\(token)") else{
                return
            }
            print(url)
            let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
                if let data = data, (response as? HTTPURLResponse)?.statusCode == 200, error == nil{
                    self?.parseInitialData(from: data)
                }
                else{
                    print("Network error!")
                }
            }
            
            dataTask.resume()
        }
        
    
    private func parseInitialData(from data: Data){

        do{
            let res = try JSONDecoder().decode([String:StockObject].self,from: data)
            print(res)
            var stockArr = [(object: StockObject, image: UIImage?, isFavourite:Bool)]()
            var id = 0
            for (_, value) in res{
                var current_image: UIImage?
                if let imageData = try? Data(contentsOf: URL(string: value.logo.url)!){
                            if let image = UIImage(data: imageData) {
                                current_image = image
                            }
                }
                stockArr.append((object: value, image: current_image, isFavourite: false))
                ticker_to_id[value.quote.symbol] = id
                id += 1
            }
                
            stockArray = stockArr
            currentStockArray = stockArray
            
        }
        catch{
                print("JSON parsing error: " + error.localizedDescription)
        }
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentStockArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{
            return UITableViewCell()
        }

        let priceChange: Double = (currentStockArray?[indexPath.row].object.quote.change ?? 0)
        cell.companyNameLabel.text = currentStockArray?[indexPath.row].object.quote.companyName
        cell.tickerLabel.text = currentStockArray?[indexPath.row].object.quote.symbol
        cell.priceLabel.text = String(currentStockArray?[indexPath.row].object.quote.latestPrice ?? 0) + "$"
        cell.priceChangeLabel.text = String(currentStockArray?[indexPath.row].object.quote.change ?? 0) + "$"
        cell.logoImage.image = currentStockArray?[indexPath.row].image
        if priceChange > 0{
            cell.priceChangeLabel.textColor = UIColor.green
        }
        else if priceChange < 0{
            cell.priceChangeLabel.textColor = UIColor.red
        }
        else{
            cell.priceChangeLabel.textColor = UIColor.black
        }
        cell.cellDelegate = self
        cell.index = indexPath
        cell.makeSelected(selected: (currentStockArray?[indexPath.row].isFavourite) ?? false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            isFiltered = false
            if isFavourite {
                currentStockArray = stockArray!.filter({ stock -> Bool in stock.isFavourite == true })
            }
            else{
                currentStockArray = stockArray
            }
            
            tableView.reloadData()
            return
        }
        
        currentStockArray = stockArray?.filter({stock -> Bool in
            (stock.object.quote.companyName.lowercased().contains(searchText.lowercased()) || stock.object.quote.symbol.lowercased().contains(searchText.lowercased()))
        })
        
        if isFavourite {
            currentStockArray = currentStockArray!.filter({ stock -> Bool in stock.isFavourite == true })
        }
        search = searchText
        isFiltered = true

        print("search \(searchText) current size \(currentStockArray!.count)")
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope{
        case 0:
            currentStockArray = stockArray
            isFavourite = false
        case 1:
            currentStockArray = stockArray!.filter({ stock -> Bool in stock.isFavourite == true })
            isFavourite = true
        default:
            break
        }
        if isFiltered {
            currentStockArray = currentStockArray?.filter({stock -> Bool in
                (stock.object.quote.companyName.lowercased().contains(search.lowercased()) || stock.object.quote.symbol.lowercased().contains(search.lowercased()))
            })
        }
        print("current size is \(currentStockArray!.count)")
        tableView.reloadData()
    }
}

extension ViewController: TableViewCellProtocol{
    func onClickCell(index: Int) {
        currentStockArray![index].isFavourite = !(currentStockArray![index].isFavourite)
        let ticker = currentStockArray![index].object.quote.symbol
        let id = ticker_to_id[ticker]
        stockArray![id!].isFavourite = !(stockArray![id!].isFavourite)
    }
    
}


