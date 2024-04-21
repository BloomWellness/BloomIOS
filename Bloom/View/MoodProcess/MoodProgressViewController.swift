

import Foundation
import UIKit
import SwiftUI
import Charts
import DGCharts

import CoreCharts

class MoodProgressViewController: UIViewController { // CoreChartViewDataSource

//    func loadCoreChartData() -> [CoreChartEntry] {
//
//            var allCityData = [CoreChartEntry]()
//        
//            let cityNames = ["Istanbul","Antalya","Ankara","Trabzon","İzmir"]
//        
//            let plateNumber = [34,07,06,61,35]
//            
//            for index in 0..<cityNames.count {
//                
//                let newEntry = CoreChartEntry(id: "\(plateNumber[index])",
//                                              barTitle: cityNames[index],
//                                              barHeight: Double(plateNumber[index]),
//                                              barColor: rainbowColor())
//                                              
//                                              
//                allCityData.append(newEntry)
//                
//            }
//            
//            return allCityData
//    }
//    
    var moods: [MoodScore] = [
        MoodScore(value: 22, month: "Jan", emoji: "🙂"),
        MoodScore(value: 12, month: "Feb", emoji: "🙂"),
        MoodScore(value: 52, month: "March", emoji: "🙂"),
        MoodScore(value: 72, month: "April", emoji: "🙂"),
        MoodScore(value: 31, month: "May", emoji: "🙂"),
        MoodScore(value: 2, month: "Jun", emoji: "🙂"),
        MoodScore(value: 42, month: "July", emoji: "🙂"),
        MoodScore(value: 66, month: "Aug", emoji: "🙂"),
        MoodScore(value: 17, month: "Sep", emoji: "🙂"),
        MoodScore(value: 31, month: "Oct", emoji: "🙂"),
        MoodScore(value: 87, month: "Nov", emoji: "🙂"),
        MoodScore(value: 27, month: "Dec", emoji: "🙂")
    ]
    
    var journalHightlights: [MoodJournalHightLigh] = [MoodJournalHightLigh(title: "Sources of Hope", description: "Today, I reflected on what keeps me hopeful. Family support, personal growth, and my future goals are at the top of my list.", image: UIImage(named: "mood_cell")!, date: "08/08/2023"),
                                                      MoodJournalHightLigh(title: "Self-Care Strategies", description: "I'm focusing on a regular routine, staying connected with loved ones. 😄", image: UIImage(named: "mood_cell")!, date: "08/08/2023")]
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let yAxisImage: [String] = ["good", "sad", "shocked", "angry"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        chartView.dataSource = self
        addChartView()
      
        
        let nibTableViewCell = UINib(nibName: Constant.CellID.MoodJournalTableViewCell, bundle: Bundle.main)
        tableView.register(nibTableViewCell, forCellReuseIdentifier: Constant.CellID.MoodJournalTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    func addChartView() {
        let swiftUIView = chartViewSwiftUI
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.view.backgroundColor = .bg
        chartView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: chartView.topAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: chartView.leftAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: chartView.rightAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
    
    
    var chartViewSwiftUI: some View {
        HStack(alignment: .center) {
            VStack {
                ForEach(yAxisImage, id: \.self) { value in
                    Spacer()
                    Image(value)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.vertical)
                    Spacer()
                }
            }
            .frame(height: 270)
            Chart {
                ForEach(moods, id: \.month) { mood in
                    BarMark(
                        x: .value("Month", mood.month),
                        y: .value("Value", mood.value)
                    )
                    .foregroundStyle(by: .value("Mood", "Mood Score"))
                    
                    .annotation(position: .automatic) {
                        Text("\(mood.value)")
                    }
                }
            }
            .chartYAxis(.hidden)
            .frame(height: 270)
            .chartYScale(domain: 0...100) // Assuming your values are between 0 and 100
        }
    }
}

extension MoodProgressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalHightlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellID.MoodJournalTableViewCell, for: indexPath) as? MoodJournalTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if indexPath.row == 1 {
            cell.moodCellImage.isHidden = true
        }
        cell.moodTitle.text = journalHightlights[indexPath.row].title
        cell.moodDescription.text = journalHightlights[indexPath.row].description
        cell.moodCellImage.image = journalHightlights[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 132
        } else {
            return 252
        }
    }
}
