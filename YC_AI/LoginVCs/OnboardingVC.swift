import UIKit

class OnboardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var vw_segment: UIView!
    @IBOutlet weak var col_imageScroll: UICollectionView!
    
    @IBOutlet weak var btn_nextHomeVC: UIButton!
    
    var pageControl: UIPageControl!
    

    // Example data for images (replace with your own images)
    let images = ["Frame 1", "Frame 1", "Frame 1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure CollectionView
        col_imageScroll.delegate = self
        col_imageScroll.dataSource = self
        col_imageScroll.isPagingEnabled = true
        
        btn_nextHomeVC.isHidden = true

    
        col_imageScroll.register(UINib(nibName: "OnboardingCVC", bundle: nil), forCellWithReuseIdentifier: "OnboardingCVC")
        
        btn_nextHomeVC.layer.cornerRadius = 25
        btn_nextHomeVC.layer.masksToBounds = true

        // Layout for collection view
        if let layout = col_imageScroll.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: col_imageScroll.frame.width, height: col_imageScroll.frame.height)
        }
        
        // Set up Page Control
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: vw_segment.frame.width, height: vw_segment.frame.height))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        vw_segment.addSubview(pageControl)
    }
    
    
    @IBAction func clk_homeVC(_ sender: Any) {
        let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCVC", for: indexPath) as! OnboardingCVC
        cell.imageView.image = UIImage(named: images[indexPath.item]) // Assuming OnboardingCVC has an imageView property
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          // Set cell size equal to the collection view's size
          return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
      }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / col_imageScroll.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        // Check if we are on the last page
        if Int(pageIndex) == images.count - 1 {
            // Show button with animation
            if btn_nextHomeVC.isHidden {
                btn_nextHomeVC.alpha = 0 // Start with transparent
                btn_nextHomeVC.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.btn_nextHomeVC.alpha = 1 // Fade in
                }
            }
        } else {
            // Hide button with animation
            if !btn_nextHomeVC.isHidden {
                UIView.animate(withDuration: 0.3, animations: {
                    self.btn_nextHomeVC.alpha = 0 // Fade out
                }) { _ in
                    self.btn_nextHomeVC.isHidden = true
                }
            }
        }
    }

}
