import UIKit
import SnapKit


class RegionWeatherVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var regionTableView: UITableView!
    var searchController: UISearchController!
    var weatherData: [WeatherData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupRegionTableView()
        styleViewController()
        
    }
    private func styleViewController() {
        view.backgroundColor = .white
        title = "날씨 정보"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupSearchController() {
        // 검색 컨트롤러 설정
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        // 검색 바를 사용할 때 배경을 흐리게 하는 기능을 비활성화
        searchController.obscuresBackgroundDuringPresentation = false
        // 검색 바에 플레이스홀더 텍스트를 설정
        searchController.searchBar.placeholder = "지역을 검색 해주세요."
        // 자동으로 조정하여 적절한 크기
        searchController.searchBar.sizeToFit()
        // .prominent 스타일은 검색 바가 화면 상단에 표시되는 형태
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.delegate = self
    }
    
    private func setupRegionTableView() {
        regionTableView = UITableView(frame: .zero, style: .plain)
        regionTableView.delegate = self
        regionTableView.dataSource = self
        regionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(regionTableView)
        
        regionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 날씨 데이터를 불러올 함수, 액션 추가
}

// MARK: -UITableViewDataSource,UITableViewDelegate
extension RegionWeatherVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let regionWeather = weatherData[indexPath.row]
        cell.textLabel?.text = ""
        
        return cell
    }
    
    
}

// MARK: -UISearchResultsUpdating
extension RegionWeatherVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //검색 결과를 업데이트하는 메서드를 정의
        <#code#>
    }
}

// MARK: - UISearchBarDelegate
extension RegionWeatherVC: UISearchBarDelegate {
    //검색 바의 동작을 컨트롤하기 위한 메서드들을 정의
}
