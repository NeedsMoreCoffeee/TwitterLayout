
//  Created by NeedsMoreCoffeee on 7/28/22.

import UIKit


class CustomTabBarView: UIView {
    
    
    // used to access in our base controller instead of creating a delegate
    public var tabTapped: ((_ tab: Int) -> Void)?
    
    /// the path of our tap, indicates the index in which our tab view was tapped
    private var indexPath: Int = 0
    
    
     init(menuItems: [CustomTabItem]) {
        super.init(frame: .zero)
         backgroundColor = .black
        
         // add our tabs
         addTabsToView(menuItems: menuItems)
     
         // sets our first tab as selected
         self.activateTab(tab: 0)
         
         setUpDividerBar()
    }
    
    
    // when a tab is pressed, switch it to a new page
    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        if sender.view!.tag == indexPath {
            currentPathSelected(indexPath: indexPath)
            return }
        self.switchTab(from: self.indexPath, to: sender.view!.tag)
    }
    
    private func currentPathSelected(indexPath: Int){
        let tabToActivate = self.subviews[indexPath] as! CustomTabView
        tabToActivate.animateBounce(isSelected: true)

    }
    
    // deactivates old tab and activates new one
    private func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    // activates the new view controller
    func activateTab(tab: Int) {
        // gets the subviews we have added. since our view is simple, we know only our tabs are our subviews.
        let tabToActivate = self.subviews[tab] as! CustomTabView
        
        // change the view in background, then animate the layouts if needed
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            // here is where we want to do animations for our tabs.
                tabToActivate.isSelected(true)   // place holder
                
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            // this is the referance to our higher function
            self.tabTapped?(tab)
            tabToActivate.animateBounce(isSelected: true)
        }
        
        // set the new indexPath to the new tab selected
        self.indexPath = tab
    }
    
    // deactivates a tab.
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab] as! CustomTabView
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            // here is where we want to do animations for our tabs.
                
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
            
            // change the previous tab image right away without waiting for animations
            inactiveTab.isSelected(false)   

        }
    }
    
    // MARK: Layout
    
    // adds the tabs to view
    func addTabsToView(menuItems: [CustomTabItem]){
        // this is used to set our tabs leading anchors
        var leadingAnchorConstraint: NSLayoutXAxisAnchor?
        
        // this creates the first anchor, then will be set after each button has been made
            // so that the next tab button will always start right after the previous
        if leadingAnchorConstraint == nil{
            leadingAnchorConstraint = leadingAnchor
        }
        
        // iterate through our CustomTabItems and create a tab for each
        for i in 0 ..< menuItems.count {
            // divide the width by the amount of items we have to ensure all of them fit the view with equal spacing
            let itemWidth = UIScreen.main.bounds.width / CGFloat(menuItems.count)
            
            // creates our tab item view.
            let itemView = CustomTabView(item: menuItems[i]) //self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            
            // set constraints
            self.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.widthAnchor.constraint(equalToConstant: itemWidth ),
                itemView.leadingAnchor.constraint(equalTo: leadingAnchorConstraint!),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
                itemView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            // sets the leading anchor to the trailing anchor of our previous view.
            leadingAnchorConstraint = itemView.trailingAnchor
            
            // allows us to tap our views, essentially turning them into buttons
            itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        }
        
    }
    
    // creates thin dividers. The better way to do this would be to override draw,using coregraphics
    // will change to draw with stroke() later
    func setUpDividerBar(){
        let horizontalDivider = UIView()
        horizontalDivider.backgroundColor = ProjectThemes.darkGrayColorPT
        addSubview(horizontalDivider)
        horizontalDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalDivider.topAnchor.constraint(equalTo: topAnchor),
            horizontalDivider.heightAnchor.constraint(equalToConstant: 0.25)
        ])
        
      
    }

  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}

// MARK: Custom TabBar View

private class CustomTabView: UIView{
    // the icon view of our tab bar
    private let itemIconView = UIImageView()
    
    // the tab item associated with this view
    private var tabItem: CustomTabItem!
    
    
    init(item: CustomTabItem) {
        super.init(frame: .zero)
        tabItem = item
        setUpView(item: item)
        
    }
    
    // this animates a bounce when pressed
    public func animateBounce(isSelected: Bool){
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.itemIconView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { _ in
            self.itemIconView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.changeImage(isSelected: isSelected)
        }
        
    }
    
    // called when the tab is selected.
    public func isSelected(_ isSelected: Bool = false){
       backgroundColor = isSelected ? .clear : .clear
       changeImage(isSelected: isSelected)
    }
    
    // changes the image of our image view
    private func changeImage(isSelected: Bool){
        let image = isSelected ? self.tabItem.selectedIcon : self.tabItem.icon
        self.itemIconView.image = image
    }
   
   // Layout
    private func setUpView(item: CustomTabItem){

        backgroundColor = .clear

        addSubview(itemIconView)
        let image = item.icon.withRenderingMode(.alwaysTemplate)
        itemIconView.image = image
        itemIconView.tintColor = ProjectThemes.lightGrayColorPT
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        
        
        NSLayoutConstraint.activate([
            itemIconView.heightAnchor.constraint(equalToConstant: 25),
            itemIconView.widthAnchor.constraint(equalToConstant: 25),
            itemIconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemIconView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


