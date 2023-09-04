import UIKit
import KakaoSDKAuth
import Then
import SnapKit
import MapKit

final class MyHouseVC: UIViewController {
    //MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: "roomImage.png")}
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 18)
        $0.text = "개포 3동 2층 원룸"
        $0.textColor = .black
        $0.textAlignment = .left}
    private lazy var livingMethodLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.text = "원룸"
        $0.textColor = Constant.appColor
        $0.textAlignment = .center
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.layer.borderColor = Constant.appColor.cgColor
        $0.layer.borderWidth = 1}
    private lazy var starImage = UIImageView().then {$0.image = UIImage(named: "star.png")}
    private lazy var rateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.textColor = .darkGray
        $0.text = "4.0"
        $0.textAlignment = .center}
    private lazy var firstContainView = UIView()
    private lazy var addressLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.textColor = .black
        $0.text = "서울특별시 강남구 개포동 153"
        $0.textAlignment = .left}
    private lazy var tradeMethodLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.text = "월세"
        $0.textColor = Constant.appColor
        $0.textAlignment = .center
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.layer.borderColor = Constant.appColor.cgColor
        $0.layer.borderWidth = 1}
    private lazy var costLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 22)
        $0.text = "1000/60"
        $0.textColor = .black
        $0.textAlignment = .left}
    private lazy var secondContainView = UIView()
    private lazy var mainView = UIView()
    private lazy var maintenanceLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.text = "관리비 7만원"
        $0.textAlignment = .left}
    // 아직 관리비 미포함 목록 안함
    private lazy var noneMaintenanceLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.text = "관리비\n미포함"
        $0.numberOfLines = 2
        $0.textAlignment = .left}
    private lazy var noneMaintenanceImagesStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually}
    private lazy var mapLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
        $0.text = "지도"}
    private lazy var mapView = MKMapView()
    private lazy var mapStackView = UIView()
    private lazy var memoLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
        $0.text = "메모"}
    private lazy var memoTextView = UITextView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3}
    private lazy var detailView = UIView()
    private lazy var detailTextView = UIView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3}
    private lazy var 면적 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
        $0.text = "면적 :"}
    private lazy var 입주가능일 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
        $0.text = "입주가능일 :"}
    private lazy var 계약기간 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
        $0.text = "계약기간 :"}
    private lazy var 면적ValueLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "50㎡"}
    private lazy var 입주가능일ValueLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "2023-09-04"}
    private lazy var 계약기간ValueLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "5년"}
    private lazy var textCountLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .lightGray
        $0.text = "(242/500)"}
    private lazy var memoView = UIView()
    private lazy var button = UIButton().then {
        $0.backgroundColor = Constant.appColor
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true}
    private lazy var checkView = UIView()
    private lazy var checkLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
        $0.text = "체크 리스트"}
    private lazy var CheckListView = CheckListUIView()
    var selectedHouseId: String?
   
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        settingNav()
        fetchSelectedHouseData()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.layer.addBottomLayer()
        mapStackView.layer.addBottomLayer()
        memoView.layer.addBottomLayer()
        detailView.layer.addBottomLayer()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        mainView.addSubviews(firstContainView,
                                      addressLabel,
                                      secondContainView,
                                      maintenanceLabel,
                                      noneMaintenanceLabel,
                                      noneMaintenanceImagesStackView)
        firstContainView.addSubviews(nameLabel,
                                    livingMethodLabel,
                                    starImage,
                                    rateLabel)
        secondContainView.addSubviews(tradeMethodLabel, costLabel)
        mapStackView.addSubviews(mapLabel, mapView)
        memoView.addSubviews(memoLabel, memoTextView, textCountLabel)
        detailView.addSubviews(면적, 면적ValueLabel,
                               입주가능일, 입주가능일ValueLabel,
                               계약기간, 계약기간ValueLabel,
                               detailTextView)
        checkView.addSubviews(checkLabel, CheckListView)
        scrollView.snp.makeConstraints {$0.edges.equalToSuperview()}
        contentView.addSubviews(mainImageView,
                                mainView,
                                mapStackView,
                                memoView,
                                detailView,
                                checkView,
                                button)

        contentView.snp.makeConstraints {$0.edges.width.equalTo(scrollView)}
        
        mainImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalTo(contentView)
            $0.height.equalTo(250)
        }

        mainView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(30)
            $0.leading.equalTo(contentView).offset(10)
            $0.trailing.equalTo(contentView).offset(-10)
            $0.height.equalTo(180)
        }
        
        firstContainView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        nameLabel.snp.makeConstraints {
            $0.bottom.top.leading.equalToSuperview()
        }
        rateLabel.snp.makeConstraints {
            $0.trailing.bottom.top.equalToSuperview()
            $0.width.equalTo(30)
        }
        starImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(rateLabel.snp.leading).offset(-5)
            $0.width.equalTo(30)
        }
        livingMethodLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(starImage.snp.leading).offset(-5)
            $0.width.equalTo(35)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(firstContainView.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.height.equalTo(30)
        }
        secondContainView.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        tradeMethodLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(35)
        }
        costLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(tradeMethodLabel.snp.trailing).offset(10)
        }
        maintenanceLabel.snp.makeConstraints {
            $0.top.equalTo(secondContainView.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-60)
        }
        
        noneMaintenanceLabel.snp.makeConstraints {
            $0.top.equalTo(maintenanceLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.height.equalTo(60)
//            $0.bottom.equalToSuperview().offset(60)
        }
        
        noneMaintenanceImagesStackView.snp.makeConstraints {
            $0.top.equalTo(noneMaintenanceLabel)
            $0.leading.equalToSuperview()
            $0.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        mapStackView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(mainView)
            $0.height.equalTo(210)
        }
        
        mapLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        mapView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(3)
            $0.trailing.equalToSuperview().offset(-3)
            $0.top.equalTo(mapLabel.snp.bottom).offset(5)
            $0.bottom.equalTo(mapStackView.snp.bottom).offset(-20)
        }
        
        memoView.snp.makeConstraints {
            $0.top.equalTo(mapStackView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(mainView)
            $0.height.equalTo(234)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(memoView.snp.bottom).offset(-20)
            $0.trailing.equalToSuperview().offset(-3)
            $0.height.equalTo(24)
        }
        
        memoTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(3)
            $0.trailing.equalToSuperview().offset(-3)
            $0.top.equalTo(memoLabel.snp.bottom).offset(5)
            $0.bottom.equalTo(textCountLabel.snp.top).offset(-5)
        }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(memoView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(mainView)
            $0.height.equalTo(180)
        }
        
        면적.snp.makeConstraints {
            $0.top.equalTo(detailView).offset(20)
            $0.leading.equalTo(detailView).offset(15)
        }
        
        면적ValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(면적)
            $0.leading.equalTo(면적.snp.trailing).offset(15)
        }
        
        입주가능일.snp.makeConstraints {
            $0.top.equalTo(면적).offset(50)
            $0.leading.equalTo(detailView).offset(15)
        }
        
        입주가능일ValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(입주가능일)
            $0.leading.equalTo(입주가능일.snp.trailing).offset(15)
        }
        
        계약기간.snp.makeConstraints {
            $0.top.equalTo(입주가능일).offset(50)
            $0.leading.equalTo(detailView).offset(15)
        }
        
        계약기간ValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(계약기간)
            $0.leading.equalTo(계약기간.snp.trailing).offset(15)
        }
        
        detailTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(3)
            $0.trailing.equalToSuperview().offset(-3)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(계약기간ValueLabel.snp.bottom).offset(10)
        }
        
        checkView.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(550)
        }
        
        checkLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        
        CheckListView.snp.makeConstraints {
            $0.top.equalTo(checkLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
        
        button.snp.makeConstraints {
            $0.top.equalTo(checkView.snp.bottom).offset(200)   //바꿔야함
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.bottom).offset(20)
            $0.height.greaterThanOrEqualTo(scrollView)
            $0.width.equalToSuperview()

        }
    }
        
    
    
    private func settingNav() {
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let ellipsis = self.navigationItem.makeSFSymbolButtonWithMenu(self, action: #selector(ellipsisButtonTapped), symbolName: "ellipsis.circle")
        let bookmark = self.navigationItem.makeSFSymbolButton(self, action: #selector(bookmarkButtonTapped), symbolName: "bookmark")
        let barButtonItem = UIBarButtonItem(customView: ellipsis)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        let edit = UIAction(title: "편집", image: UIImage(systemName: "square.and.pencil"), handler: { _ in
            // 데이터 가져오기
            let rateVC = RateVC()
            //            let uid = Auth.auth().currentUser?.uid
            //            NetworkingManager.shared.fetchHousesWithCurrentUser(currentUser: uid) { [weak self] houses in
            //                // 메인화면에서 선택했던 셀의 housId를 가져온다
            //                guard let self = self, let selectedHouseId = self.selectedHouseId else { return }
            //                let house = houses.first { $0.houseId == selectedHouseId }
            //
            //                // 데이터 전달
            //                let checkVC1 = CheckVC1()
            //                checkVC1.house = house
            //
            //                // 화면 전환
            //                self.navigationController?.pushViewController(checkVC1, animated: true)
            //            }
        })
        
        let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash.fill"), handler: { _ in
            //삭제하면 홈화면으로 돌아가면서 해당 부동산Id를 completionHandler를 통해 넘겨서 서버에서 삭제
            print("삭제하기")
            
        })
        
        ellipsis.menu = UIMenu(title: "메뉴를 선택해주세요",
                               image: nil,
                               identifier: nil,
                               options: .displayInline,
                               children: [edit, delete])
        navigationItem.rightBarButtonItems = [barButtonItem,  bookmark]
        }
    
    private func fetchSelectedHouseData() {
        guard let houseId = selectedHouseId else { return }

        NetworkingManager.shared.fetchSelectedHouseData(houseId: houseId) { [weak self] house in
            print("잘 작동중")
            print("관리비미포함목록: \(house?.관리비미포함목록)")
            guard let self = self, let house = house else { return }

            var selectedImages: [UIImage] = []

            if let 관리비미포함목록 = house.관리비미포함목록 {
                if 관리비미포함목록.contains("가스") {
                    selectedImages.append(UIImage(named: "gassImage.png")!)
                }
                if 관리비미포함목록.contains("전기") {
                    selectedImages.append(UIImage(named: "lightningImage.png")!)
                }
                if 관리비미포함목록.contains("수도") {
                    selectedImages.append(UIImage(named: "waterImage.png")!)
                }
                if 관리비미포함목록.contains("TV") {
                    selectedImages.append(UIImage(named: "tvImage.png")!)
                }
                if 관리비미포함목록.contains("인터넷") {
                    selectedImages.append(UIImage(named: "internetImage.png")!)
                }
            }

            DispatchQueue.main.async {
                for image in selectedImages {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit

                    // 이미지뷰의 크기 제약 설정
                    let desiredWidth: CGFloat = 10.0
                    let desiredHeight: CGFloat = 10.0
                    imageView.widthAnchor.constraint(equalToConstant: desiredWidth).isActive = true
                    imageView.heightAnchor.constraint(equalToConstant: desiredHeight).isActive = true

                    self.noneMaintenanceImagesStackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @objc func bookmarkButtonTapped() {
        print("b")
        
    }
    
    @objc func ellipsisButtonTapped() {
        print("e")
        
    }

}
