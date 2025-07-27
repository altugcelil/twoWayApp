//
//  WelcomeViewController.swift
//  twoWayApp
//
//  Created by Berkut Teknoloji on 28.07.2025.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
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
        
        // Hikaye ekranına geçiş
        print("🎭 Hikaye başlatılıyor - Gece Vardiyası!")
        
        // TODO: HikayeViewController'a geçiş
        // let hikayeVC = HikayeViewController()
        // navigationController?.pushViewController(hikayeVC, animated: true)
    }
} 
