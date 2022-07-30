//
//  AccountMenuView.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/29/22.
//

import UIKit

// the view that is on the side of the app, has all the log in info
class AccountMenuView: UIView {
    
    // our table view that holds our menu items
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor = .clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    let cellID = "menuViewCellID"
    
    let menuTitles = ["Profile", "Lists", "Topics", "Bookmarks", "Twitter Blue", "Moments", "Purchases", "Monotization"]
   
    // a view that goes over our content view
    private let contentShader = UIView()
    
    
    private var topView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    // what to do when the menu view is tapped
    func showMenuView(showMenu: Bool){
        let alpha = showMenu ? 0.73 : 0.0
        
        // animate
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            // set the content shaders alpha according to wether the menu is being opened or closed
            self.contentShader.alpha = alpha
        }
    }
    
    
    // closes the menu when the content shader is tapped
    @objc private func contentShaderTapped(){
        TabBarController.parentController?.showMenu()
    }
  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: Delegates and Protocols

extension AccountMenuView:  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MenuTableCell
        cell.setLabels(title: menuTitles[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}


// MARK: Layout
extension AccountMenuView{
    
    // calls all the methods in our layout extension to set up the views
    private func setUpViews(){
        isUserInteractionEnabled = true
        topView = addTopView()
        addContentShader()
        setUpDividerBars()
        addTableView()
    }
    
    

   private func addContentShader(){
       guard let contentView = TabBarController.parentController?.view else {
           print("null")
           return }
       
       
        contentShader.backgroundColor = #colorLiteral(red: 0.0392, green: 0.1373, blue: 0.1373, alpha: 1) /* #0a2323 */

        contentShader.alpha = 0.0
       contentView.addSubview(contentShader)
        contentShader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentShader.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentShader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentShader.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contentShader.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant:  -67.0)

        ])
       
       contentShader.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.contentShaderTapped)))
    }
    
    // adds the profile image, Name, handler and follower count
    private func addTopView() -> UIView{
        backgroundColor = .black
        
        let topBounds = UIView()
        topBounds.sizeToFit()
        addSubview(topBounds)
        topBounds.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBounds.topAnchor.constraint(equalTo: topAnchor),
            topBounds.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBounds.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
        
        let fontSizeBold = 20.0
        let headerFont = UIFont(name: "Helvetica-Bold", size: fontSizeBold)

        let fontSize = 17.0
        let textFont = UIFont(name: "HelveticaNeue", size: fontSize)
        let textBoldFont = UIFont(name: "Helvetica-Bold", size: fontSize)


        var profileButton = UIButton()
    
        let profileButtonSize: CGFloat = 50
        let profileImage = UIImage(named: "profile_img")
        
        profileButton = UIButton()
        profileButton.setImage(profileImage, for: .normal)
        profileButton.layer.cornerRadius = profileButtonSize / 2
        profileButton.clipsToBounds = true
        profileButton.contentMode = .scaleToFill
        profileButton.sizeToFit()
        
        topBounds.addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: topBounds.topAnchor, constant: 40),
            profileButton.leadingAnchor.constraint(equalTo: topBounds.leadingAnchor, constant: 15),
            profileButton.heightAnchor.constraint(equalToConstant: profileButtonSize),
            profileButton.widthAnchor.constraint(equalToConstant: profileButtonSize)

        ])
        
        let nameLabel = UILabel()
        nameLabel.text = "Software Engineer"
     
        nameLabel.textColor = ProjectThemes.lightGrayColorPT
        nameLabel.sizeToFit()
        nameLabel.font = headerFont
        topBounds.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor),
        ])
        
        let handlerLabel = UILabel()
        handlerLabel.text = "@NeedsMoreCode"
   
        handlerLabel.textColor = ProjectThemes.darkGrayColorPT
        handlerLabel.sizeToFit()
        handlerLabel.font = textFont
        topBounds.addSubview(handlerLabel)
        handlerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handlerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            handlerLabel.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor),
        ])
        
        
        // underneath here we create 4 label views, but this could be simplified with attributed strings with 2 labels
        let followingNumLabel = UILabel()
        followingNumLabel.text = "1"
   
        followingNumLabel.textColor = ProjectThemes.lightGrayColorPT
        followingNumLabel.sizeToFit()
        followingNumLabel.font = textBoldFont
        topBounds.addSubview(followingNumLabel)
        followingNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followingNumLabel.topAnchor.constraint(equalTo: handlerLabel.bottomAnchor, constant: 15),
            followingNumLabel.leadingAnchor.constraint(equalTo: handlerLabel.leadingAnchor),
        ])
        
        let followingLabel = UILabel()
        followingLabel.text = "Following"
   
        followingLabel.textColor = ProjectThemes.darkGrayColorPT
        followingLabel.sizeToFit()
        followingLabel.font = textFont
        topBounds.addSubview(followingLabel)
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followingLabel.bottomAnchor.constraint(equalTo: followingNumLabel.bottomAnchor, constant: 0),
            followingLabel.leadingAnchor.constraint(equalTo: followingNumLabel.trailingAnchor, constant: 3),
        ])
        
        let followersNumLabel = UILabel()
        followersNumLabel.text = "0"
   
        followersNumLabel.textColor = ProjectThemes.lightGrayColorPT
        followersNumLabel.sizeToFit()
        followersNumLabel.font = textBoldFont
        topBounds.addSubview(followersNumLabel)
        followersNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followersNumLabel.bottomAnchor.constraint(equalTo: followingLabel.bottomAnchor),
            followersNumLabel.leadingAnchor.constraint(equalTo: followingLabel.trailingAnchor, constant: 10),
        ])
        
        let followersLabel = UILabel()
        followersLabel.text = "Followers"
   
        followersLabel.textColor = ProjectThemes.darkGrayColorPT
        followersLabel.sizeToFit()
        followersLabel.font = textFont
        topBounds.addSubview(followersLabel)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followersLabel.topAnchor.constraint(equalTo: followersNumLabel.topAnchor, constant: 0),
            followersLabel.leadingAnchor.constraint(equalTo: followersNumLabel.trailingAnchor, constant: 3),
            followersLabel.bottomAnchor.constraint(equalTo: topBounds.bottomAnchor, constant: -10)
        ])
        
        return topBounds
    }
    
    func addTableView(){
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -67.06)
        ])
        
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: cellID)
    }
    
    // creates thin dividers. The better way to do this would be to override draw,using coregraphics
    // will change to draw with stroke() later
    func setUpDividerBars(){
        let divider = UIView()
        divider.backgroundColor = ProjectThemes.darkGrayColorPT
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.topAnchor.constraint(equalTo: bottomAnchor, constant: -67.0),
            divider.heightAnchor.constraint(equalToConstant: 0.25)
        ])
        
        let verticalDivider = UIView()
        verticalDivider.backgroundColor = ProjectThemes.darkGrayColorPT
        addSubview(verticalDivider)
        verticalDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalDivider.topAnchor.constraint(equalTo: topAnchor),
            verticalDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalDivider.widthAnchor.constraint(equalToConstant: 0.25)
        ])
        
        let verticalDividerTop = UIView()
        verticalDividerTop.backgroundColor = ProjectThemes.darkGrayColorPT
        addSubview(verticalDividerTop)
        verticalDividerTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalDividerTop.topAnchor.constraint(equalTo: topView.bottomAnchor),
            verticalDividerTop.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalDividerTop.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalDividerTop.heightAnchor.constraint(equalToConstant: 0.25)
        ])

    }
    
}



// MARK: The Table View Cell Used In our Menu
private class MenuTableCell: UITableViewCell{
    let menuLabel = UILabel()
    let menuIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    public func setLabels(title: String){
        menuLabel.text = title
        
    }
    
    private func setUpView(){
        backgroundColor = .clear
        menuIcon.image = UIImage(named: "home_icon")
        menuIcon.tintColor = ProjectThemes.lightGrayColorPT
        menuIcon.backgroundColor = .clear
        addSubview(menuIcon)
        menuIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            menuIcon.widthAnchor.constraint(equalToConstant: 27),
            menuIcon.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        
        let fontSize = 20.0
        let textBoldFont = UIFont(name: "HelveticaNeue", size: fontSize)
        
        menuLabel.text = "Error"
        menuLabel.textColor = ProjectThemes.lightGrayColorPT
        menuLabel.font = textBoldFont
        menuLabel.sizeToFit()
        addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: menuIcon.trailingAnchor, constant: 15)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
