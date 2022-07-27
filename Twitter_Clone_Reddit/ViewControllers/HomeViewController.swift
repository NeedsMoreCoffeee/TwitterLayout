//
//  ViewController.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/26/22.
//

import UIKit

class HomeViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let headers: [String] = ["Home", "Entertainment Writers", "News", "Progress"]
    
    var homeHeaderBarNavigator: HomeHeaderBarNavigator!
        
    let cellID = "feedViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         homeHeaderBarNavigator = HomeHeaderBarNavigator(headers: headers)

        setUpViews()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setUpViews(){
   
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(FeedViewCVCell.self, forCellWithReuseIdentifier: cellID)

  
        let headerBarHeight = 85.0
        homeHeaderBarNavigator.clipsToBounds = true
        homeHeaderBarNavigator.selectionDelegate = self
        view.addSubview(homeHeaderBarNavigator)
        homeHeaderBarNavigator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeHeaderBarNavigator.topAnchor.constraint(equalTo: view.topAnchor),
            homeHeaderBarNavigator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeHeaderBarNavigator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeHeaderBarNavigator.heightAnchor.constraint(equalToConstant: headerBarHeight)
        ])
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, HomeHeaderBarNavigationDelegate{
    
    func didTapHeaderAt(didSelectHeaderAtIndex indexPathInt: Int) {
        let contentOffsetX = view.bounds.width * CGFloat(indexPathInt)
        let contentOffset = self.collectionView.contentOffset
        self.collectionView.scrollRectToVisible(CGRect(x: contentOffsetX, y: -contentOffset.y, width: view.bounds.width, height: -contentOffset.y), animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let path = collectionView.bounds
        let inset = collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom

        return CGSize(width: path.width, height: path.height - inset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        homeHeaderBarNavigator.adjustSlider(translation: scrollView.contentOffset.x)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

      homeHeaderBarNavigator.moveSliderToSelected(indexPath: Int(scrollView.contentOffset.x / self.collectionView.bounds.width))

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedViewCVCell
        return cell
       
        }
    
    
}

