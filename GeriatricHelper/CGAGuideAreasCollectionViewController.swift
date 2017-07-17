//
//  CGAGuideAreasCollectionViewController.swift
//  GeriatricHelper
//
//  Created by felgueiras on 17/07/2017.
//  Copyright © 2017 felgueiras. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CGAGuideAreasCollectionViewController: UICollectionViewController {
    
    
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Constants.cgaAreas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! CGAGuideAreaCollectionViewCell
    
        // get area
        let area = Constants.cgaAreas[indexPath.row]
        
        // Configure the cell
        // area icon
        switch area {
        case Constants.cga_functional:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_functional")
        case Constants.cga_afective:
            cell.areaIcon?.image = #imageLiteral(resourceName: "cga_afective")
        case Constants.cga_march:
            cell.areaIcon?.image = #imageLiteral(resourceName: "cga_march")
        case Constants.cga_cognitive:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_mental")
        case Constants.cga_nutritional:
            cell.areaIcon?.image = #imageLiteral(resourceName: "ic_nutritional")
        default:
            cell.areaIcon?.image = #imageLiteral(resourceName: "icon_small")
        }
        
        // name
        cell.name!.text = area
        
        // description
        var areaDescriptionText: String?
        switch area {
        case Constants.cga_functional:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key: "cga_functional")
            break;
        case Constants.cga_afective:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_afective")
            break;
        case Constants.cga_nutritional:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_nutritional")
            break;
        case Constants.cga_cognitive:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_cognitive")
            break;
        case Constants.cga_march:
            areaDescriptionText = FirebaseRemoteConfig.getStringFirebase(key:"cga_march")
            break;
        default:
            areaDescriptionText = ""
        }
        cell.areaDescription!.text = areaDescriptionText
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension CGAGuideAreasCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
