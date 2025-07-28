import UIKit
import SnapKit

class StoryViewController: UIViewController {
    
    // MARK: - Properties
    private let story: DailyStory
    private var currentNodeId: String
    private let storyService = DailyStoryService.shared
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerView = UIView()
    private let storyTitleLabel = UILabel()
    private let progressView = UIProgressView()
    
    // Story Content
    private let storyCard = UIView()
    private let storyTextLabel = UILabel()
    private let readingTimeLabel = UILabel()
    
    // Choices
    private let choicesContainerView = UIView()
    private let choicesStackView = UIStackView()
    private let choicesTitleLabel = UILabel()
    
    // MARK: - Initialization
    init(story: DailyStory) {
        self.story = story
        self.currentNodeId = story.startNodeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
        displayCurrentNode()
        
        print("🎮 StoryViewController yüklendi - Node: \(currentNodeId)")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppColors.background
        
        setupHeader()
        setupStoryCard()
        setupChoicesSection()
        setupScrollView()
    }
    
    private func setupHeader() {
        // Header background with gradient
        headerView.backgroundColor = AppColors.cardBackground
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerView.layer.shadowRadius = 8
        headerView.layer.shadowOpacity = 0.1
        
        // Story Title - Centered typography
        storyTitleLabel.text = story.title
        storyTitleLabel.font = AppFonts.titleLarge
        storyTitleLabel.textColor = AppColors.textPrimary
        storyTitleLabel.textAlignment = .center
        storyTitleLabel.numberOfLines = 2
        
        // Progress View
        progressView.progressTintColor = AppColors.accent
        progressView.trackTintColor = AppColors.background
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.progress = 0.1 // Initial progress
    }
    
    private func setupStoryCard() {
        // Story Card - Modern card design
        storyCard.backgroundColor = AppColors.cardBackground
        storyCard.layer.cornerRadius = AppLayout.cardCornerRadius
        storyCard.layer.shadowColor = UIColor.black.cgColor
        storyCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        storyCard.layer.shadowRadius = 12
        storyCard.layer.shadowOpacity = 0.08
        
        // Story Text - Better reading experience
        storyTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        storyTextLabel.textColor = AppColors.textPrimary
        storyTextLabel.numberOfLines = 0
        storyTextLabel.lineBreakMode = .byWordWrapping
        
        // Reading Time Label
        readingTimeLabel.font = AppFonts.caption
        readingTimeLabel.textColor = AppColors.textSecondary
        readingTimeLabel.text = "📖 \(story.estimatedDuration)"
    }
    
    private func setupChoicesSection() {
        // Choices Container
        choicesContainerView.backgroundColor = .clear
        
        // Choices Title
        choicesTitleLabel.text = "Ne yapacaksın?"
        choicesTitleLabel.font = AppFonts.titleSmall
        choicesTitleLabel.textColor = AppColors.textPrimary
        choicesTitleLabel.textAlignment = .left
        
        // Choices Stack View
        choicesStackView.axis = .vertical
        choicesStackView.distribution = .fill
        choicesStackView.spacing = AppLayout.spacing
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupLayout() {
        view.addSubviews([headerView, scrollView])
        headerView.addSubviews([storyTitleLabel, progressView])
        scrollView.addSubview(contentView)
        contentView.addSubviews([storyCard, choicesContainerView])
        storyCard.addSubviews([storyTextLabel, readingTimeLabel])
        choicesContainerView.addSubviews([choicesTitleLabel, choicesStackView])
        
        setupHeaderLayout()
        setupScrollViewLayout()
        setupContentLayout()
    }
    
    private func setupHeaderLayout() {
        // Header
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80) // Reduced height since no back button
        }
        
