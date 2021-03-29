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

}
