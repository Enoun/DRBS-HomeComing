import UIKit
import Then
import SnapKit
import PhotosUI

final class CheckVC2: UIViewController {
    //MARK: - Properties
    var houseViewModel = HouseViewModel()
    private let checkListUIView = CheckListUIView()
    private lazy var scrollView = UIScrollView(frame: self.view.frame).then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false}
    private lazy var backView = UIView().then {$0.backgroundColor = .white}
    private let 보증금 = UILabel().then {
        $0.text = "보증금*"
        $0.font = UIFont(name: Constant.font, size: 16)}
    private let 보증금TextField = UITextField().then {
        $0.placeholder = "000 "
        $0.textAlignment = .right
        let label = UILabel()
        label.text = " 만원"
        label.sizeToFit()
        $0.rightView = label
        $0.rightViewMode = .always
        $0.keyboardType = .numbersAndPunctuation}
    private let 월세 = UILabel().then {
        $0.text = "월세*"
        $0.font = UIFont(name: Constant.font, size: 16)}
    private let 월세TextField = UITextField().then {
        $0.placeholder = "00"
        $0.textAlignment = .right
        let label = UILabel()
        label.text = " 만원"
        label.sizeToFit()
        $0.rightView = label
        $0.rightViewMode = .always
        $0.keyboardType = .numbersAndPunctuation}
    private let 관리비 = UILabel().then {$0.text = "관리비" }
    var 관리비TextField = UITextField().then {
        $0.placeholder = "0"
        $0.textAlignment = .right
        let label = UILabel()
        label.text = " 만원"
        label.sizeToFit()
        $0.rightView = label
        $0.rightViewMode = .always
        $0.keyboardType = .numbersAndPunctuation}
    private let 관리비미포함 = UILabel().then {$0.text = "관리비 미포함 목록"}
    private lazy var 전기버튼 = UIButton().then {
        $0.setTitle("전기", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(vc2buttonTapped(_:)), for: .touchUpInside)}
    private lazy var 가스버튼 = UIButton().then {
        $0.setTitle("가스", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(vc2buttonTapped(_:)), for: .touchUpInside)}
    private lazy var 수도버튼 = UIButton().then {
        $0.setTitle("수도", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(vc2buttonTapped(_:)), for: .touchUpInside)}
    private lazy var 인터넷버튼 = UIButton().then {
        $0.setTitle("인터넷", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(vc2buttonTapped(_:)), for: .touchUpInside)}
    private lazy var TV버튼 = UIButton().then {
        $0.setTitle("TV", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(vc2buttonTapped(_:)), for: .touchUpInside)}
    private lazy var 기타버튼 = UIButton().then {
        $0.setTitle("기타", for: .normal)
        $0.setTitleColor(UIColor.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(vc2buttonTapped(_:)), for: .touchUpInside)}
    private let separatorLine = UIView.createSeparatorLine()
    private let separatorLine2 = UIView.createSeparatorLine()
    private let 면적 = UILabel().then {$0.text = "면적"}
    private let 면적TextField = UITextField().then {
        $0.placeholder = "면적을 입력해주세요"
        let label = UILabel()
        label.text = "㎡"
        label.sizeToFit()
        $0.rightView = label
        $0.rightViewMode = .always
        $0.keyboardType = .numbersAndPunctuation}
    private let 입주가능일 = UILabel().then {$0.text = "입주 가능일"}
    private lazy var 입주가능일button = UIButton().then {
        $0.setTitle("e) 23.08.28", for: .normal)
        $0.setTitleColor(UIColor.systemGray4, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(textFieldTapped), for: .touchUpInside)}
    private let 계약기간 = UILabel().then {$0.text = "계약기간"}
    private let 계약기간TextField = UITextField().then {
        $0.placeholder = "0"
        let label = UILabel()
        label.text = " 년"
        label.sizeToFit()
        $0.rightView = label
        $0.rightViewMode = .always
        $0.keyboardType = .numbersAndPunctuation}
    private let checkListLabel = UILabel().then {
        $0.text = "체크 리스트"
        $0.font = UIFont(name: Constant.font, size: 18)}
    private let recodeLabel = UILabel().then {
        $0.text = "기록"
        $0.font = UIFont(name: Constant.font, size: 18)}
    //이미지뷰를 담을 스크롤뷰를 생성
    private lazy var imageScrollView = UIScrollView(frame: self.view.frame).then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true}
    private var picker: PHPickerViewController!
    private let galleryImageView = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 85, height: 65)
        $0.image = UIImage(systemName: "camera")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.systemGray6}
    private let firstGalleryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10}
    private let secondGalleryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10}
    private let thirdGalleryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10}
    private let fourthGalleryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10}
    private let fifthGalleryImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10}
    private lazy var imageViewArray: [UIImageView] = [firstGalleryImageView, secondGalleryImageView, thirdGalleryImageView, fourthGalleryImageView, fifthGalleryImageView]     //이미지뷰가 초기화되기전에 초기화되면 에러가 발생할 수 있어 지연저장속성 사용
    private let memoTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.backgroundColor = UIColor.systemGray6
        $0.isScrollEnabled = true
        $0.isEditable = true
        $0.textColor = .black
        $0.layer.cornerRadius = 10}
    private lazy var completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = Constant.appColor
        $0.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
    }
    
    private lazy var 관리비버튼 = [전기버튼, 가스버튼, 수도버튼, 인터넷버튼, TV버튼, 기타버튼]
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        configureUI()
        configureUI2()
        configureUI3()
        setUpLabel()
        setupNavigationBar()
        initPicker()
        setupImageViewGesture()
        setUpKeyBoard()
    }
    override func viewDidLayoutSubviews() {
        보증금TextField.layer.addBottomLayer()
        월세TextField.layer.addBottomLayer()
        관리비TextField.layer.addBottomLayer()
        면적TextField.layer.addBottomLayer()
        입주가능일button.layer.addBottomLayer()
        계약기간TextField.layer.addBottomLayer()
        let contentHeight = completionButton.frame.maxY + 20
        let contentWidth = 140 * (imageViewArray.count + 1) + 13 * (imageViewArray.count)
        imageScrollView.contentSize = CGSize(width: contentWidth, height: 140)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: contentHeight)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backView.endEditing(true)
    }
    
    //MARK: - Helpers
    private func addScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()}
        scrollView.addSubviews(backView, 보증금TextField, 월세TextField, 관리비TextField, 면적TextField, 입주가능일button, 계약기간TextField, memoTextView, imageScrollView)
        backView.snp.makeConstraints {
            $0.top.equalTo(scrollView)
            $0.left.right.bottom.equalTo(view) // 가로 방향에 대해 화면 너비와 동일하게 설정
            $0.width.equalTo(view) // backView의 너비를 화면 너비와 동일하게 설정
        }}
    
    private func configureUI() {
        view.backgroundColor = .white
        backView.addSubviews(보증금, 월세, 관리비, 관리비미포함, 전기버튼, 가스버튼, 수도버튼, 인터넷버튼, TV버튼, 기타버튼, separatorLine)
        보증금TextField.delegate = self
        월세TextField.delegate = self
        보증금.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)}
        보증금TextField.snp.makeConstraints {
            $0.top.equalTo(보증금.snp.bottom).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-23)
            $0.height.equalTo(30)}
        월세.snp.makeConstraints {
            $0.top.equalTo(보증금TextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)}
        월세TextField.snp.makeConstraints {
            $0.top.equalTo(월세.snp.bottom).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-23)
            $0.height.equalTo(30)}
        관리비.snp.makeConstraints {
            $0.top.equalTo(월세TextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)}
        관리비TextField.snp.makeConstraints {
            $0.top.equalTo(관리비.snp.bottom).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-23)
            $0.height.equalTo(30)}
        관리비미포함.snp.makeConstraints {
            $0.top.equalTo(관리비TextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)}
        전기버튼.snp.makeConstraints {
            $0.top.equalTo(관리비미포함.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(23)
            $0.width.equalTo(75)
            $0.height.equalTo(45)}
        가스버튼.snp.makeConstraints {
            $0.top.equalTo(전기버튼)
            $0.leading.equalTo(전기버튼.snp.trailing).offset(10)
            $0.width.equalTo(75)
            $0.height.equalTo(45)}
        수도버튼.snp.makeConstraints {
            $0.top.equalTo(전기버튼)
            $0.leading.equalTo(가스버튼.snp.trailing).offset(10)
            $0.width.equalTo(75)
            $0.height.equalTo(45)}
        인터넷버튼.snp.makeConstraints {
            $0.top.equalTo(전기버튼)
            $0.leading.equalTo(수도버튼.snp.trailing).offset(10)
            $0.width.equalTo(75)
            $0.height.equalTo(45)}
        TV버튼.snp.makeConstraints {
            $0.top.equalTo(전기버튼.snp.bottom).offset(10)
            $0.leading.equalTo(전기버튼)
            $0.width.equalTo(75)
            $0.height.equalTo(45)}
        기타버튼.snp.makeConstraints {
            $0.top.equalTo(TV버튼)
            $0.leading.equalTo(TV버튼.snp.trailing).offset(10)
            $0.width.equalTo(75)
            $0.height.equalTo(45)}
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(기타버튼.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)}
    }
    private func configureUI2() {
        view.backgroundColor = .white
        backView.addSubviews(면적, 입주가능일, 계약기간, separatorLine2)
        관리비TextField.delegate = self
        면적TextField.delegate = self
        계약기간TextField.delegate = self
        면적.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)}
        면적TextField.snp.makeConstraints {
            $0.top.equalTo(면적.snp.bottom).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-23)
            $0.height.equalTo(30)}
        입주가능일.snp.makeConstraints {
            $0.top.equalTo(면적TextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)}
        입주가능일button.snp.makeConstraints {
            $0.top.equalTo(입주가능일.snp.bottom).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-23)
            $0.height.equalTo(30)}
        계약기간.snp.makeConstraints {
            $0.top.equalTo(입주가능일button.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)}
        계약기간TextField.snp.makeConstraints {
            $0.top.equalTo(계약기간.snp.bottom).offset(10)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(23)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-23)
            $0.height.equalTo(30)}
        separatorLine2.snp.makeConstraints {
            $0.top.equalTo(계약기간TextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)}
    }
    private func configureUI3() {
        view.backgroundColor = .white
        backView.addSubviews(checkListLabel, checkListUIView,  recodeLabel, completionButton)
        memoTextView.delegate = self
        imageScrollView.addSubviews(galleryImageView, firstGalleryImageView, secondGalleryImageView, thirdGalleryImageView, fourthGalleryImageView, fifthGalleryImageView)
        checkListLabel.snp.makeConstraints {
            $0.top.equalTo(separatorLine2.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)}
        checkListUIView.snp.makeConstraints {
            $0.top.equalTo(checkListLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(500)}
        recodeLabel.snp.makeConstraints {
            $0.top.equalTo(checkListUIView.snp.bottom).offset(30)
            $0.leading.equalTo(checkListLabel)}
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(recodeLabel.snp.bottom).offset(20)
            $0.leading.equalTo(checkListLabel)
            $0.trailing.equalTo(면적TextField)
            $0.height.equalTo(140)}
        galleryImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(140)}
        firstGalleryImageView.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(0)
            $0.leading.equalTo(galleryImageView.snp.trailing).offset(10)
            $0.height.width.equalTo(140)}
        secondGalleryImageView.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(0)
            $0.leading.equalTo(firstGalleryImageView.snp.trailing).offset(10)
            $0.height.width.equalTo(140)}
        thirdGalleryImageView.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(0)
            $0.leading.equalTo(secondGalleryImageView.snp.trailing).offset(10)
            $0.height.width.equalTo(140)}
        fourthGalleryImageView.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(0)
            $0.leading.equalTo(thirdGalleryImageView.snp.trailing).offset(10)
            $0.height.width.equalTo(140)}
        fifthGalleryImageView.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(0)
            $0.leading.equalTo(fourthGalleryImageView.snp.trailing).offset(10)
            $0.height.width.equalTo(140)
            $0.trailing.equalTo(imageScrollView.snp.trailing)}
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(galleryImageView.snp.bottom).offset(20)
            $0.leading.equalTo(checkListLabel)
            $0.trailing.equalTo(checkListUIView)
            $0.height.equalTo(200)}
        completionButton.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)}
    }
    private func setUpLabel() {
        //*만 빨갛게 바꾸는 콛
        self.월세.text = self.houseViewModel.tradingType! + "*" // 월세,전세,매매버튼 반영
        if self.houseViewModel.tradingType == "매매" {
            self.보증금.text = "매매*"
            self.월세.text = "기보증금/월세*"}
        let labels = [보증금, 월세]
        for texts in labels {
            let fullText = texts.text ?? ""
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "*")
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range)
            texts.attributedText = attribtuedString
        }
    }
    private func setUpKeyBoard() {
        // 다른 곳을 누르면 키보드가 내려가게 됨
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
}
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "추가하기"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    private func initPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 5
        configuration.filter = .images // 이미지만 선택할 수 있게 설정
        picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
    }
    private func setupImageViewGesture() {
        // 모든 이미지뷰에서 앨버으로 접근하려면 새로운 객체를 만들어야 한다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLibrary))
        galleryImageView.addGestureRecognizer(tapGesture)
        galleryImageView.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(viewImages))
        firstGalleryImageView.addGestureRecognizer(tapGesture1)
        firstGalleryImageView.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(viewImages))
        secondGalleryImageView.addGestureRecognizer(tapGesture2)
        secondGalleryImageView.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(viewImages))
        thirdGalleryImageView.addGestureRecognizer(tapGesture3)
        thirdGalleryImageView.isUserInteractionEnabled = true
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(viewImages))
        fourthGalleryImageView.addGestureRecognizer(tapGesture4)
        fourthGalleryImageView.isUserInteractionEnabled = true
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(viewImages))
        fifthGalleryImageView.addGestureRecognizer(tapGesture5)
        fifthGalleryImageView.isUserInteractionEnabled = true
    }
    
    //MARK: - Actions
    @objc func vc2buttonTapped(_ sender: UIButton) {
        switch sender.currentTitle {
        case "전기", "가스", "수도", "인터넷", "TV", "기타":
            guard sender.backgroundColor == Constant.appColor else {
                sender.setTitleColor(.white, for: .normal)
                sender.backgroundColor = Constant.appColor
                self.houseViewModel.관리비미포함목록.append(sender.currentTitle ?? "")
                return
            }
            sender.setTitleColor(.darkGray, for: .normal)
            sender.backgroundColor = .white
            self.houseViewModel.관리비미포함목록 = self.houseViewModel.관리비미포함목록.filter {
                $0 != sender.currentTitle ?? ""
            }
        default:
            print("디폴트")
        }
    }
    @objc func completionButtonTapped() {
        guard let deposit = 보증금TextField.text, !deposit.isEmpty,
              let rent = 월세TextField.text, !rent.isEmpty else {
            let alert = UIAlertController(title: "항목입력을 완료해주세요.", message: "필수사항을 모두 입력해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let rateVC = RateVC()
        rateVC.modalPresentationStyle = .pageSheet
        self.houseViewModel.보증금 = self.보증금TextField.text
        self.houseViewModel.월세or전세금 = self.월세TextField.text
        self.houseViewModel.관리비 = self.관리비TextField.text
        self.houseViewModel.checkList = self.checkListUIView.checkViewModel.makeCheckListModel()
        self.houseViewModel.면적 = self.면적TextField.text
        self.houseViewModel.계약기간 = self.계약기간TextField.text
//        self.houseViewModel.photo = 여기에 사진 넣는 메서드
        self.houseViewModel.memo = self.memoTextView.text
        rateVC.houseViewModel = self.houseViewModel
        self.present(rateVC, animated: true)
    }
    @objc func textFieldTapped() {
        if #available(iOS 16.0, *) {
            let calendarVC = CalendarVC()
            calendarVC.calendarDelegate = self
            calendarVC.modalPresentationStyle = .pageSheet
            self.present(calendarVC, animated: true)
        } else {
            print("버전 낮음")
        }
    }
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    // 앨범 권한설정(사진 다운로드때문에)
    @objc func openLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.present(picker, animated: true, completion: nil)
        case .denied, .restricted:
            let alert = UIAlertController(title: "권한 필요", message: "앨범 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
            let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)}
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(goSetting)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        self.present(self.picker, animated: true, completion: nil)
                    }
                }
            }
        @unknown default:
            fatalError("Unknown authorization status.")
        }
    }
    @objc func viewImages(_ sender: UITapGestureRecognizer) {
        let popUpVC = PopUpVC()
        popUpVC.modalPresentationStyle = .overFullScreen
        // 모든 이미지를 설정
        popUpVC.images = [
            firstGalleryImageView.image,
            secondGalleryImageView.image,
            thirdGalleryImageView.image,
            fourthGalleryImageView.image,
            fifthGalleryImageView.image,
        ]
        // 선택한 이미지의 인덱스를 설정
        if let imageView = sender.view as? UIImageView {
            popUpVC.currentIndex = popUpVC.images.firstIndex(where: { $0 === imageView.image }) ?? 0
        }
        self.present(popUpVC, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension CheckVC2: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:".0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > 6 {
            return false
        }
        return true
    }
}

//MARK: - UITextViewDelegate
extension CheckVC2: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true}
        let newLength = str.count + text.count - range.length
        return newLength <= 500
    }
}

//MARK: - CalendarDelegate
extension CheckVC2: CalendarDelegate {
    func dateSelected(date: Date) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yy.MM.dd"
        self.입주가능일button.setTitle(myFormatter.string(from: date), for: .normal)
        self.입주가능일button.setTitleColor(.black, for: .normal)
        self.houseViewModel.입주가능일 = date
    }
}

//MARK: - PHPickerViewControllerDelegate
extension CheckVC2: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        DispatchQueue.main.async {
            self.imageViewArray.forEach { $0.image = .none }
        }
        picker.dismiss(animated: true)
        for (index, result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        if index < self.imageViewArray.count {
                            self.imageViewArray[index].image = image
                            self.imageViewArray[index].contentMode = .scaleAspectFill
                        }
                    }
                }
            }
        }
    }
}
