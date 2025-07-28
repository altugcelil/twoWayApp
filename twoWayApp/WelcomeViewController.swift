//
//  WelcomeViewController.swift
//  twoWayApp
//
//  Created by Berkut Teknoloji on 28.07.2025.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    private var currentStory: DailyStory?
    
    // MARK: - Services
    private let storyService = DailyStoryService.shared
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppContent.welcomeTitle
        label.font = AppFonts.titleLarge
        label.textColor = AppColors.headerText
        label.textAlignment = .center
        return label
    }()
    
    private let storyCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardBackground
        view.layer.cornerRadius = AppLayout.cardCornerRadius
        
        // Simple shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        
        return view
    }()
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppContent.storyCardTitle
        label.font = AppFonts.titleMedium
        label.textColor = AppColors.primaryText
        label.textAlignment = .center
        return label
    }()
    
    private let storyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppContent.mainStoryTitle
        label.font = AppFonts.titleSmall
        label.textColor = AppColors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppContent.startButtonTitle, for: .normal)
        button.titleLabel?.font = AppFonts.button
        button.backgroundColor = AppColors.primary
        button.setTitleColor(AppColors.buttonText, for: .normal)
        button.layer.cornerRadius = AppLayout.cornerRadius
        
        // Simple shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
        
        // Firebase test - bugünün hikayesi var mı kontrol et
        checkTodaysStory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = AppColors.background
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(storyCardView)
        
        // Add card content
        storyCardView.addSubview(cardTitleLabel)
        storyCardView.addSubview(storyTitleLabel)  
        storyCardView.addSubview(startButton)
    }
    
    private func setupLayout() {
        // Ana başlık - adaptive margin
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(AppLayout.spacingDouble)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppLayout.horizontalMargin)
        }
        
        // Ana kart - adaptive sizing
        storyCardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-AppLayout.spacing) // Hafif yukarı
            make.leading.trailing.equalToSuperview().inset(AppLayout.horizontalMargin)
            // Height dinamik olacak - content'e göre
        }
        
        // Kart içeriği - standart spacing (16px)
        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppLayout.spacingDouble) 
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppLayout.spacing)
        }
        
        storyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cardTitleLabel.snp.bottom).offset(AppLayout.spacingDouble)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppLayout.spacing)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(storyTitleLabel.snp.bottom).offset(AppLayout.spacingDouble)
            make.bottom.equalToSuperview().inset(AppLayout.spacingDouble)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppLayout.spacing)
            make.height.equalTo(AppLayout.buttonHeight)
        }
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Firebase Methods
    
    private func checkTodaysStory() {
        // Bugünün hikayesi tamamlandı mı kontrol et
        if storyService.isTodaysStoryCompleted() {
            showCompletedState()
            return
        }
        
        // Bugünün hikayesini Firebase'ten çek
        storyService.fetchTodaysStory { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let story):
                    self?.showStory(story)
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func showStory(_ story: DailyStory) {
        // Story'yi kaydet
        currentStory = story
        
        // Firebase'ten gelen veriyle UI'ı güncelle
        storyTitleLabel.text = story.title
        print("✅ Firebase'ten hikaye yüklendi: \(story.title)")
        print("📖 İlk node: \(story.nodes[story.startNodeId]?.text ?? "Bulunamadı")")
    }
    
    private func showCompletedState() {
        startButton.setTitle("Hikaye Tamamlandı", for: .normal)
        startButton.backgroundColor = AppColors.secondaryText
        startButton.isEnabled = false
        print("ℹ️ Bugünün hikayesi zaten tamamlanmış")
    }
    
    private func showError(_ error: StoryError) {
        startButton.setTitle("Bağlantı Hatası", for: .normal)
        startButton.backgroundColor = AppColors.danger
        print("❌ Firebase hatası: \(error.localizedDescription)")
        
        // 3 saniye sonra tekrar dene
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.startButton.setTitle(AppContent.startButtonTitle, for: .normal)
            self.startButton.backgroundColor = AppColors.primary
        }
    }
    
    // MARK: - Actions
    
    @objc private func startButtonTapped() {
        // Simple button animation
        UIView.animate(withDuration: 0.1, animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.startButton.transform = .identity
            }
        }
        
        print("🎮 Başla butonuna basıldı!")
        
        // Eğer hikaye varsa story ekranına git
        if let story = currentStory {
            print("📖 Story ekranına geçiliyor: \(story.title)")
            let storyViewController = StoryViewController(story: story)
            navigationController?.pushViewController(storyViewController, animated: true)
        } else {
            // Hikaye yoksa Firebase'ten çek
            print("🔄 Hikaye yükleniyor...")
            checkTodaysStory()
        }
    }
} 
