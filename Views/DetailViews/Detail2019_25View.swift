//
//
//

import UIKit

class Detail2019_25View: UIView {
    
    private let instructionsLabel = UILabel()
    private let answerTextView = UITextField()
    private var intcode: Intcode? = nil
    
    init(_ mainStackView: UIStackView) {
        
        
        
        
        
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

