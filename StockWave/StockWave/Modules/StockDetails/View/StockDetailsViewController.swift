//
//  StockDetailsViewController.swift
//  StockWave
//
//  Created by rauan on 4/28/24.
//

import UIKit
import Charts
import DGCharts
import CoreData

class StockDetailsViewController: UIViewController, ChartViewDelegate {
    
    var lineChartEntries: [ChartDataEntry] = []
    var barChartDataEntry: [BarChartDataEntry] = []
    var incomeChartDataEntry: [BarChartDataEntry] = []
    var rdChartDataEntry: [BarChartDataEntry] = []
    var sharesChartDataEntry: [BarChartDataEntry] = []
	  private var favouriteStocks: [NSManagedObject] = []
    
    private var viewModel: DetailsViewModel?
    var details: HomeStocksDataModel?
    var companyInformationData: CompanyInformationResponse?
    var tickerData: [Historical] = []
    var takeDay: Bool = true
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var pricesStack: UIStackView = {
        let pricesStack = UIStackView()
        pricesStack.axis = .horizontal
        pricesStack.distribution = .equalSpacing
        pricesStack.alignment = .center
        return pricesStack
    }()
    
    private lazy var historyStack: UIStackView = {
        let historyStack = UIStackView()
        historyStack.axis = .vertical
        historyStack.distribution = .fill
        historyStack.alignment = .leading
        historyStack.spacing = 4
        return historyStack
    }()
    private lazy var historyPrice: UILabel = {
        let historyLabel = UILabel()
        historyLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        historyLabel.textColor = .black
        
        return historyLabel
    }()
    private lazy var historyChange: UILabel = {
        let historyChange = UILabel()
        historyChange.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        historyChange.textColor = UIColor(red: 89.0/255.0, green: 85.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        return historyChange
    }()
    
    private lazy var currentStack: UIStackView = {
        let currentStack = UIStackView()
        currentStack.axis = .vertical
        currentStack.distribution = .equalSpacing
        currentStack.spacing = 4
        currentStack.alignment = .trailing
        return currentStack
    }()
    private lazy var currentPrice: UILabel = {
        let currentPrice = UILabel()
        currentPrice.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        currentPrice.textColor = .black
        currentPrice.textAlignment = .right
        currentPrice.text = "$\(String(format: "%.2f", details?.companyPrice ?? 0.0))"
        return currentPrice
    }()
    private lazy var currentChange: UILabel = {
        let currentChange = UILabel()
        currentChange.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        currentChange.textColor = UIColor(red: 89.0/255.0, green: 85.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        if details?.companyChange ?? 0.0 >= 0 {
            currentChange.text = "+\(String(format: "%.2f", details?.companyChange ?? 0.0))"
        } else {
            currentChange.text = "\(String(format: "%.2f", details?.companyChange ?? 0.0))"
        }
        currentChange.text?.append(" (\(String(format: "%.2f", details?.companyChangePercentage ?? 0.0))%)")
        currentChange.textAlignment = .right
        return currentChange
    }()
    
    private lazy var chart: LineChartView = {
        let chart = LineChartView()
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.minOffset = 0
        chart.delegate = self
        return chart
    }()
    
    private lazy var oneDay: UIButton = {
        let oneDay = UIButton()
        oneDay.setTitle("1D", for: .normal)
        oneDay.setTitleColor(.mainPurple, for: .normal)
        oneDay.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        oneDay.layer.cornerRadius = 6
        oneDay.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        oneDay.addTarget(self, action: #selector(didTapOneDay), for: .touchUpInside)
        return oneDay
    }()
    
    private lazy var oneWeek: UIButton = {
        let oneWeek = UIButton()
        oneWeek.setTitle("1W", for: .normal)
        oneWeek.setTitleColor(.gray, for: .normal)
        oneWeek.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        oneWeek.layer.cornerRadius = 6
        oneWeek.addTarget(self, action: #selector(didTapOneWeek), for: .touchUpInside)
        return oneWeek
    }()
    
    private lazy var oneMonth: UIButton = {
        let oneMonth = UIButton()
        oneMonth.setTitle("1M", for: .normal)
        oneMonth.setTitleColor(.gray, for: .normal)
        oneMonth.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        oneMonth.layer.cornerRadius = 6
        oneMonth.addTarget(self, action: #selector(didTapOneMonth), for: .touchUpInside)
        return oneMonth
    }()
    
    private lazy var oneYear: UIButton = {
        let oneYear = UIButton()
        oneYear.setTitle("1Y", for: .normal)
        oneYear.setTitleColor(.gray, for: .normal)
        oneYear.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        oneYear.layer.cornerRadius = 6
        oneYear.addTarget(self, action: #selector(didTapOneYear), for: .touchUpInside)
        return oneYear
    }()
    
    private lazy var fiveYears: UIButton = {
        let fiveYears = UIButton()
        fiveYears.setTitle("5Y", for: .normal)
        fiveYears.setTitleColor(.gray, for: .normal)
        fiveYears.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        fiveYears.layer.cornerRadius = 6
        fiveYears.addTarget(self, action: #selector(didTapFiveYears), for: .touchUpInside)
        return fiveYears
    }()
    
    private lazy var allHistroy: UIButton = {
        let allHistroy = UIButton()
        allHistroy.setTitle("ALL", for: .normal)
        allHistroy.setTitleColor(.gray, for: .normal)
        allHistroy.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        allHistroy.layer.cornerRadius = 6
        allHistroy.addTarget(self, action: #selector(didTapAllHistory), for: .touchUpInside)
        return allHistroy
    }()
    
    private lazy var timelineStack: UIStackView = {
        let timelineStack = UIStackView()
        timelineStack.axis = .horizontal
        timelineStack.distribution = .fillProportionally
        timelineStack.spacing = 8
        return timelineStack
    }()
    let items = ["Overview", "Financials", "News"]
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentTintColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.8)
        segmentedControl.addTarget(self, action: #selector(didChangedControl), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var companyDescription: UILabel = {
        let companyDescription = UILabel()
        companyDescription.font = UIFont.systemFont(ofSize: 14)
        companyDescription.numberOfLines = 0
        return companyDescription
    }()
    
    private lazy var barChart: BarChartView  = {
        let barChart = BarChartView()
        barChart.isHidden = true
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.rightAxis.enabled = false
        barChart.drawBordersEnabled = false
        barChart.minOffset = 0
        return barChart
    }()
    
    private lazy var incomeChart: BarChartView  = {
        let incomeChart = BarChartView()
        incomeChart.isHidden = true
        incomeChart.xAxis.drawGridLinesEnabled = false
        incomeChart.leftAxis.drawGridLinesEnabled = false
        incomeChart.rightAxis.drawGridLinesEnabled = false
        incomeChart.drawGridBackgroundEnabled = false
        incomeChart.rightAxis.drawLabelsEnabled = false
        incomeChart.pinchZoomEnabled = false
        incomeChart.doubleTapToZoomEnabled = false
        incomeChart.xAxis.labelPosition = .bottom
        incomeChart.rightAxis.enabled = false
        incomeChart.drawBordersEnabled = false
        incomeChart.minOffset = 0
        return incomeChart
    }()
    
    private lazy var rdChart: BarChartView = {
        rdChart = BarChartView()
        rdChart.isHidden = true
        rdChart.xAxis.drawGridLinesEnabled = false
        rdChart.leftAxis.drawGridLinesEnabled = false
        rdChart.rightAxis.drawGridLinesEnabled = false
        rdChart.drawGridBackgroundEnabled = false
        rdChart.rightAxis.drawLabelsEnabled = false
        rdChart.pinchZoomEnabled = false
        rdChart.doubleTapToZoomEnabled = false
        rdChart.xAxis.labelPosition = .bottom
        rdChart.rightAxis.enabled = false
        rdChart.drawBordersEnabled = false
        rdChart.minOffset = 0
        return rdChart
    }()
    
    private lazy var sharesChart: BarChartView = {
        let sharesChart = BarChartView()
        sharesChart.isHidden = true
        sharesChart.xAxis.drawGridLinesEnabled = false
        sharesChart.leftAxis.drawGridLinesEnabled = false
        sharesChart.rightAxis.drawGridLinesEnabled = false
        sharesChart.drawGridBackgroundEnabled = false
        sharesChart.rightAxis.drawLabelsEnabled = false
        sharesChart.pinchZoomEnabled = false
        sharesChart.doubleTapToZoomEnabled = false
        sharesChart.xAxis.labelPosition = .bottom
        sharesChart.rightAxis.enabled = false
        sharesChart.drawBordersEnabled = false
        sharesChart.minOffset = 0
        return sharesChart
    }()
    
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		loadStocksFromWatchList()
		setupViewModel()
		buttonColorViewDidLoad()
		sutupViews()
	}
	
	// MARK: - Core
	
	private func loadStocksFromWatchList() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stocks")
		do {
			favouriteStocks = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. Error: \(error)")
		}
	}
	
	private func saveStocksFromWatchList(with name: String, symbol: String) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext
		
		guard let entity = NSEntityDescription.entity(
			forEntityName: "Stocks",
			in: managedContext
		) else { return }
		
		let favoriteStock = NSManagedObject(entity: entity, insertInto: managedContext)
		favoriteStock.setValue(name, forKey: "name")
		favoriteStock.setValue(symbol, forKey: "symbol")
	//	favoriteStock.setValue(image, forKey: "image")
		
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. Error: \(error)")
		}
	}
	
	private func deleteStocksFromWatchList(with name: String, symbol: String) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let manageContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stocks")
		let predicate1 = NSPredicate(format: "name == %@", name)
		let predicate2 = NSPredicate(format: "symbol == %@", symbol)
	//	let predicate3 = NSPredicate(format: "image == %@", image)
		let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2])
		fetchRequest.predicate = predicateAll
		
		do {
			let results = try manageContext.fetch(fetchRequest)
			let data = results.first
			if let data {
				manageContext.delete(data)
			}
			try manageContext.save()
		} catch let error as NSError {
			print("Could not save. Error \(error)")
		}
	}
    
