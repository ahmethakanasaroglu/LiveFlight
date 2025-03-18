import XCTest
@testable import LiveFlight

class SettingsViewModelTests: XCTestCase {
    
    var viewModel: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SettingsViewModel()
        UserDefaults.standard.removeObject(forKey: "selectedTheme") // Her testte temiz başlamak için
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // 1️⃣ TEMANIN DOĞRU KAYDEDİLDİĞİNİ TEST ET
    func testToggleTheme_SavesThemePreference() {
        viewModel.toggleTheme(isOn: true)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: "selectedTheme"), "Dark mode açık olmalı")
        // iki iş yapıyor bu fonksiyon. hem userDefaultsa kaydediyor hem de darkMode ayarı yapıyor ama bu UI işlemi oldugu için test edemeyiz sadece kaydetmeyi test ediyoruz. Mesela bu yüzden applyTheme için test yazamıyoruz burda cünkü sadece ui işlemi var.
        viewModel.toggleTheme(isOn: false)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "selectedTheme"), "Dark mode kapalı olmalı")
    }
    
    // 2️⃣ TEMANIN DOĞRU DÖNÜP DÖNMEDİĞİNİ TEST ET
    func testIsDarkMode_ReturnsCorrectValue() {
        UserDefaults.standard.set(true, forKey: "selectedTheme")
        XCTAssertTrue(viewModel.isDarkMode, "Dark mode açık olmalı")
        
        UserDefaults.standard.set(false, forKey: "selectedTheme")
        XCTAssertFalse(viewModel.isDarkMode, "Dark mode kapalı olmalı")
    }
    
    // 3️⃣ AYARLAR LİSTESİNİN DOĞRU OLUP OLMADIĞINI TEST ET
    func testGetSettingsOptions_ReturnsCorrectOptions() {
        let options = viewModel.getSettingsOptions()
        XCTAssertEqual(options.count, 4, "Ayarlar listesi 4 eleman içermeli")
        
        XCTAssertEqual(options[0].title, "Kişisel Verilerin Korunması")
        XCTAssertEqual(options[1].title, "Görüş & Yorumlar")
        XCTAssertEqual(options[2].title, "Destek")
        XCTAssertEqual(options[3].title, "Uygulama Hakkında")
    }
    
    // URL açılabiliyor mu testi
    func testOpenURL_ValidURL() {
        let validURL = "https://opensky-network.org/api/states/all" // Gerçek bir URL
        
        let url = URL(string: validURL)
        XCTAssertNotNil(url, "URL düzgün oluşturulmalı")
        
        let canOpen = UIApplication.shared.canOpenURL(url!)
        XCTAssertTrue(canOpen, "Uygulama bu URL'yi açabilmeli")
        
        // Gerçekten açmak istemiyoruz, sadece açılabilir mi kontrol ediyoruz.
    }

}
