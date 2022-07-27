//
//  HomeHeaderBarNavigator.swift
//  Twitter_Clone_Reddit
//
//  Created by Brandon Bravos on 7/26/22.
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
    

    
    // TESTING: scroll view
    private var scrollView:UIScrollView!
    
    // initialzed with a string of what our header title will be.
     init(headers: [String]){
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
        // MARK: for improvement, create custom scroll view animation, if duration is too slow, you get jittering.
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
        
      
        
        // moves the slider to our selection
        moveSliderToSelected(indexPath: selection)
        
        // refernce to our delegate
        selectionDelegate.didTapHeaderAt(didSelectHeaderAtIndex: selection)
        
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




extension HomeHeaderBarNavigator{
    
    // MARK: Methods Used Setting Up Our View
    
    // initiates all of our view set up methods
    func setUpView(headers: [String]){

        addBlur()
        addTitles(headers: headers)
        addSliderBar()
        drawBottomLine()
    }
    
  
    // adds all of our titles used for navigating and creates buttons
    func addTitles(headers: [String]){
        var trailingXInsert: NSLayoutXAxisAnchor?
        let distanceFromBottom = 7.0

        
        headerButtons = []
        
        let fontSizeBold = 15.0
        let headerFont = UIFont(name: "HelveticaNeue-Bold", size: fontSizeBold)


        if trailingXInsert == nil{
            trailingXInsert = leadingAnchor
        }
        
        var index = 0
        for title in headers{
            let color = index == 0 ?  ProjectThemes.lightGrayColorPT : ProjectThemes.darkGrayColorPT
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.titleLabel!.font = headerFont
            button.setTitleColor(color, for: .normal)
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distanceFromBottom),
                button.leadingAnchor.constraint(equalTo: trailingXInsert!, constant: sectionSpacing)
            ])
            trailingXInsert = button.trailingAnchor
            button.tag = index
            index += 1
            button.addTarget(self, action: #selector(headerSelected(sender:)), for: .touchDown)
            headerButtons.append(button)
            
        }
        
    }
    
    // used to create a seperator at the bottom of our view
    func drawBottomLine(){
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
       func addBlur(){
           let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           addSubview(blurEffectView)

       }
    
    // adds our slider bar to the view
    func addSliderBar(){
        let firstButton = headerButtons[0]
        let sliderHeight = 5.0
        
        sliderView = UIView()
        sliderView.layer.cornerRadius = sliderHeight / 2
        sliderView.backgroundColor = ProjectThemes.lightBlueColorPT
        addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: sliderHeight),
         
        ])
        
        sliderViewLeadingConstraint = sliderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sectionSpacing)
        sliderViewLeadingConstraint.isActive = true
        
        sliderViewWidthConstraint =  sliderView.widthAnchor.constraint(equalToConstant: firstButton.frame.width)
        sliderViewWidthConstraint.isActive = true

    }
    
    
}
