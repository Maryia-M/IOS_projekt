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
    
    private var tickerToId: [String: Int] = [:]
    
    override func viewDidLoad() {
           
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        requestInitialData()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.rowHeight = 80
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StockDetails", let stockDetailsVC = segue.destination as? StockDetailsViewController,
           let stock = sender as? (object: StockObject, image: UIImage?, isFavourite:Bool){
            stockDetailsVC.stock = stock
            }
        
    }
    
    private func requestInitialData(){
        let stockManager = StockManager()
        let components = stockManager.makeInitialDataURL()

        guard let url = components.url else{
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
    
    private func parseInitialData(from data: Data) {

        var stockArr = [(object: StockObject, image: UIImage?, isFavourite:Bool)]()
        do{
            let res = try JSONDecoder().decode([String:StockObject].self,from: data)
            print(res)
            
            var id = 0
            let sortedKeys = res.keys.sorted();
            for key in sortedKeys{
                let value = res[key]
                var current_image: UIImage?
                if let imageData = try? Data(contentsOf: URL(string: value!.logo.url)!){
                            if let image = UIImage(data: imageData) {
                                current_image = image
                            }
                }
                stockArr.append((object: value!, image: current_image, isFavourite: false))
                tickerToId[value!.quote.symbol] = id
                id += 1
            }
            stockArray = stockArr
            currentStockArray = stockArr
            
        }
        catch{
                print("JSON parsing error: " + error.localizedDescription)
        }
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentStockArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else{
            return UITableViewCell()
        }

        cell.updateInterface(with: currentStockArray?[indexPath.row])
        
        
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
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
        let id = tickerToId[ticker]
        stockArray![id!].isFavourite = !(stockArray![id!].isFavourite)
    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let stock = currentStockArray?[indexPath.row]
        performSegue(withIdentifier: "StockDetails", sender: stock)
    }
}

