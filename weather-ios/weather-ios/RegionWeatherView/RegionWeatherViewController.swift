import UIKit
import SnapKit


class RegionWeatherVC: UIViewController {
    private lazy var regionTableView = UITableView()
    private var refreshWeather: UIRefreshControl!
    private lazy var weatherService = WeatherService()
    private lazy var regionTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("지역별 날씨", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
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
    var onCitySelected: ((String) -> Void)?
    
    var weatherDatas: [CrntWeatherData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupRegionTableView()
        addSubViews()
        autoLayouts()
        keyBoardHide()
    }
    
    private func setupRegionTableView() {
        regionTableView = UITableView(frame: .zero, style: .plain)
        regionTableView.delegate = self
        regionTableView.dataSource = self
        regionTableView.translatesAutoresizingMaskIntoConstraints = false
        regionTableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        regionTableView.refreshControl = refreshControl
    }

    @objc private func refreshWeatherData(_ sender: UIRefreshControl) {
        sender.endRefreshing()
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension RegionWeatherVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDatas.count
    }// 대구
    
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
        onCitySelected?(cityName)
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
        guard let cityName = searchBar.text else { return }
        Task {
            await fetchAndDisplayWeather(for: cityName)
        }
        print("입력한 값: \(cityName)")
    }
    
    func fetchAndDisplayWeather(for cityName: String) async {
        let weatherData = await WeatherService().getCrntWeatherData(regionName: cityName, unit: .metric)
        DispatchQueue.main.async {
            self.updateTableView(with: weatherData)
        }
        //print("\(String(describing: weatherData))")
    }
    
    func updateTableView(with weatherData: CrntWeatherData?) {
        guard let weatherData = weatherData else { return }
        weatherDatas.append(weatherData)
        regionTableView.reloadData()
        UserSettings.shared.registeredRegions.append(weatherData.name ?? "")
        print("값 \(weatherData.name ?? "")")
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalTo(view)
        }
        regionSearchBar.snp.makeConstraints { make in
            make.top.equalTo(regionTitleButton.snp.top).offset(80)
            make.left.right.equalTo(view)
        }
        regionTableView.snp.makeConstraints { make in
            make.top.equalTo(regionSearchBar.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}



