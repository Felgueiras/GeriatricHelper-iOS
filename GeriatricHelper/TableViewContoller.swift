//
//  TableViewContoller.swift
//  GeriatricHelper
//
//  Created by felgueiras on 24/04/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

struct cellData {
    let cell: Int!
    let text: String!
    let image: UIImage!
}

class TableViewContoller: UITableViewController {
    
    var myArrayOfCellData = [cellData]()
    
    override func viewDidLoad() {
        myArrayOfCellData = [cellData(cell: 1, text: "asfasfasf", image: #imageLiteral(resourceName: "Awc_skyline_sunset_small")),
        cellData(cell: 2, text: "fff", image: #imageLiteral(resourceName: "Awc_skyline_sunset_small")),
        cellData(cell: 1, text: "afsasaffsa", image: #imageLiteral(resourceName: "Awc_skyline_sunset_small"))]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if myArrayOfCellData[indexPath.row].cell == 1{
            
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            cell.mainImageView.image = myArrayOfCellData[indexPath.row].image
            cell.mainLabel.text = myArrayOfCellData[indexPath.row].text
            
            return cell
        }
        else if myArrayOfCellData[indexPath.row].cell == 2{
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.mainImageView.image = myArrayOfCellData[indexPath.row].image
            cell.mainLabel.text = myArrayOfCellData[indexPath.row].text
            
            return cell
        }
        else {
            
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            cell.mainImageView.image = myArrayOfCellData[indexPath.row].image
            cell.mainLabel.text = myArrayOfCellData[indexPath.row].text
            
            return cell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if myArrayOfCellData[indexPath.row].cell == 1{
            
            return 250
            
        }
        else if myArrayOfCellData[indexPath.row].cell == 2{
          return 100
        }
        else {
            
           return 250
        }
    }

    
}
