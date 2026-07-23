//
//  MainViewController.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    
    

    private func calculations() {
        let queue = DispatchQueue(label: "com.AdventOfCode.queue")
        for index in 0..<dayViews.count {
            queue.async {
                let answer1 = self.presenter.calculate(year: self.currentYear, day: index+1, question: 1)
                let answer2 = self.presenter.calculate(year: self.currentYear, day: index+1, question: 2)
                }
            }
        }
    }
    
}

extension MainViewController: DayViewDelegate {
    
    func openDetail(_ year: Year, _ day: Int) {
        presenter.openDetail(year, day)
    }
    
}