        // Story Title - Centered positioning (no back button)
        storyTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppLayout.horizontalMargin)
            make.top.equalToSuperview().offset(AppLayout.spacing)
        }
        
        // Progress View
        progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppLayout.horizontalMargin)
            make.bottom.equalToSuperview().offset(-AppLayout.spacing)
            make.height.equalTo(4)
        }
    }
    
    private func setupScrollViewLayout() {
        // Scroll View
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupContentLayout() {
        // Story Card - Modern card layout
        storyCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppLayout.spacing)
            make.leading.trailing.equalToSuperview().inset(AppLayout.horizontalMargin)
        }
        
        // Reading Time Label
        readingTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppLayout.spacing)
            make.leading.trailing.equalToSuperview().inset(AppLayout.spacing)
        }
        
        // Story Text - Better reading layout
        storyTextLabel.snp.makeConstraints { make in
            make.top.equalTo(readingTimeLabel.snp.bottom).offset(AppLayout.spacing)
            make.leading.trailing.equalToSuperview().inset(AppLayout.spacing)
            make.bottom.equalToSuperview().offset(-AppLayout.spacing)
        }
        
        // Choices Container
        choicesContainerView.snp.makeConstraints { make in
            make.top.equalTo(storyCard.snp.bottom).offset(AppLayout.spacing)
            make.leading.trailing.equalToSuperview().inset(AppLayout.horizontalMargin)
            make.bottom.equalToSuperview().offset(-AppLayout.verticalMargin)
        }
        
        // Choices Title
        choicesTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        // Choices Stack View
        choicesStackView.snp.makeConstraints { make in
            make.top.equalTo(choicesTitleLabel.snp.bottom).offset(AppLayout.spacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // No back button anymore
    }
    
    // MARK: - Story Display
    private func displayCurrentNode() {
        guard let currentNode = story.nodes[currentNodeId] else {
            print("❌ Node bulunamadı: \(currentNodeId)")
            return
        }
        
        print("📖 Gösterilen node: \(currentNode.id)")
        print("📝 Text: \(currentNode.text)")
        
        // Story text'i göster - Better line spacing for reading
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacing = 8
        
        let attributedText = NSAttributedString(
            string: currentNode.text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: AppColors.textPrimary,
                .paragraphStyle: paragraphStyle
            ]
        )
        storyTextLabel.attributedText = attributedText
        
        // Önceki choice'ları temizle  
        choicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Yeni choice'ları ekle
        if let choices = currentNode.choices, !choices.isEmpty {
            for (index, choice) in choices.enumerated() {
                let choiceView = createChoiceButton(choice: choice, index: index)
                choicesStackView.addArrangedSubview(choiceView)
            }
        } else if let ending = currentNode.ending {
            // Ending node ise ending butonunu göster
            let endingView = createEndingButton(ending: ending)
            choicesStackView.addArrangedSubview(endingView)
        }
        
        // Update progress (simple calculation based on choices made)
        updateProgress()
    }
    
    private func createChoiceButton(choice: Choice, index: Int) -> UIView {
        let containerView = UIView()
        
        // Choice Card
        let card = UIView()
        card.backgroundColor = AppColors.cardBackground
        card.layer.cornerRadius = AppLayout.cardCornerRadius
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 8
        card.layer.shadowOpacity = 0.06
        
        // Choice Icon
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "arrow.right.circle")
        iconView.tintColor = AppColors.accent
        iconView.contentMode = .scaleAspectFit
        
        // Choice Text
        let textLabel = UILabel()
        textLabel.text = choice.text
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textLabel.textColor = AppColors.textPrimary
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        
        // Choice Number
        let numberLabel = UILabel()
        numberLabel.text = "\(index + 1)"
        numberLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        numberLabel.textColor = AppColors.accent
        numberLabel.backgroundColor = AppColors.accent.withAlphaComponent(0.1)
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 12
        numberLabel.clipsToBounds = true
        
        // Button for interaction
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tag = index
        button.addTarget(self, action: #selector(choiceButtonTapped(_:)), for: .touchUpInside)
        
        // Add touch animation
        button.addTarget(self, action: #selector(choiceButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(choiceButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Layout
        containerView.addSubviews([card])
        card.addSubviews([numberLabel, iconView, textLabel, button])
        
        card.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(72)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppLayout.spacing)
            make.top.equalToSuperview().offset(AppLayout.spacing)
            make.width.height.equalTo(24)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(AppLayout.spacingHalf)
            make.centerY.equalTo(numberLabel)
            make.width.height.equalTo(20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(AppLayout.spacingHalf)
            make.trailing.equalToSuperview().offset(-AppLayout.spacing)
            make.top.equalToSuperview().offset(AppLayout.spacing)
            make.bottom.equalToSuperview().offset(-AppLayout.spacing)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return containerView
    }
    
    private func createEndingButton(ending: StoryEnding) -> UIView {
        let containerView = UIView()
        
        // Ending Card - Special styling
        let card = UIView()
        card.backgroundColor = AppColors.accent
        card.layer.cornerRadius = AppLayout.cardCornerRadius
        card.layer.shadowColor = AppColors.accent.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 12
        card.layer.shadowOpacity = 0.3
        
        // Ending Icon
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "flag.checkered")
        iconView.tintColor = AppColors.background
        iconView.contentMode = .scaleAspectFit
        
        // Ending Text
        let textLabel = UILabel()
        textLabel.text = "🎯 \(ending.title)"
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textLabel.textColor = AppColors.background
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        // Button for interaction
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(endingButtonTapped), for: .touchUpInside)
        
        // Add pulse animation
        button.addTarget(self, action: #selector(endingButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(endingButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Layout
        containerView.addSubviews([card])
        card.addSubviews([iconView, textLabel, button])
        
        card.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(AppLayout.buttonHeight + 8)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppLayout.spacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(AppLayout.spacing)
            make.trailing.equalToSuperview().offset(-AppLayout.spacing)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return containerView
    }
    

    
    // MARK: - Touch Animations
    @objc private func choiceButtonTouchDown(_ sender: UIButton) {
        guard let card = sender.superview else { return }
        UIView.animate(withDuration: 0.1) {
            card.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            card.alpha = 0.8
        }
    }
    
    @objc private func choiceButtonTouchUp(_ sender: UIButton) {
        guard let card = sender.superview else { return }
        UIView.animate(withDuration: 0.1) {
            card.transform = .identity
            card.alpha = 1.0
        }
    }
    
    @objc private func endingButtonTouchDown(_ sender: UIButton) {
        guard let card = sender.superview else { return }
        UIView.animate(withDuration: 0.1) {
            card.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }
    
    @objc private func endingButtonTouchUp(_ sender: UIButton) {
        guard let card = sender.superview else { return }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            card.transform = .identity
        }
    }
    
    // MARK: - Actions
    
    @objc private func choiceButtonTapped(_ sender: UIButton) {
        guard let currentNode = story.nodes[currentNodeId],
              let choices = currentNode.choices,
              sender.tag < choices.count else { return }
        
        let selectedChoice = choices[sender.tag]
        print("🎯 Seçim yapıldı: \(selectedChoice.text)")
        
        handleChoiceSelection(selectedChoice)
    }
    
    @objc private func endingButtonTapped() {
        print("🏁 Hikaye tamamlandı!")
        handleStoryCompletion()
    }
    
    // MARK: - Navigation Logic
    private func handleChoiceSelection(_ choice: Choice) {
        // Instant ending varsa
        if let instantEnding = choice.instantEnding {
            print("⚡ Instant ending: \(instantEnding.title)")
            showEnding(instantEnding)
            return
        }
        
        // Target node'a git
        if let targetNodeId = choice.targetNodeId {
            print("➡️ Yeni node'a geçiliyor: \(targetNodeId)")
            currentNodeId = targetNodeId
            
            // Animasyonla yeni node'u göster
            UIView.transition(with: contentView, duration: 0.3, options: .transitionCrossDissolve) {
                self.displayCurrentNode()
            }
        }
    }
    
    private func showEnding(_ ending: StoryEnding) {
        let alert = UIAlertController(title: ending.title, message: ending.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamamla", style: .default) { _ in
            self.handleStoryCompletion()
        })
        present(alert, animated: true)
    }
    
    private func updateProgress() {
        // Simple progress calculation - could be more sophisticated
        let totalNodes = story.nodes.count
        let currentProgress = min(1.0, progressView.progress + 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.progressView.progress = currentProgress
        }
    }
    
    private func handleStoryCompletion() {
        // Complete progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
        }
        
        // Story'yi tamamlandı olarak işaretle
        storyService.markTodaysStoryCompleted()
        print("✅ Hikaye tamamlandı ve kaydedildi")
        
        // Welcome screen'e dön with delay for visual feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UIView Extension
private extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
} 
