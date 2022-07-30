//
//  HomeHeaderBarNavigator.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/26/22.
//

import UIKit

// a delegate we created to control our scroll view when a header is pressed.
protocol HomeHeaderBarNavigationDelegate{
    
    /// used when a header is tapped, returns an indexpath of the selected header
    func didTapHeaderAt( didSelectHeaderAtIndex indexPathInt: Int)
    
}

class HomeHeaderBarNavigator: UIView {
    
    /// the current selected header for our navigator
    public var headerIndexPath: Int = 0
    
    /// Delegate for home header bar navigator. Contains method for when header is tapped
    public var selectionDelegate: HomeHeaderBarNavigationDelegate!
    

    
    // MARK: private variables
    
    
    private var profileButton: UIButton!
    
    private var centerImageView: UIImageView!
    
    // used to add space between  headers
    private var sectionSpacing: CGFloat = 25
    
    // an array of headers
    private var headerButtons: [UIButton]!
    
    // this view is used to underline which header is selected
    private var sliderView: UIView!
    
    // the constraints used to animate the slider, we manipulate the width and height constraints.
    private var sliderViewLeadingConstraint: NSLayoutConstraint!
    private var sliderViewWidthConstraint: NSLayoutConstraint!
    
    // used to make sure our slider animations dont over lap
    private var animatingPress: Bool = false
    
    // the view within our scroll view
    private var contextView = UIView()


    // the scroll view that contains our context view that holds our headerLabels
    private var scrollView: UIScrollView!
    
    // initialzed with a string of what our header title will be.
     init(headers: [String]?){
        super.init(frame: .zero)
        setUpView(headers: headers)
    }
    
    
    // MARK: Public Methods
    
    /// used to move the slider to a new header and set it as the current selected slider
    public func moveSliderToSelected(indexPath: Int){
        
        // adjust our sliders x-constraints based on the new buttons minX
        sliderViewLeadingConstraint.constant = headerButtons[indexPath].frame.minX
        sliderViewLeadingConstraint.isActive = true

        // adjust the sliders width to the new headers width
        sliderViewWidthConstraint.constant = headerButtons[indexPath].bounds.width
        sliderViewWidthConstraint.isActive = true

        // set our new header as our current header
        self.headerIndexPath = indexPath
        
        // update our highlighted view
        updateHighlightedLabels()
        
        // animate the transition
        // MARK: for improvement, create custom scroll view animation, if duration is too slow, you get jittering. Switch scrollView to collectionView
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.layoutIfNeeded()

        }, completion: { _ in
            self.animatingPress = false
        })
        
    }
    
    
     ///  Used to adjust the slider while the scroll view is scrolling, this function is for animating between scrolls
     public func adjustSlider(translation: CGFloat){
        
         // check to make sure we're no animating already
         if animatingPress { return }

         // check to make sure we have the width so we dont devide by zero
         if bounds.width <= 0 {return}
         
         // here we get the magnitude / percentage of our translation
         // if the directional scale is negative, we are going backwards
         let directionScale = (translation / bounds.width) - CGFloat(headerIndexPath)
         
         // we make sure we're not sending the slider out of our headers array
         if directionScale <= 0 && headerIndexPath == 0  || directionScale >= 0 && headerIndexPath == headerButtons.count - 1{ return }
         
         // This is math used to Translate the slider position between two points
         let tooPosition = directionScale < 0 ? headerButtons[headerIndexPath - 1] : headerButtons[headerIndexPath + 1]
         let fromPosition = headerButtons[headerIndexPath]
         let difference = (tooPosition.frame.minX - headerButtons[headerIndexPath].frame.minX) * abs(directionScale)
         
         // apply the transition to our constraint
         sliderViewLeadingConstraint.constant = difference + fromPosition.frame.minX
         
      
         
         // This is math used to Translate the width of the slider between points
         let fromWidth = fromPosition.frame.width
         let tooWidth = tooPosition.frame.width
         let sizeDifference =  fromWidth - tooWidth
         let modifier = fromWidth > tooWidth ? abs(sizeDifference * directionScale) : sizeDifference * abs(directionScale)
         
         // apply the calculated width to our constraint
         sliderViewWidthConstraint.constant = fromWidth - (modifier)

         // animate our changes
         UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear){
             self.layoutIfNeeded()
         }
        
     }
    
    /// call this after superview did appear, sets the views bounds
    public func setUpViewBounds(){
        let distance = headerButtons[headerButtons.count - 1].frame.maxX
        scrollView.contentSize = CGSize(width: distance + 10, height: 35.0)

    }
  
    public func topViewsAreVisible(isVisible: Bool){
        UIView.animate(withDuration: 0.2){
            self.profileButton.alpha = isVisible ? 1 : 0
        }
    }
    
    
    // MARK: Private Methods
    
    // determines if our header has been pressed, changes view accordingly
    @objc private func headerSelected(sender: UIButton){
        animatingPress = true
        
        // determines which header was tapped
        let selection = sender.tag
        
        // if we are currently in this header, return
        if selection == headerIndexPath { return }
        
        // set our header
        headerIndexPath = selection
        
        // change the color of our other headers
        updateHighlightedLabels()
        
        // used to center our selection
        adjustScrollView()
        
        // moves the slider to our selection
        moveSliderToSelected(indexPath: selection)
        
        // refernce to our delegate
        selectionDelegate.didTapHeaderAt(didSelectHeaderAtIndex: selection)
        
    }
    
    // called when our profile button is tapped
    @objc private func profileButtonTapped(){
        TabBarController.parentController?.showMenu()
    }
    
    // adjusts the scroll view so that the selected view is always in center
    private func adjustScrollView(){
        let selectedMinX = headerButtons[headerIndexPath].frame.minX
        let scrollViewWidth = scrollView.contentSize.width
        let maxOffset = scrollViewWidth - bounds.width + 20
        
        // if the headers are smaller than the view, do not animate
        if maxOffset < 0 { return }
        
        let percentageOfTranslation =  selectedMinX / scrollViewWidth
        let offset = maxOffset * percentageOfTranslation
        
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)

    }
    
 
    // function that grays all headers, then highlights selected header
    private func updateHighlightedLabels(){
        // iterate over headers, then set highlight based on currentSelectedHeader
        for (index, label) in headerButtons.enumerated(){
            let color = index == headerIndexPath ?  ProjectThemes.lightGrayColorPT : ProjectThemes.darkGrayColorPT
            label.setTitleColor(color, for: .normal)
        }
    }
    
    
   // required initialization coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: View Layout