	func buttonColorViewDidLoad() {
		let isFavouritestock = !self.favouriteStocks.filter({ ($0.value(forKey: "symbol") as? String) == self.details?.companyTicker}).isEmpty
//		if isFavouriteMovie {
//			addToWatchListButton.backgroundColor = .red
//			addToWatchListButton.setTitle("Remove from Watch List", for: .normal)
//		} else {
//			addToWatchListButton.backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
//			addToWatchListButton.setTitle("Add To Watch List", for: .normal)
//		}
	}
//	(with name: String, symbol: String, image: String)
	private func toggleButton() {
		
		loadStocksFromWatchList()
		let isFavouritestock = !self.favouriteStocks.filter({ ($0.value(forKey: "symbol") as? String) == self.details?.companyTicker}).isEmpty

		if !isFavouritestock {
	//		addToWatchListButton.backgroundColor = .red
	//		addToWatchListButton.setTitle("Remove from Watch List", for: .normal)
			saveStocksFromWatchList(with: details?.companyName ?? "", symbol: details?.companyTicker ?? "")
		} else {
		//	addToWatchListButton.backgroundColor = #colorLiteral(red: 0.1011425927, green: 0.2329770327, blue: 0.9290834069, alpha: 1)
	//		addToWatchListButton.setTitle("Add To Watch List", for: .normal)
			deleteStocksFromWatchList(with: details?.companyName ?? "", symbol: details?.companyTicker ?? "")
			
//			if hideDetail == true {
//				self.navigationController?.popViewController(animated: true)
//			}
		}

	}
    func sutupViews() {
        navigationItem.title = details?.companyName
        setupNavBar()
         
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [pricesStack, 
         chart,
         timelineStack,
         segmentedControl,
         companyDescription,
         barChart,
         incomeChart,
         rdChart,
         sharesChart].forEach {
            contentView.addSubview($0)
        }
        
        [historyStack, currentStack].forEach {
            pricesStack.addArrangedSubview($0)
        }
        [historyPrice, historyChange].forEach {
            historyStack.addArrangedSubview($0)
        }
        [currentPrice, currentChange].forEach {
            currentStack.addArrangedSubview($0)
        }
        
        
        
        [oneDay, oneWeek, oneMonth, oneYear, fiveYears, allHistroy].forEach {
            timelineStack.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            
        }
        
        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        
        pricesStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        chart.snp.makeConstraints {
            $0.top.equalTo(pricesStack.snp.bottom).offset(12)
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        timelineStack.snp.makeConstraints { make in
            make.top.equalTo(chart.snp.bottom).offset(12)
            make.height.equalTo(30)
            make.left.right.equalToSuperview().inset(16)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(timelineStack.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        companyDescription.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
//            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        barChart.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.width.equalToSuperview()
            make.height.equalTo(300)
            
        }
        incomeChart.snp.makeConstraints { make in
            make.top.equalTo(barChart.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(300)
            
        }
        rdChart.snp.makeConstraints { make in
            make.top.equalTo(incomeChart.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(300)
            
        }
        sharesChart.snp.makeConstraints { make in
            make.top.equalTo(rdChart.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
    }
    
    func setupViewModel() {
        lineChartEntries = []
        viewModel = DetailsViewModel()
        guard let tickerSymbol = details?.companyTicker else { return }
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let beforeToday = dateFormatter.string(from: yesterday!)
        
        viewModel?.getDailyCharts(ticker: tickerSymbol, from: beforeToday, to: beforeToday, completion: { dailyData in
            self.tickerData = dailyData
            
            DispatchQueue.main.async {
                for i in 0...dailyData.count - 1 {
                    self.lineChartEntries.append(.init(x: Double(i), y: dailyData[i].open ?? 1.0))
                }
                
                self.historyPrice.text = "$\(String(format: "%.2f", dailyData[0].open ?? 0.0))"
                let difference = (self.details?.companyPrice ?? 0.0) - (dailyData[0].open ?? 0.0)
                let differenceInPercentage = (difference * 100) / (self.details?.companyPrice ?? 0.0)
                
                if difference >= 0 {
                    self.historyChange.text = "+\(String(format: "%.2f", difference)) (\(String(format: "%.2f", differenceInPercentage))%)"
                } else {
                    self.historyChange.text = "\(String(format: "%.2f", difference)) (\(String(format: "%.2f", differenceInPercentage))%)"
                }
                self.configureChart()
            }
        })
        
        viewModel?.getCompanyInformation(ticker: tickerSymbol, completion: { companyInformation in
            DispatchQueue.main.async {
                self.companyDescription.text = companyInformation.description
                self.companyInformationData = companyInformation
            }
        })
        
        viewModel?.getCompanyFinancialInformation(ticker: tickerSymbol, completion: { financialInformation in
            DispatchQueue.main.async {
                for i in 0...financialInformation.count - 1 {
                    self.barChartDataEntry.append(.init(x: Double(i), y: financialInformation[i].revenue ?? 1.0))
                    self.incomeChartDataEntry.append(.init(x: Double(i), y: financialInformation[i].netIncome ?? 1.0))
                    self.rdChartDataEntry.append(.init(x: Double(i), y: financialInformation[i].researchAndDevelopmentExpenses ?? 1.0))
                    self.sharesChartDataEntry.append(.init(x: Double(i), y: financialInformation[i].weightedAverageShsOut ?? 1.0))
                    
                }
                self.configureBarChart()
                self.configureIncomeBarChart()
                self.configureRdBarChart()
                self.configureSharesChart()
            }
        })
    }
    
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        
        let watchlistButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(didTapWatchlistButton))
        navigationItem.rightBarButtonItem = watchlistButton
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureSharesChart() {
        let dataSet = BarChartDataSet(entries: sharesChartDataEntry, label: "Shares outstanding last 5 years")
        let data = BarChartData(dataSet: dataSet)
        sharesChart.data = data
        
    }
    
    private func configureRdBarChart() {
        let dataSet = BarChartDataSet(entries: rdChartDataEntry, label: "R&D budget last 5 years")
        let data = BarChartData(dataSet: dataSet)
        rdChart.data = data
        
    }

    private func configureBarChart() {
        let dataSet = BarChartDataSet(entries: barChartDataEntry, label: "Revenue last 5 years")
        let data = BarChartData(dataSet: dataSet)
        barChart.data = data
        
    }
    private func configureIncomeBarChart() {
        let dataSet = BarChartDataSet(entries: incomeChartDataEntry, label: "Net Income last 5 years")
        let data = BarChartData(dataSet: dataSet)
        incomeChart.data = data
        
    }
    
    func configureChart() {
        let dataSet = LineChartDataSet(entries: lineChartEntries)
        dataSet.circleRadius = 1
        dataSet.mode = .cubicBezier
        let data = LineChartData(dataSet: dataSet)
        chart.data = data
        
        let x = chart.xAxis
        x.labelCount = 5
        x.granularity = 1
        x.axisMinimum = 0
        x.valueFormatter = self
    }
    @objc
    private func didChangedControl(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            barChart.isHidden = true
            incomeChart.isHidden = true
            rdChart.isHidden = true
            sharesChart.isHidden = true
            companyDescription.isHidden = false
        case 1:
            barChart.isHidden = false
            incomeChart.isHidden = false
            rdChart.isHidden = false
            sharesChart.isHidden = false
            companyDescription.isHidden = true
            
        default:
            barChart.isHidden = true
            incomeChart.isHidden = true
            rdChart.isHidden = true
            sharesChart.isHidden = true
            companyDescription.isHidden = true
        }
    }
    
    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didTapWatchlistButton() {
			toggleButton()
        print("added to watchlist")
    }
    
    @objc
    func didTapOneDay() {
        takeDay = true
        
        oneDay.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        oneDay.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        oneDay.setTitleColor(.mainPurple, for: .normal)
        [oneWeek, oneMonth, oneYear, fiveYears, allHistroy].forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.gray, for: .normal)
        }
        
        setupViewModel()
    }
    
    @objc
    func didTapOneWeek() {
        takeDay = false
        oneWeek.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        oneWeek.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        oneWeek.setTitleColor(.mainPurple, for: .normal)
        [oneDay, oneMonth, oneYear, fiveYears, allHistroy].forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.gray, for: .normal)
        }
        
        gettingDataAcordingToDate(from: 7)
        
    }
    
