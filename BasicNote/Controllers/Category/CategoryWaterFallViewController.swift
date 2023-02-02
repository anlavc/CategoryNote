//
//  CategoryViewController.swift
//  BasicNote
//
//  Created by Anıl AVCI on 26.01.2023.
//

import UIKit

class CategoryWaterFallViewController: UIViewController {
    @IBOutlet weak var collectionWall: UICollectionView!
    let cell = "wallCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionWall.delegate = self
        collectionWall.dataSource = self
        
        let nibCell = UINib(nibName: "WaterFallCollectionViewCell", bundle: nil)
        collectionWall.register(nibCell, forCellWithReuseIdentifier: cell)
    }
    


}
extension CategoryWaterFallViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as? WaterFallCollectionViewCell
        cell?.textLabel.text = "Naber"
        return cell!
    }
}