extension HomeHeaderBarNavigator: UIScrollViewDelegate{
    

    
    // initiates all of our view set up methods
   private func setUpView(headers: [String]?){

        guard let headers = headers else {
            return
        }

        addBlur()
        addScrollView()
        addTopImages()
        addTitles(headers: headers)
        addSliderBar()
        drawBottomLine()
    }
    
    // scrollView used to show all headers
   private func addScrollView(){
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        
        contextView.backgroundColor = .clear
        scrollView.addSubview(contextView)
        contextView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            contextView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2),
            contextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contextView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)

        ])
        
    }
    

   
    // adds all of our titles used for navigating and creates buttons
    private func addTitles(headers: [String]){
        var trailingXInsert: NSLayoutXAxisAnchor?
        let distanceFromBottom = 7.0

        
        headerButtons = []
        
        let fontSizeBold = 15.0
        let headerFont = UIFont(name: "HelveticaNeue-Bold", size: fontSizeBold)


        if trailingXInsert == nil{
            trailingXInsert = contextView.leadingAnchor
        }
        
        var twoHeadersInitialSpacing = 0.0
        
        var index = 0
        for title in headers{
            let color = index == 0 ?  ProjectThemes.lightGrayColorPT : ProjectThemes.darkGrayColorPT
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.titleLabel!.font = headerFont
            button.setTitleColor(color, for: .normal)
            contextView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            
            if headers.count == 2 {
                sectionSpacing = (UIScreen.main.bounds.width / 5) * CGFloat(index * 2 + 1)
                print(sectionSpacing)
                if index == 0 { twoHeadersInitialSpacing = sectionSpacing}
                
            }
                
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: contextView.bottomAnchor, constant: -distanceFromBottom),
                button.leadingAnchor.constraint(equalTo: trailingXInsert!, constant: sectionSpacing)
            ])
            
            if headers.count != 2{
            trailingXInsert = button.trailingAnchor
            }
            button.tag = index
            index += 1
            button.addTarget(self, action: #selector(headerSelected(sender:)), for: .touchUpInside)
            headerButtons.append(button)
            
        }
        
        if headers.count == 2 {sectionSpacing = twoHeadersInitialSpacing}
    }
    
    // used to create a seperator at the bottom of our view
    private func drawBottomLine(){
        let seperator = UIView()
        seperator.backgroundColor = ProjectThemes.darkGrayColorPT
        addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperator.bottomAnchor.constraint(equalTo: bottomAnchor),
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    // creates our transparent background
    private func addBlur(){
           let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           addSubview(blurEffectView)

       }
    
    // adds our slider bar to the view
    private func addSliderBar(){
        let firstButton = headerButtons[0]
        let sliderHeight = 5.0
        
        sliderView = UIView()
        sliderView.layer.cornerRadius = sliderHeight / 2
        sliderView.backgroundColor = ProjectThemes.lightBlueColorPT
        contextView.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderView.bottomAnchor.constraint(equalTo: contextView.bottomAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: sliderHeight),
         
        ])
        
        sliderViewLeadingConstraint = sliderView.leadingAnchor.constraint(equalTo: contextView.leadingAnchor, constant: sectionSpacing)
        sliderViewLeadingConstraint.isActive = true
        
        sliderViewWidthConstraint =  sliderView.widthAnchor.constraint(equalToConstant: firstButton.frame.width)
        sliderViewWidthConstraint.isActive = true

    }
    
    
    private func addTopImages(){
        centerImageView = UIImageView(image: UIImage(named: "twitter_logo"))
        centerImageView.contentMode = .scaleAspectFit
        addSubview(centerImageView!)
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerImageView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            centerImageView.widthAnchor.constraint(equalToConstant: 30),
            centerImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
        let profileImageSize: CGFloat = 40
        let profileImage = UIImage(named: "profile_img")
        profileButton = UIButton()
        profileButton.setImage(profileImage, for: .normal)
        profileButton.layer.cornerRadius = profileImageSize / 2
        profileButton.clipsToBounds = true
        profileButton.contentMode = .scaleToFill
        addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileButton.centerYAnchor.constraint(equalTo: centerImageView.centerYAnchor, constant: -3),
            profileButton.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileButton.heightAnchor.constraint(equalToConstant: profileImageSize)
        ])
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchDown)
    }
    
    
    
}
