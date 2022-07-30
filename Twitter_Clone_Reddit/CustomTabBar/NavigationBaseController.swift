//
//  NavigationBaseController.swift
//  CustomTabBar
//
//  Created by NeedsMoreCoffeee on 7/28/22.
//
import UIKit


// this is a global property that reference this script. Use cautiosly, should only be set once
// we will use this to get a reference to this base class throughout our project
// most notably for opening and closing our menu view, witch will rest on the side of this base view

struct TabBarController{
    static var parentController: NavigationMenuBaseController?
}


class NavigationMenuBaseController: UITabBarController {
    

    
    // the views we want to show
    private let tabItems: [CustomTabItem] = [.home, .search, .spaces, .notifications, .inbox]

    // the width of our menuView
    private var menuWidth = 100.0
    
    
    // a reference to our custom tab bar
    var customTabBar: CustomTabBarView!
   
    // the leading constraint of our custom tab bar used for animating
    private var tabBarLeadingConstraint: NSLayoutConstraint!

    // our menu view that rests on the left hand side of this controller
    private var menuView: AccountMenuView!
   
    // a bool that determines if the menu is open
     public var menuIsOpen: Bool {
         return tabBarLeadingConstraint.constant > 0
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.parentController = self
        
        self.loadTabBar()
        
        // adds our singular menu view used accross our app
        addMenuView()
        
    }
  
    // controls our menu slider, moves the view to the right to reveal the menu.
    @objc func showMenu(){
      
        // if the frame is even 1 point opened, we set it to shut
        let toDirection = menuIsOpen ? 0 : menuWidth
        
        // animate the view opening or closing
        self.tabBarLeadingConstraint.constant = toDirection
        self.tabBarLeadingConstraint.isActive = true
        
        // references our navigational vc / content view so we can animate it
        let currentVC =  self.viewControllers?[self.selectedIndex]
        
        // animate our tab bar moving to show menu view
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // animate our content view NOTE: I do not know why I have to animate these seperately
            // suspecting it has to do with only one view animating at a time? not sure.
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            currentVC?.view.frame = CGRect(x:toDirection, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        })
        
        // tells our menu function what to do when opening and closing
        menuView.showMenuView(showMenu: menuIsOpen)
        
    }
   
    
    // load the tab bar
    func loadTabBar() {
        // sets up our custom tab bar view amd adds our view controllers to our tab bar controller
        self.setupCustomTabBar(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        
        // sets our tab bar controller (current file) to our first view
        self.selectedIndex = 0
    }
    
    // this sets up our custom tab bar view and gets an array of view controllers
    func setupCustomTabBar(_ items: [CustomTabItem], completion: @escaping ([UIViewController]) -> Void) {
       
        // initiate an empty array to hold view controllers
        var controllers: [UIViewController] = []

        // adds the custom tab bar view and constraints.
        addCustomTabBarToView(items)
        
        // iterate through our views to add view controllers
        // IMPORTANT: WHEN CREATING A CUSTOM TAB BAR CONTROLLER, REMEMBER TO IMBED THEM IN A NAV CONTROLLER
        // There were issues registering cv's and other things until I embeded the views into a NavController
        for tabItem in tabItems{
            // get our view controller
            let rootViewController =  tabItem.viewController
            
            // imbed it into a navigation controller
            let navController = UINavigationController(rootViewController: rootViewController)
            
            // add the navigation controller to our controllers
            controllers.append(navController)
        }
        
        // update our view
        self.view.layoutIfNeeded()
        
        // sent our completion paramaters for our higher function, a list of navigation controllers
        completion(controllers)
        
    }
    
    // changes our selected tab for our TabBarController
    func changeTab(tab: Int) {
            self.selectedIndex = tab
        }
    
    
    // MARK: Layout
    
    // adds the custom bar to our view where our tab bar should be
    func addCustomTabBarToView(_ items: [CustomTabItem]){
        
        
        // sets our tab bar height
        let tabBarHeight: CGFloat = 67.0

        // hide our built in tab bar view
        tabBar.isHidden = true
        
        
        customTabBar = CustomTabBarView(menuItems: items)
        
        // instead of creating a delegate, we set the function of out custom tab bar view to our function
        customTabBar.tabTapped = self.changeTab
        
        self.view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        
        tabBarLeadingConstraint = customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor)
        tabBarLeadingConstraint.isActive = true
    

    }
    
    func addMenuView(){
        menuView = AccountMenuView()
        menuWidth = UIScreen.main.bounds.width - 75
        view.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.heightAnchor.constraint(equalTo: view.heightAnchor),
            menuView.trailingAnchor.constraint(equalTo: customTabBar.leadingAnchor),
            menuView.widthAnchor.constraint(equalToConstant: menuWidth)
        ])
    }
}


// MARK: our custom enum used for creating a tab bar

 enum CustomTabItem: String, CaseIterable {
    case home = "home"
    case search = "search"
    case spaces = "spaces"
    case notifications = "notifications"
    case inbox = "inbox"
    
     /// returns a view controller assoiciated with our enum
    var viewController: UIViewController {
            switch self {
            case .home:
                return HomeViewController()
            case .search:
                return HomeViewController()
            case .spaces:
                return HomeViewController()
            case .notifications:
                return HomeViewController()
            case .inbox:
                return HomeViewController()
            }
        }
    
    /// the icon associated with our enum
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "home_icon")!
        case .spaces:
            return UIImage(named: "microphone_icon")!
        case .search:
            return UIImage(named: "search_icon")!
        case .notifications:
            return UIImage(named: "notifications_icon")!
        case .inbox:
            return UIImage(named: "inbox_icon")!
        }
    }
     
     var selectedIcon: UIImage {
         switch self {
         case .home:
             return UIImage(named: "home_icon_selected")!
         case .search:
             return UIImage(named: "search_icon_selected")!
         case .spaces:
             return UIImage(named: "microphone_icon_selected")!
         case .notifications:
             return UIImage(named: "notifications_icon_selected")!
         case .inbox:
             return UIImage(named: "inbox_icon_selected")!
         }
     }
     
    
var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
    
}

