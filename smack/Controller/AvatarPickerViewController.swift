//
//  AvatarPickerViewController.swift
//  smack
//
//  Created by Anthony Cozzi on 7/4/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //Variables
    var avatarType = AvatarType.dark
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func segmentControlChanged(_ sender: Any){
        if segmentControl.selectedSegmentIndex == 0{avatarType = .dark}
        else{avatarType = .light}
        collectionView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {dismiss(animated: true, completion: nil)}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberofColumns: CGFloat = 3
        if UIScreen.main.bounds.width > 320 {numberofColumns = 4}
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numberofColumns-1)*spaceBetweenCells) / numberofColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {UserDataService.instance.setavatarName(avatarName: "dark\(indexPath.item)")}
        else{UserDataService.instance.setavatarName(avatarName: "light\(indexPath.item)")}
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell{
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
}
