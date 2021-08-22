import UIKit

class SiparisVC: UIViewController, GenreListViewModelDelegate {
    
    let pageViewController  = RestaurantPageVC()
    let pageControl = UIPageControl()
    var initialPage = 0
    var collectionView : UICollectionView!
    let loadingView = LoadingView.shared
    var viewModel: RestaurantGenreViewModel!{
        didSet{
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()
        if !Connectivity.isConnectedToInternet{
            let offlineVC = OfflineVC()
            present(offlineVC, animated: true)
        }
        
        loadingView.startLoading()
        pageViewController.pageControllerDelegate = self
        pageViewController.setUI(with: returnViewControllers())
        configurePageVC()
        configureCollectionView()
        viewModel.load()
        configurePageControl()
        // protocol taşı
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadingView.hideLoading()
        }
    }
    
    func configurePageControl() {
        // pageControl
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        pageControl.currentPage = initialPage
        pageViewController.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: -20),
            pageControl.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func returnViewControllers() -> [UIViewController]{
        
        let width = pageViewController.view.frame.size.width - 25
        var controllers = [UIViewController]()
        let viewC1 = UIViewController()
        let viewC2 = UIViewController()
        let viewC3 = UIViewController()
        
        let imageView = UIImageView(image: UIImage(named: "dominos"))
        viewC1.view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        imageView.contentMode = .scaleAspectFit
        
        let imageView2 = UIImageView(image: UIImage(named: "burgerking"))
        viewC2.view.addSubview(imageView2)
        imageView2.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        imageView2.contentMode = .scaleAspectFit
        
        let imageView3 = UIImageView(image: UIImage(named: "kfc"))
        viewC3.view.addSubview(imageView3)
        imageView3.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        imageView3.contentMode = .scaleAspectFit
    
        
        controllers.append(viewC1)
        controllers.append(viewC2)
        controllers.append(viewC3)
        
        return controllers
    }
    
    func registerCell() {
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func configureCollectionView(){
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate   = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        guard let tabHegiht: CGFloat = self.tabBarController?.tabBar.frame.size.height else { return }
        
        let collectionViewHeight = view.frame.size.height - view.frame.size.height*0.33 - tabHegiht
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
            
        ])
    }
    
    func createCollectonGridLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width  = (view.frame.width - 4*10)/2
        let height = (view.frame.height)/3
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    private func configurePageVC() {
        
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
        ])
    }
}


extension SiparisVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.restaurants.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCell.identifier, for: indexPath) as! CategoriesCell
        
        guard let restaurant = viewModel?.restaurants[indexPath.row] else {
            return .init()
        }
        
        cell.setUI(model: restaurant)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tabBar = self.tabBarController else { return }
        let vc = tabBar.viewControllers?[1].children[0] as! SearchVC
        
        guard let title = viewModel?.restaurants[indexPath.row].name else { return }
        vc.comeFromSiparisVC = title
        tabBar.selectedIndex = 1
        
    }
}

extension SiparisVC: PageViewControllerDelegate{
    func setupPageController(numberPages: Int) {
        pageControl.numberOfPages = numberPages
    }
    
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
    }
}
