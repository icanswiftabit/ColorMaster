//
//  ColorView.swift
//  ColorMaster
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit



class ColorView: UIView {
    
    let displayNameLabel = UILabel()
    let peersNamesLabel = UILabel()
    let redButtom = UIButton(type: .custom)
    let greenButtom = UIButton(type: .custom)
    let blueButtom = UIButton(type: .custom)
    let logView = UITextView()
    init() {
        super.init(frame: .zero)
        layout()
        decorate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension ColorView {
    func decorate() {
        backgroundColor = .white
        
        [displayNameLabel, peersNamesLabel].forEach {
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
        }
        
        redButtom.backgroundColor = .red
        greenButtom.backgroundColor = .green
        blueButtom.backgroundColor = .blue
        
        logView.textAlignment = .left
        logView.allowsEditingTextAttributes = false
        logView.isEditable = false
        logView.isSelectable = false
        logView.isScrollEnabled = false
        logView.font = UIFont.systemFont(ofSize: 14)
    }
    
    func layout() {
        
        addSubview(displayNameLabel)
        addSubview(peersNamesLabel)
        addSubview(redButtom)
        addSubview(greenButtom)
        addSubview(blueButtom)
        addSubview(logView)
        
        translatesAutoresizingMaskIntoConstraints = false
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        displayNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        displayNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        displayNameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        displayNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        peersNamesLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 8).isActive = true
        peersNamesLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        peersNamesLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        peersNamesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        [redButtom,greenButtom,blueButtom].forEach {
            $0.topAnchor.constraint(equalTo: peersNamesLabel.bottomAnchor, constant: 2).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        greenButtom.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        greenButtom.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        redButtom.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        redButtom.trailingAnchor.constraint(equalTo: greenButtom.leadingAnchor).isActive = true
        blueButtom.leadingAnchor.constraint(equalTo: greenButtom.trailingAnchor).isActive = true
        blueButtom.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        logView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        logView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        logView.topAnchor.constraint(equalTo: greenButtom.bottomAnchor, constant: 8).isActive = true
    }
}
