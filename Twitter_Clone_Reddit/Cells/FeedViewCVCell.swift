//
//  FeedView.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/26/22.
//

import UIKit

protocol NavBarScrollDelegate{
 
    func scrollShouldHideNavBar()
    func scrollShouldShowNavBar()

    
}

// this class is our view that will hold our feeds.
class FeedViewCVCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
        
    let cellID = "feedViewCell"
    
    private var startOffSet:CGFloat = 0
    private var scrollTranslation: CGFloat = 0
    
    public var customNavBarScrollDelegate: NavBarScrollDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollingDown = startOffSet < scrollView.contentOffset.y

        if scrollingDown{ scrollTranslation -= 1} else { scrollTranslation += 1}
        
        if scrollView.contentOffset.y < 200{
            customNavBarScrollDelegate.scrollShouldShowNavBar()
            return
        }
        
        if(scrollTranslation > 10 ){
            customNavBarScrollDelegate.scrollShouldShowNavBar()
        }
        
        if(scrollTranslation < -10 && scrollView.contentOffset.y > 200){
            customNavBarScrollDelegate.scrollShouldHideNavBar()
        }
        
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollTranslation = 0
        startOffSet = scrollView.contentOffset.y
    }
    
  
    
    func setUpViews(){
        let textDarkColor = UIColor(hue: 0.6028, saturation: 0.06, brightness: 0.47, alpha: 1.0) /* #72757a */

        addSubview(collectionView)
        collectionView.backgroundColor = textDarkColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
 
        collectionView.register(PostCVCell.self, forCellWithReuseIdentifier: cellID)

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}



extension FeedViewCVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let path = UIScreen.main.bounds
        
        return CGSize(width: path.width, height: path.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PostCVCell
        cell.backgroundColor =  .black //colors[indexPath.row]
        return cell
       
        }
    
    
}
