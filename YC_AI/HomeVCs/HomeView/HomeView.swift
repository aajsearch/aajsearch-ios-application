import UIKit

class HomeView: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var btn_newChat: UIButton!
    @IBOutlet weak var col_foryou: UICollectionView!
    @IBOutlet weak var vw_pagecontrol: UIView!
    @IBOutlet weak var col_exploreMore: UICollectionView!
    @IBOutlet weak var tbl_talkAbout: UITableView!
    
    
    @IBOutlet weak var tbl_talkAboutHeight: NSLayoutConstraint!
    
    let images = ["foryou", "foryou", "foryou"]
    let images2 = ["Bitmap", "Bitmap-1", "Bitmap-2","Bitmap-3"]
    let agentname = ["Motivation", "Fitness", "Fashion","Mental Health"]
    let image3 = ["Group 11","Group 12","Group 13"]
    var currentIndex = 0
    var autoScrollTimer: Timer?
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_newChat.layer.cornerRadius = 18
        btn_newChat.layer.masksToBounds = true
        searchbar.searchTextField.borderStyle = .none
        searchbar.searchTextField.textColor = .red
        searchbar.searchTextField.tintColor = .red
        searchbar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchbar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchbar.layer.borderColor = UIColor(hexString: "ffffff").cgColor
        searchbar.backgroundColor = UIColor(hexString: "E7E7E7")
        searchbar.layer.borderWidth = 1
        searchbar.layer.cornerRadius = 25
        searchbar.layer.masksToBounds = true
        searchbar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "717171", alpha: 1)])
        
        col_foryou.delegate = self
        col_foryou.dataSource = self
        col_foryou.register(UINib(nibName: "ForyouCVC", bundle: nil), forCellWithReuseIdentifier: "ForyouCVC")
        
        col_exploreMore.delegate = self
        col_exploreMore.dataSource = self
        col_exploreMore.register(UINib(nibName: "ExploreMore", bundle: nil), forCellWithReuseIdentifier: "ExploreMore")

        tbl_talkAbout.delegate = self
        tbl_talkAbout.dataSource = self
        tbl_talkAbout.register(UINib(nibName: "ExploreMoreTVC", bundle: nil), forCellReuseIdentifier: "ExploreMoreTVC")
        
        tbl_talkAboutHeight.constant = CGFloat((image3.count + 0) * 214)

        setupPageControl()
        startAutoScroll()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupPageControl() {
        pageControl = UIPageControl(frame: vw_pagecontrol.bounds)
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentIndex
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
        vw_pagecontrol.addSubview(pageControl)
    }
    
    func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollImages), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollImages() {
        if currentIndex < images.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
            col_foryou.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            pageControl.currentPage = currentIndex
            return
        }
        
        col_foryou.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentIndex
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == col_foryou {
            return images.count
        } else if collectionView == col_exploreMore {
            return images2.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == col_foryou {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForyouCVC", for: indexPath) as! ForyouCVC
            cell.imageview.image = UIImage(named: images[indexPath.item])
            return cell
        } else if collectionView == col_exploreMore {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreMore", for: indexPath) as! ExploreMore
            cell.imageview.image = UIImage(named: images2[indexPath.item])
            cell.lbl_agentName.text = agentname[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == col_foryou {
            return collectionView.bounds.size
        } else if collectionView == col_exploreMore {
            return CGSize(width: 100, height: collectionView.bounds.height)
        }
        return CGSize.zero
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = visibleIndex
        pageControl.currentPage = currentIndex
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image3.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreMoreTVC", for: indexPath) as! ExploreMoreTVC
        cell.imageview.image = UIImage(named: image3[indexPath.row])
        return cell
    }
    
    @IBAction func clk_newchat(_ sender: Any) {
        // Handle new chat button click
    }
}
