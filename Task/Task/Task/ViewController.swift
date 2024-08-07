//
//  ViewController.swift
//  Task
//
//  Created by on 04/08/24.
//

import UIKit
import AVKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var reels: [Reel] = []
    private var colreels: Reels?

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadReelData()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
              layout.scrollDirection = .vertical
              collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
              collectionView.delegate = self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        // Set up constraints if needed
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

   private func loadReelData() {
        guard let url = Bundle.main.url(forResource: "reels", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            // Read the data from the file
            let data = try Data(contentsOf: url)
            
            // Decode the JSON data
            let decoder = JSONDecoder()
            colreels = try decoder.decode(Reels.self, from: data)
            self.reels = colreels?.reel ?? []
            print(reels)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.configure(with: reels[indexPath.item].arr ?? [])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? MyCell)?.stopPlayback()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playVisibleCells()
    }

    private func playVisibleCells() {
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? MyCell }
        visibleCells.forEach { $0.startPlayback() }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      let noOfCellsInRow = 2   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
       // layer.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width / 2 - 50, height: 600)

        return CGSize(width: size , height: size)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let cellWidthPadding = collectionView.frame.size.width / 30
        let cellHeightPadding = collectionView.frame.size.height / 4
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10 // Adjust this value based on your needs
       }
        
}
