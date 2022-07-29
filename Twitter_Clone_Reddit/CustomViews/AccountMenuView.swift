//
//  AccountMenuView.swift
//  Twitter_Clone_Reddit
//
//  Created by Brandon Bravos on 7/29/22.
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
    
    
    // a view that goes over our content view
   private let contentShader = UIView()

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
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        
        return cell
    }
    
    
    
}


// MARK: Layout
extension AccountMenuView{
    
    // calls all the methods in our layout extension to set up the views
    private func setUpViews(){
        addTopView()
        addContentShader()
        setUpDividerBars()
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
    
        
    private func addTopView(){
        backgroundColor = .black
        
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
        
        addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            profileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileButton.heightAnchor.constraint(equalToConstant: profileButtonSize),
            profileButton.widthAnchor.constraint(equalToConstant: profileButtonSize)

        ])
        
        let nameLabel = UILabel()
        nameLabel.text = "Software Engineer"
     
        nameLabel.textColor = ProjectThemes.lightGrayColorPT
        nameLabel.sizeToFit()
        nameLabel.font = headerFont
        addSubview(nameLabel)
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
        addSubview(handlerLabel)
        handlerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handlerLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            handlerLabel.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor),
        ])
        
        let followingNumLabel = UILabel()
        followingNumLabel.text = "1"
   
        followingNumLabel.textColor = ProjectThemes.lightGrayColorPT
        followingNumLabel.sizeToFit()
        followingNumLabel.font = textBoldFont
        addSubview(followingNumLabel)
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
        addSubview(followingLabel)
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
        addSubview(followersNumLabel)
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
        addSubview(followersLabel)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followersLabel.bottomAnchor.constraint(equalTo: followersNumLabel.bottomAnchor, constant: 0),
            followersLabel.leadingAnchor.constraint(equalTo: followersNumLabel.trailingAnchor, constant: 3),
        ])
        
        
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
    }
    
}
