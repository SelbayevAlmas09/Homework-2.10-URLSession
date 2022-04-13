//
//  MainViewController.swift
//  Homework 2.10 URLSession
//
//  Created by Almas Selbayev on 10.04.2022.
//

import UIKit
import Alamofire

class MainViewController: UICollectionViewController {
    var houses: [House] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alamofireGetButtonPressed()
//        NetworkManager.shared.fetchHouse(
//            completion: { house in
//                self.houses = house
//            }
//        )
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "houseDetail" {
            guard let houseDetailVC = segue.destination as? HouseDetailViewController else { return }
            guard let house = sender as? House else { return }
            houseDetailVC.house = house
        }
        
    }
    

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        houses.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            ) as? UserActionCell
        else {
            return UICollectionViewCell()
        }
        
        cell.userActionButton.text = houses[indexPath.item].name
        
        return cell
    }
    
    //  MARK: = UICollectioonViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let choosenHouse = houses[indexPath.item]
        performSegue(withIdentifier: "houseDetail", sender: choosenHouse)

    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}


extension MainViewController {
    func alamofireGetButtonPressed() {
        AF.request("https://wizard-world-api.herokuapp.com/Houses")
            .validate()
            .responseJSON { dataResponse in
                switch  dataResponse.result {
                case .success(let value):
                    guard let housesData = value as? [[String: Any]] else { return }
                    for houseData in housesData {
                        
                        var heads: [Head] = []
                        var traits: [Trait] = []
                        
                        guard let headsOfHouse = houseData["heads"] as? [[String: Any]] else { return }
                        for headOfHouse in headsOfHouse {
                            let head = Head(headData: headOfHouse)
                            
                            heads.append(head)
                        }
                        
                        guard let traitsOfHouse = houseData["traits"] as? [[String: Any]] else { return }
                        for traitOfHouse in traitsOfHouse {
                            let trait = Trait(traitData: traitOfHouse)
                            traits.append(trait)
                        }
                        
                        let house = House(houseData: houseData, houseHeads: heads, houseTraits: traits)
                        
                        self.houses.append(house)
                    }
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}
