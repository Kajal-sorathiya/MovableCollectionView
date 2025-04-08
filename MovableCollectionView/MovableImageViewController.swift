//
//  ViewController.swift
//  MovableCollectionView
//
//  Created by Ahir on 06/12/23.
//

import UIKit

class MovableImageViewController: UIViewController {
    
    var collectionview: UICollectionView?
    var colors: [UIColor] = [
        .link,
        .systemGreen,
        .systemBlue,
        .red,
        .systemOrange,
        .systemPink,
        .black,
        .systemPurple,
        .systemYellow
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/3.2,
                                 height: view.frame.size.width/3.2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionview?.delegate = self
        collectionview?.dataSource = self
        collectionview?.backgroundColor = .white
        view.addSubview(collectionview!)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionview?.addGestureRecognizer(gesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview?.frame = view.bounds
    }
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionview = collectionview else {
            return
        }
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionview.indexPathForItem(at: gesture.location(in: collectionview)) else {
                return
            }
            collectionview.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionview.updateInteractiveMovementTargetPosition(gesture.location(in: collectionview))
        case .ended:
            collectionview.endInteractiveMovement()
        default:
            collectionview.cancelInteractiveMovement()
        }
    }
}

extension MovableImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview?.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell?.backgroundColor = colors[indexPath.row]
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width/2.2,
               height: view.frame.size.width/2.2)
    }
    
    // Re-order
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = colors.remove(at: sourceIndexPath.row)
        colors.insert(item, at: destinationIndexPath.row)
    }
}
