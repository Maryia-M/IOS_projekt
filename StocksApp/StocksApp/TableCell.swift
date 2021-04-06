//
//  TableCell.swift
//  StocksApp
//
//  Created by Мария Манкевич on 3/15/21.
//

import UIKit

protocol TableViewCellProtocol{
    func onClickCell(index: Int)
}

class TableCell: UITableViewCell {

    //UI
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var tickerLabel: UILabel!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBAction func clickButton(_ sender: Any) {
        cellDelegate?.onClickCell(index: (index?.row)!)
    }
    
    var cellDelegate: TableViewCellProtocol?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func makeSelected(selected: Bool){
        favouriteButton.isSelected = selected        
    }
    
    public func updateInterface(with data: (object: StockObject, image: UIImage?, isFavourite:Bool)?){
        let priceChange: Double = (data?.object.quote.change ?? 0)
        companyNameLabel.text = data?.object.quote.companyName
        tickerLabel.text = data?.object.quote.symbol
        priceLabel.text = String(data?.object.quote.latestPrice ?? 0) + "$"
        priceChangeLabel.text = String(data?.object.quote.change ?? 0) + "$"
        if priceChange > 0{
            priceChangeLabel.textColor = UIColor.green
        }
        else if priceChange < 0{
            priceChangeLabel.textColor = UIColor.red
        }
        else{
            priceChangeLabel.textColor = UIColor.black
        }
        logoImage.image = data?.image
        
        makeSelected(selected: (data?.isFavourite) ?? false)    }

}
