//
//  Detail2019_25View.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 28/6/22.
//

import UIKit

class Detail2019_25View: UIView {
    
    private let instructionsLabel = UILabel()
    private let answerTextView = UITextField()
    private var intcode: Intcode? = nil
    
    init(_ mainStackView: UIStackView) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 800))
        layer.borderWidth = 2
        layer.borderColor = .init(red: 0, green: 0.2, blue: 0.7, alpha: 1)
        layer.cornerRadius = 5

        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        instructionsLabel.font = UIFont(name: "Futura-Medium", size: 20.0)
        
        answerTextView.text = "Comando"
        answerTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        answerTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        answerTextView.textColor = .lightGray
        answerTextView.delegate = self
        answerTextView.returnKeyType = .done
        
        let actionButton = UIButton()
        actionButton.setTitle("Enviar comando", for: .normal)
        actionButton.setTitleColor(.blue, for: .normal)
        actionButton.addTarget(self, action: #selector(sendCommand), for: .touchUpInside)
        
        let vStackView = UIStackView(arrangedSubviews: [instructionsLabel, answerTextView, actionButton])
        vStackView.axis = .vertical
        vStackView.spacing = 15
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
        
        mainStackView.addArrangedSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeComputer() {
        guard let filepath = Bundle.main.path(forResource: "InputYear2019Day25", ofType: "csv") else { return }
        do {
            let input = try String(contentsOfFile: filepath, encoding: .utf8).components(separatedBy: ",").map { Int($0)! }
            intcode = Intcode(instructions: input)
            let asciiProgram = "\n".asciiValues.map { Int($0) }
            intcode?.addInput(asciiProgram)
            intcode?.execute()
            let output = intcode!.readOutput()
            let lines = output.map { value in
                guard value < UInt8.max else {
                    return String(value)
                }
                return String(UnicodeScalar(UInt8(value)))
            }
                .joined()
                .trimmingCharacters(in: .newlines)
            instructionsLabel.text = lines
        }
        catch {
            return
        }
    }
    
    @objc
    private func sendCommand(sender: UIButton) {
        guard let text = answerTextView.text else { return }
        let asciiProgram = (text.lowercased() + "\n").asciiValues.map { Int($0) }
        intcode?.addInput(asciiProgram)
        intcode?.execute()
        let output = intcode!.readOutput()
        let lines = output.map { value in
            guard value < UInt8.max else {
                return String(value)
            }
            return String(UnicodeScalar(UInt8(value)))
        }
            .joined()
            .trimmingCharacters(in: .newlines)
        instructionsLabel.text = lines
    }
    
}

extension Detail2019_25View: UITextFieldDelegate {
    
    private func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comando"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = answerTextView.text else { return false }
        let asciiProgram = (text.lowercased() + "\n").asciiValues.map { Int($0) }
        intcode?.addInput(asciiProgram)
        intcode?.execute()
        let output = intcode!.readOutput()
        let lines = output.map { value in
            guard value < UInt8.max else {
                return String(value)
            }
            return String(UnicodeScalar(UInt8(value)))
        }
            .joined()
            .trimmingCharacters(in: .newlines)
        instructionsLabel.text = lines
        textField.text = nil
        return true
    }
    
}

