//
//  ViewController.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/26/22.
//

import UIKit


class HomeViewController: UIViewController {
        
    

    private lazy var feedCollectionView: UICollectionView = {
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
        // creates our header bar
        homeHeaderBarNavigator = HomeHeaderBarNavigator(headers: headers)
        
        // sets up our layout
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



 // MARK: Collection View and Delegates
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
        let contentOffset = self.feedCollectionView.contentOffset
        self.feedCollectionView.scrollRectToVisible(CGRect(x: contentOffsetX, y: -contentOffset.y, width: view.bounds.width, height: -contentOffset.y), animated: true)

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

      homeHeaderBarNavigator.moveSliderToSelected(indexPath: Int(scrollView.contentOffset.x / self.feedCollectionView.bounds.width))

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


    // MARK: View Layout
extension HomeViewController{
    
    func setUpViews(){
        feedCollectionView.backgroundColor = .black
        view.addSubview(feedCollectionView)
        feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        feedCollectionView.register(FeedViewCVCell.self, forCellWithReuseIdentifier: cellID)

  
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

