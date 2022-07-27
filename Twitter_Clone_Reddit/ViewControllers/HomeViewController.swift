//
//  ViewController.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/26/22.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let headers: [String] = ["Home", " Entertainment Writers", "US Celebrities", "Progress"]
    
    private var homeHeaderBarNavigator: HomeHeaderBarNavigator!
    private var headarBarYConstraint: NSLayoutConstraint!
    
    private let cellID = "feedViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeHeaderBarNavigator = HomeHeaderBarNavigator(headers: headers)

        setUpViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeHeaderBarNavigator.setUpViewBounds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: Methods:
    
            
    

}




extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, HomeHeaderBarNavigationDelegate, NavBarScrollDelegate{
    
    func scrollShouldHideNavBar() {
        headarBarYConstraint.constant = 0
        self.homeHeaderBarNavigator.topViewsAreVisible(isVisible: false)
        UIView.animate(withDuration: 0.2){
            
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollShouldShowNavBar() {
        headarBarYConstraint.constant = 45
        self.homeHeaderBarNavigator.topViewsAreVisible(isVisible: true)
        UIView.animate(withDuration: 0.2){
            self.view.layoutIfNeeded()
        }
    }
    
    
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
        cell.customNavBarScrollDelegate = self
        return cell
       
        }
    
    
}


extension HomeViewController{
    
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

  
        let headerBarHeight: CGFloat = 145
        homeHeaderBarNavigator.clipsToBounds = false
        homeHeaderBarNavigator.selectionDelegate = self
        view.addSubview(homeHeaderBarNavigator)
        homeHeaderBarNavigator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeHeaderBarNavigator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeHeaderBarNavigator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeHeaderBarNavigator.heightAnchor.constraint(equalToConstant: headerBarHeight)
        ])
        headarBarYConstraint = homeHeaderBarNavigator.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 45 )
        headarBarYConstraint.isActive = true

        
    }
    
    
}

