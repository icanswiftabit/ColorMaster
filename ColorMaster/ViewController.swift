//
//  ViewController.swift
//  ColorMaster
//
//  Created by Blazej Wdowikowski on 07/09/2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum Color {
    case red, green, blue
}

class ViewController: UIViewController{

    var provider: ColorServiceProvider!
    var viewModel = ViewModel()
    let colorView = ColorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallbacks()
        setupButtons()
    }
    
    override func loadView() {
        view = colorView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupName()
    }
}

fileprivate extension ViewController {
    func setupName() {
        var inputTextField: UITextField?
        let alert = UIAlertController(title: "Display name", message: "What's your name?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            guard let displayName = inputTextField?.text, !displayName.isEmpty else {
                self.setupName()
                return
            }
            self.viewModel.displayName = displayName
            self.provider = ColorServiceProvider(with: displayName)
            self.provider.delegate = self
        }))
        
        alert.addTextField(configurationHandler: { (textField) in
            inputTextField = textField
        })
        
        present(alert, animated: true)
    }
    
    func setupCallbacks() {
        viewModel.onDisplayNameChanged = { [weak self] in
            self?.colorView.displayNameLabel.text = "You're: \($0!)"
        }
        
        viewModel.onPeersNamesChanged = { [weak self] in
            guard $0.count > 0 else {
                self?.colorView.peersNamesLabel.text = "Searching..."
                return
            }
            
            var textForLabel = "Connected with: "
            for name in $0 {
                textForLabel.append("\(name), ")
            }
            let range = textForLabel.index(textForLabel.endIndex, offsetBy: -2)..<textForLabel.endIndex
            textForLabel.removeSubrange(range)
            self?.colorView.peersNamesLabel.text = textForLabel
        }
        
        viewModel.onLogEntryWasAdded = { [weak self] entries in
            guard let textView = self?.colorView.logView, let lastEntry = entries.last else { return }
            textView.text.append("\(lastEntry)\n")
        }
        
        colorView.peersNamesLabel.text = "Searching..."
    }
    
    func setupButtons() {
        [colorView.redButtom, colorView.greenButtom, colorView.blueButtom].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton?) {
        guard let button = sender, let color = button.backgroundColor else { return }
        do {
            try provider.send(color)
            handle(color)
        } catch let error {
            show(error)
        }
    }
    
    func show(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "Error with sending the color", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func handle(_ color: UIColor) {
        self.colorView.backgroundColor = color
    }
}

extension ViewController: ColorServiceProviderDelegate {
    func provider(_ provider: ColorServiceProvider, listOfConnectedPeersHasChanged list: [String]) {
        DispatchQueue.main.async {
            self.viewModel.peersNames = list
        }
    }
    
    func provider(_ provider: ColorServiceProvider, didReceived color: UIColor, from peer: String) {
        DispatchQueue.main.async {
            self.handle(color)
            var colorName = ""
            if color == UIColor.red {
                colorName = "red"
            } else if color == UIColor.green {
                colorName = "green"                
            } else if color == UIColor.blue {
                colorName = "blue"
            }
            self.viewModel.addLog(LogEntry(name: peer, date: Date(), message: "has changed the color to \(colorName)"))
        }
    }
}
