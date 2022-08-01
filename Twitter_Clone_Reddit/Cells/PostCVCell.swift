//
//  PostCVCell.swift
//  Twitter_Clone_Reddit
//
//  Created by NeedsMoreCoffeee on 7/26/22.
//

import UIKit

class PostCVCell: UICollectionViewCell {
    
    let profileImageView = UIImageView()
    let postTextLabel = UILabel()
    let postLeadingConstant = 10.0

    var postImageLeadingInset: NSLayoutXAxisAnchor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCellView()
    }
    
    
    
    // MARK: - Methods:
    
    func setUpCellView(){
        
        let profileImageSize = 50.0
        profileImageView.image = UIImage(named: "apple_logo")
        profileImageView.layer.cornerRadius = profileImageSize / 2
        profileImageView.clipsToBounds = true
        
        
       addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: postLeadingConstant * 3),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: postLeadingConstant),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageSize)

        ])
        
        postImageLeadingInset = profileImageView.trailingAnchor
        
        setUpPostTitles()
        
        
    
        
        
        
    }
    
    
    func setUpPostTitles(){
        
        
        let fontSizeBold = 18.0
        let fontSize = 17.0

        let headerFont = UIFont(name: "HelveticaNeue-Bold", size: fontSizeBold)
        let textFont = UIFont(name: "HelveticaNeue", size: fontSize)

        

        let postProfileTitelLabel = UILabel()
        postProfileTitelLabel.font = headerFont
        postProfileTitelLabel.text = "Apple"
        postProfileTitelLabel.textColor = ProjectThemes.lightGrayColorPT
        postProfileTitelLabel.sizeToFit()
        
        
        let postProfileHandlerlLabel = UILabel()
        postProfileHandlerlLabel.text = "@Apple"
        postProfileHandlerlLabel.font = textFont
        postProfileHandlerlLabel.textColor = ProjectThemes.darkGrayColorPT
        postProfileHandlerlLabel.sizeToFit()
        
        let postTimeLabel = UILabel()
        postTimeLabel.font = textFont
        postTimeLabel.text = "- 6/6/22"
        postTimeLabel.textColor = ProjectThemes.darkGrayColorPT
        postTimeLabel.sizeToFit()
        
        
        let andMoreLabel = UILabel()
        andMoreLabel.font = headerFont
        andMoreLabel.text = "..."
        andMoreLabel.textColor = ProjectThemes.darkGrayColorPT
        andMoreLabel.sizeToFit()
        
        postTextLabel.text = """
        The new MacBook Air. Supercharged by M2. With an impossibly thin design. All day battery life*. And a stunning 12.6 Liquid Retina display. Don't take it lightly. Coming next month. *Battery life varied by use
        """
        
        postTextLabel.textColor = ProjectThemes.lightGrayColorPT
        postTextLabel.font = textFont
        postTextLabel.numberOfLines = 0
        postTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        postTextLabel.sizeToFit()
            
        addSubview(postProfileTitelLabel)
        postProfileTitelLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            postProfileTitelLabel.topAnchor.constraint(equalTo: topAnchor, constant: postLeadingConstant),
            postProfileTitelLabel.leadingAnchor.constraint(equalTo: postImageLeadingInset, constant: postLeadingConstant),
           // postProfileTitelLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
         ])
        
        addSubview(postProfileHandlerlLabel)
        postProfileHandlerlLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            postProfileHandlerlLabel.bottomAnchor.constraint(equalTo: postProfileTitelLabel.bottomAnchor),
            postProfileHandlerlLabel.leadingAnchor.constraint(equalTo: postProfileTitelLabel.trailingAnchor, constant: 5),
         ])
        
        
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            postTimeLabel.bottomAnchor.constraint(equalTo: postProfileHandlerlLabel.bottomAnchor),
            postTimeLabel.leadingAnchor.constraint(equalTo: postProfileHandlerlLabel.trailingAnchor, constant: 5)
         ])
        
        addSubview(andMoreLabel)
        andMoreLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            andMoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: postLeadingConstant),
            andMoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -postLeadingConstant),
         ])
        
        addSubview(postTextLabel)
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            postTextLabel.topAnchor.constraint(equalTo: postProfileTitelLabel.bottomAnchor, constant: 2),
            postTextLabel.leadingAnchor.constraint(equalTo: postProfileTitelLabel.leadingAnchor),
            postTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -postLeadingConstant)
         ])
        
       
  

        

        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
