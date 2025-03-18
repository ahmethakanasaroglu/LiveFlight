import XCTest
@testable import LiveFlight  // normalde modül dısındaki private veya internal fonksiyonlara erişemezsin ama @testable ile bunu yapabiliriz.

final class SplashScreenViewModelTests: XCTestCase {

    func testShouldShowSplashScreen_WhenNotSeen_ShouldReturnTrue() {
        // GIVEN: Splash ekranda hiç görülmemiş
        let viewModel = SplashScreenViewModel()
        viewModel.splashSeen = .unSeen

        // WHEN: shouldShowSplashScreen çağrılıyor
        let result = viewModel.shouldShowSplashScreen()

        // THEN: Splash ekranı gösterilmeli (true)
        XCTAssertTrue(result, "Splash ekranı gösterilmeli ancak false döndü.") // test başarısız olursa bu yazar
    }
    
    func testShouldShowSplashScreen_WhenSeen_ShouldReturnFalse() {
        // GIVEN: Splash ekran daha önce görüldü
        let viewModel = SplashScreenViewModel()
        viewModel.splashSeen = .seen

        // WHEN: shouldShowSplashScreen çağrılıyor
        let result = viewModel.shouldShowSplashScreen()

        // THEN: Splash ekranı gösterilmemeli (false)
        XCTAssertFalse(result, "Splash ekranı gösterilmemeli ancak true döndü.")
    }
    
    

    func testSaveSplashSeen_ShouldSetSplashSeenToSeen() {
        // GIVEN: Splash ekranını hiç görmemiş bir kullanıcı
        let viewModel = SplashScreenViewModel()
        viewModel.splashSeen = .unSeen

        // WHEN: saveSplashSeen çağrılıyor
        viewModel.saveSplashSeen()

        // THEN: splashSeen artık .seen olmalı
        XCTAssertEqual(viewModel.splashSeen, .seen, "Splash ekranı görüldü olarak kaydedilmedi.")
    }

    
    func testGetInfoText_ShouldReturnCorrectText() {
        // GIVEN: ViewModel başlatılıyor
        let viewModel = SplashScreenViewModel()

        // WHEN & THEN: Farklı animasyonlara karşılık gelen metinleri test et
        XCTAssertEqual(viewModel.getInfoText(for: "Animation - 1739971059873"),
                       "Uçuş Bilgilerinize Anında Erişin!",
                       "Yanlış bilgi döndü.")

        XCTAssertEqual(viewModel.getInfoText(for: "Animation - 1739971095243"),
                       "Bu Uygulama Uçuş Radar Takibini Kolaylaştırır!",
                       "Yanlış bilgi döndü.")

        XCTAssertEqual(viewModel.getInfoText(for: "Animation - 1739967059887"),
                       "Uygulama İçin Konum İzniniz Gerekmektedir!",
                       "Yanlış bilgi döndü.")

        XCTAssertEqual(viewModel.getInfoText(for: "Bilinmeyen Animasyon"),
                       "",
                       "Bilinmeyen animasyon için boş string dönmeliydi.")
    }
    
}