    @objc
    func didTapOneMonth() {
        takeDay = false
        oneMonth.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        oneMonth.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        oneMonth.setTitleColor(.mainPurple, for: .normal)
        [oneDay, oneWeek, oneYear, fiveYears, allHistroy].forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.gray, for: .normal)
        }
        
        gettingDataAcordingToDate(from: 30)
    }
    
    @objc
    func didTapOneYear() {
        takeDay = false
        oneYear.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        oneYear.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        oneYear.setTitleColor(.mainPurple, for: .normal)
        [oneDay, oneWeek, oneMonth, fiveYears, allHistroy].forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.gray, for: .normal)
        }
        
        gettingDataAcordingToDate(from: 365)
    }
    
    @objc
    func didTapFiveYears() {
        takeDay = false
        fiveYears.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        fiveYears.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        fiveYears.setTitleColor(.mainPurple, for: .normal)
        [oneDay, oneWeek, oneMonth, oneYear, allHistroy].forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.gray, for: .normal)
        }
        gettingDataAcordingToDate(from: 1825)
        
    }
    
    @objc
    func didTapAllHistory() {
        lineChartEntries = []
        takeDay = false
        allHistroy.backgroundColor = UIColor(red: 197.0/255.0, green: 203.0/255.0, blue: 236.0/255.0, alpha: 0.5)
        allHistroy.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        allHistroy.setTitleColor(.mainPurple, for: .normal)
        [oneDay, oneWeek, oneMonth, oneYear, fiveYears].forEach {
            $0.backgroundColor = .clear
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.setTitleColor(.gray, for: .normal)
        }
        guard let tickerSymbol = details?.companyTicker else { return }
        
        viewModel?.getWeeklyCharts(ticker: tickerSymbol, completion: { chartsData in
            DispatchQueue.main.async {
                for i in 0..<chartsData.count {
                    self.lineChartEntries.append(.init(x: Double(i), y: chartsData[i].open ?? 1.0))
                    self.tickerData.append(.init(date: chartsData[i].date, open: chartsData[i].open))
                }
                
                self.currentPrice.text = "$\(String(format: "%.2f", chartsData[chartsData.count - 1].open ?? 0.0))"
                self.historyPrice.text = "$\(String(format: "%.2f", chartsData[0].open ?? 0.0))"
                
                self.configureChart()
            }
        })
    }
    
    private func gettingDataAcordingToDate(from: Int) {
        guard let tickerSymbol = details?.companyTicker else { return }
        lineChartEntries = []
        let calendar = Calendar.current
        let fromDate = calendar.date(byAdding: .day, value: -from, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = dateFormatter.string(from: Date())
        
        let formattingFromDate = dateFormatter.string(from: fromDate!)
        print("today: \(today)")
        print("yesterday: \(formattingFromDate)")
        
        viewModel?.getDailyCharts(ticker: tickerSymbol, from: formattingFromDate, to: today, completion: { dailyData in
            self.tickerData = dailyData
            DispatchQueue.main.async {
                for i in 0...dailyData.count - 1 {
                    self.lineChartEntries.append(.init(x: Double(i), y: dailyData[i].open ?? 1.0))
                }
                
                self.historyPrice.text = "$\(String(format: "%.2f", dailyData[0].open ?? 0.0))"
                let difference = (self.details?.companyPrice ?? 0.0) - (dailyData[0].open ?? 0.0)
                let differenceInPercentage = (difference * 100) / (self.details?.companyPrice ?? 0.0)
                
                if difference >= 0 {
                    self.historyChange.text = "+\(String(format: "%.2f", difference)) (\(String(format: "%.2f", differenceInPercentage))%)"
                } else {
                    self.historyChange.text = "\(String(format: "%.2f", difference)) (\(String(format: "%.2f", differenceInPercentage))%)"
                }
                self.configureChart()
                
            }
            
        })
    }
    
}

//MARK: - AxisValueFormatter protocol
extension StockDetailsViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        let intVal = Int(value)
        guard !tickerData.isEmpty else  { return "" }
        
        if takeDay {
            let hour = tickerData[intVal].date![11...12]
            let minute = tickerData[intVal].date![14...15]
            return String("\(hour):\(minute)")
            
        } else {
            let days = tickerData[intVal].date![8...9]
            let month = tickerData[intVal].date![5...6]
            return String("\(days)/\(month)")
            
        }
        
    }
}
