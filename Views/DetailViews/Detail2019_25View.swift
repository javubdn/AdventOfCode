//
//
//

import UIKit

class Detail2019_25View: UIView {
    
    private let instructionsLabel = UILabel()
    private let answerTextView = UITextField()
    private var intcode: Intcode? = nil
    
    init(_ mainStackView: UIStackView) {
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initializeComputer() {
        guard let filepath = Bundle.main.path(forResource: "InputYear2019Day25", ofType: "csv") else { return }
        do {
            let input = try String(contentsOfFile: filepath, encoding: .utf8).components(separatedBy: ",").map { Int($0)! }
            intcode?.addInput(asciiProgram)
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
}
