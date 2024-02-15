import UIKit
import SnapKit


class RegionWeatherVC: UIViewController {
    private lazy var regionTableView = UITableView()
    private var refreshWeather: UIRefreshControl!
    private lazy var weatherService = WeatherService()
    private lazy var regionTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("지역별 날씨", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.shadowColor = UIColor.black
        button.titleLabel?.shadowOffset = CGSize(width: 2, height: 2)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 10
        return button
    }()
    private lazy var regionSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "지역 검색"
        search.delegate = self
        search.searchBarStyle = .minimal
        return search
    }()
    
    var weatherDatas: [CrntWeatherData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegionTableView()
        addSubViews()
        autoLayouts()
        keyBoardHide()
        loadRegions()
        tableViewBackground()
        
    }
    
    private func setupRegionTableView() {
        regionTableView = UITableView(frame: .zero, style: .plain)
        regionTableView.delegate = self
        regionTableView.dataSource = self
        regionTableView.translatesAutoresizingMaskIntoConstraints = false
        regionTableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
    }
    private func tableViewBackground() {
        let backgroundImage = UIImage(named: "skyview")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = self.view.bounds
        view.insertSubview(backgroundImageView, at: 0)
        
        regionTableView.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        regionTableView.backgroundView = backgroundView
    }
    
    private func loadRegions() {
        UserSettings.shared.registeredRegions.forEach { cityName in
            Task {
                let weatherData = await WeatherService().getCrntWeatherData(regionName: cityName, unit: .metric)
                print(weatherData?.coord?.localNames?.ko ?? "")
                DispatchQueue.main.async {
                    self.updateTableView(with: weatherData)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension RegionWeatherVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        let weatherData = weatherDatas[indexPath.row]
        cell.configure(with: weatherData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let cityName = weatherDatas[indexPath.row].name {
                weatherDatas.remove(at: indexPath.row)// weatherDatas 배열에서 해당 데이터 삭제
                tableView.deleteRows(at: [indexPath], with: .automatic) // 테이블 뷰에서 해당 셀 삭제
                UserSettings.shared.removeRegion(cityName)
            }
        }
    }
    // 뷰 전환(메인화면으로 전환)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityName = weatherDatas[indexPath.row].name else { return }
        
        UserSettings.shared.selectedRegion
        print("선택한 지역: \(cityName)")
    }
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

// MARK: - UISearchBarDelegate
extension RegionWeatherVC: UISearchBarDelegate {
    // 도시의 날씨 정보를 비동기적으로 가져오고 화면에 표시하는 작업
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                ,!cityName.isEmpty else { return }
        Task {
            let weatherData = await WeatherService().getCrntWeatherData(regionName: cityName, unit: .metric)
            //print("지역:  \(weatherData?.coord?.localNames?.ko ?? "")") 제주
            DispatchQueue.main.async {
                if !UserSettings.shared.registeredRegions.contains(weatherData?.coord?.localNames?.en ?? "") {
                    UserSettings.shared.registeredRegions.append(weatherData?.coord?.localNames?.en ?? "")
                }
                UserSettings.shared.save()
                self.updateTableView(with: weatherData)
                print("저장된 지역: \(UserSettings.shared.registeredRegions)")
            }
        }
        print("입력한 값: \(cityName)")
    }
    
    func updateTableView(with weatherData: CrntWeatherData?) {
        guard let weatherData = weatherData,
              !weatherDatas.contains(where: { $0.name == weatherData.name }) else { return }
        weatherDatas.append(weatherData)
        regionTableView.reloadData()
        printCurrentWeatherData()
        print("값 \(weatherData.name ?? "")")
        
    }
    
    private func printCurrentWeatherData() {
        for data in weatherDatas {
            print("지역: \(data.name ?? ""), 온도: \(data.main?.temp)")
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            Task {
                UIView.animate(withDuration: 0.3) {
                    // SeachBar 탭 했을 때 Bar 높이 1.5배로 조정
                    searchBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.5)
                }
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            searchBar.transform = CGAffineTransform.identity
        }
    }
}


extension RegionWeatherVC {
    private func addSubViews() {
        view.addSubViews([regionTableView, regionSearchBar, regionTitleButton])
    }
    
    private func autoLayouts() {
        regionTitleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view).offset(10)
            make.width.equalTo(180)
        }
        regionSearchBar.snp.makeConstraints { make in
            make.top.equalTo(regionTitleButton.snp.top).offset(80)
            make.left.right.equalTo(view)
        }
        regionTableView.snp.makeConstraints { make in
            make.top.equalTo(regionSearchBar.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
}



