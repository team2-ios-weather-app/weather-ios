import UIKit
import SnapKit


class RegionWeatherVC: UIViewController {
    private lazy var regionTableView = UITableView()
    private lazy var weatherService = WeatherService()
    private lazy var regionSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "지역 검색"
        search.delegate = self
        return search
    }()
    var weatherDatas: [CrntWeatherData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupRegionTableView()
        addSubViews()
        autoLayouts()
    }
    
    private func setupRegionTableView() {
        regionTableView = UITableView(frame: .zero, style: .plain)
        regionTableView.delegate = self
        regionTableView.dataSource = self
        regionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WeatherCell")
    }
    
    // 날씨 데이터를 불러올 함수, 액션 추가
}

// MARK: -UITableViewDataSource,UITableViewDelegate
extension RegionWeatherVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let weatherData = weatherDatas[indexPath.row]
        // 날씨 정보
        let temperature = weatherData.main?.temp ?? 0
        let weatherStatus = weatherData.weather?.first?.description ?? "정보를 찾을 수 없습니다."
        let cityName = weatherData.name ?? "알 수 없는 도시"
        cell.textLabel?.text = "도시: \(cityName), 온도: \(temperature)°C, 날씨: \(weatherStatus)"
        
        return cell
    }
}

// MARK: -UISearchResultsUpdating
extension RegionWeatherVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //검색 결과를 업데이트하는 메서드를 정의
        
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
        let weatherData = await WeatherService().getCrntWeatherDataForCity(cityName)
        DispatchQueue.main.async {
            self.updateTableView(with: weatherData)
        }
    }
    
    func updateTableView(with weatherData: CrntWeatherData?) {
        guard let weatherData = weatherData else { return }
        weatherDatas.append(weatherData)
        regionTableView.reloadData()
    }
}


extension RegionWeatherVC {
    private func addSubViews() {
        view.addSubViews([regionTableView, regionSearchBar,])
    }
    
    private func autoLayouts() {
        regionSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.right.equalTo(view)
        }
        regionTableView.snp.makeConstraints { make in
            make.top.equalTo(regionSearchBar.snp.bottom).offset(100)
            make.left.right.bottom.equalToSuperview()
        }
    }
}


@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
    return RegionWeatherVC()
}
