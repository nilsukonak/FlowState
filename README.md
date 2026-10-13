
# FlowState — Mobil Görev Yönetimi Uygulaması

<p align="center">
  <strong>Planla. Önceliklendir. Takip et. Akışta kal.</strong>
</p>

<p align="center">
  Flutter ve Dart ile geliştirilen; Firebase destekli kimlik doğrulama, bulut tabanlı görev yönetimi ve yerel bildirimler sunan bir mobil görev yönetimi uygulaması.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile%20Development-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-Programming%20Language-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84" alt="Platforms">
</p>

<p align="center">
  <a href="#-ekran-görüntüleri">Ekran Görüntüleri</a> •
  <a href="#-özellikler">Özellikler</a> •
  <a href="#-teknolojiler">Teknolojiler</a> •
  <a href="#-kurulum">Kurulum</a> •
  <a href="#-english">English</a>
</p>

---

## Proje Hakkında

**FlowState**, kullanıcıların günlük görevlerini düzenlemelerine, önceliklendirmelerine ve ilerlemelerini takip etmelerine yardımcı olmak amacıyla geliştirilmiş bir mobil görev yönetimi uygulamasıdır.

Uygulama; Flutter ve Dart kullanılarak oluşturulmuş, Firebase servisleriyle desteklenmiş ve Provider aracılığıyla durum yönetimi sağlanmıştır. Görev verilerinin kullanıcı bazında yönetilmesi, uygulama içi gezinme, görev filtreleme ve yerel bildirimler gibi işlevler tek bir mobil uygulama deneyiminde bir araya getirilmiştir.

Projenin geliştirilmesi sırasında yalnızca kullanıcı arayüzüne değil; veri yönetimine, uygulama mimarisine, kimlik doğrulama akışlarına, bildirim zamanlamasına ve hata ayıklama süreçlerine de odaklanılmıştır.

###  Projenin Amaçları

- Günlük görevlerin tek bir yerden yönetilebilmesini sağlamak.
- Görevlerin tamamlanma durumlarını ve önceliklerini takip etmek.
- Kullanıcı hesaplarını Firebase üzerinden yönetmek.
- Uygulama durumunu merkezi ve sürdürülebilir biçimde yönetmek.
- Görevler için zamanlanmış yerel hatırlatıcılar oluşturmak.
- Gerçek bir mobil uygulama projesinde karşılaşılabilecek mimari, yapılandırma ve hata ayıklama süreçlerini uygulamak.

## 📱 Ekran Görüntüleri
![FlowState uygulamasının ekran görüntüleri](screenshots/screens.png)


##  Özellikler

###  Kimlik Doğrulama ve Hesap Yönetimi

- Firebase Authentication ile e-posta ve parola üzerinden kullanıcı doğrulama.
- Yeni kullanıcı hesabı oluşturma ve giriş yapma akışları.
- Parola sıfırlama e-postası gönderme.
- Google ile oturum açma entegrasyonu.
- Kullanıcıya ait verilerin Firebase kullanıcı kimliği (UID) üzerinden ayrıştırılması.

###  Görev Yönetimi

- Yeni görev oluşturma ve düzenleme.
- Görevleri silme.
- Görevlerin tamamlanma durumunu değiştirme.
- Görevlere başlık ve açıklama ekleme.
- Görev tarihi belirleme.
- Görevlere öncelik atama.
- Kategori bilgileriyle görevleri düzenleme.
- Görev durumlarına göre listeleri filtreleme.

### Arama ve Filtreleme

- Görevler arasında arama yapma.
- Arama alanındaki metni temizleme.
- Arama metni bulunduğunda temizleme kontrolünü gösterme.
- Tüm görevleri, aktif görevleri ve tamamlanmış görevleri ayrı görüntüleme.

### Dashboard ve İlerleme Takibi

Görev verilerinden elde edilen özet bilgiler aracılığıyla kullanıcının görev durumunu takip etmesi hedeflenir.

- Toplam görev sayısı.
- Aktif görev sayısı.
- Tamamlanmış görev sayısı.
- Tamamlanma oranı.

Bu değerler görev verileri üzerinden hesaplanır; görevler güncellendiğinde özetin de güncel durumu yansıtması amaçlanır.

###  Yerel Bildirimler ve Görev Hatırlatıcıları

Uygulamaya `flutter_local_notifications` ve `timezone` paketleriyle yerel bildirim altyapısı eklenmiştir.

- Görev tarihine bağlı hatırlatıcı zamanlama.
- Saat 09.00 ve 17.00 için hatırlatıcı planlama.
- Görev oluşturma veya güncelleme akışlarıyla hatırlatıcıları ilişkilendirme.
- Görev silindiğinde ilgili hatırlatıcıları iptal etme.
- Bildirimleri uygulamanın başlangıcında başlatma ve yapılandırma.
- Android bildirim izinleri ve zamanlama gereksinimleriyle çalışma.

Bildirimlerin gerçek cihazdaki davranışı Android sürümüne, izinlere, pil optimizasyonlarına ve cihaz üreticisinin arka plan kısıtlamalarına bağlı olabilir. Kesin dakikada teslimat tüm cihazlarda garanti edilmez.

###  Arayüz ve Kullanıcı Deneyimi

- Flutter ile oluşturulmuş mobil kullanıcı arayüzü.
- Provider üzerinden tema durumunun yönetilmesi.
- Açık ve koyu tema seçenekleri.
- AutoRoute ile uygulama içi sayfa yönlendirmesi.
- Görev oluşturma ve düzenleme için ayrı ekran akışları.
- FlowState adı ve görsel kimliğiyle uygulamanın yeniden düzenlenmesi.


### Uygulama Altyapısı ve Hata Ayıklama

Geliştirme sürecinde yalnızca özellik eklemeye değil, uygulamanın yapılandırmasına ve farklı bileşenlerin birlikte çalışmasına da odaklanılmıştır.

- Flutter paketlerinin ve bağımlılıklarının yönetilmesi.
- Android yapılandırmasının bildirim paketleriyle uyumlu hâle getirilmesi.
- Bildirim zamanlamasında tarih formatından kaynaklanan hatanın giderilmesi.
- Bildirimlerin uygulama kapalıyken de planlanan şekilde çalışıp çalışmadığının test edilmesi.
- Android derleme ve paket yapılandırması sorunlarının incelenmesi.

##  Teknolojiler

| Teknoloji / Paket | Kullanım amacı |
|---|---|
| Flutter | Mobil uygulama arayüzü ve uygulama geliştirme |
| Dart | Uygulamanın programlama dili |
| Firebase Core | Firebase servislerinin başlatılması |
| Firebase Authentication | Kullanıcı kimlik doğrulama |
| Cloud Firestore | Bulut tabanlı veri saklama |
| Provider | Durum yönetimi ve bağımlılıkların uygulamaya sağlanması |
| AutoRoute | Tip güvenli sayfa yönlendirme altyapısı |
| Hive / Hive Flutter | Yerel veri saklama altyapısı |
| SharedPreferences | Basit anahtar-değer tercihlerini saklama |
| Google Sign-In | Google hesabıyla oturum açma |
| Flutter Local Notifications | Yerel bildirimler |
| Timezone | Bildirim zamanlamasında saat dilimi desteği |
| Fluttertoast | Kısa kullanıcı bilgilendirme mesajları |
| Image Field | Görsel alanları için kullanılan paket |

> Listelenen paketlerin projedeki gerçek kullanım kapsamı kaynak koduna bağlıdır. Yerel depolama paketleri projede yer alsa da tüm görev verilerinin Hive veya SharedPreferences içinde tutulduğu anlamına gelmez; görev verileri için Cloud Firestore kullanılır.

## Mimari ve Proje Yapısı

Proje; kullanıcı arayüzü, sağlayıcılar, yönlendirme, tema ve servis katmanlarının farklı sorumluluklar üstlendiği bir yapıyla düzenlenmiştir.

Öne çıkan mimari yaklaşımlar:

- **Repository Pattern:** Veri erişimi ve Firestore işlemlerini uygulamanın diğer bölümlerinden ayırmaya yardımcı olur.
- **Provider:** Görev verileri ve tema gibi durumların widget'lar arasında paylaşılmasını sağlar.
- **AutoRoute:** Sayfa geçişlerinin ve rota tanımlarının yönetilmesini sağlar.
- **Firebase servisleri:** Kimlik doğrulama ve bulut veritabanı işlemlerini üstlenir.
- **Notification Service:** Yerel bildirimlerin başlatılması, planlanması ve iptal edilmesi işlemlerini merkezileştirir.


##  Kurulum

### Gereksinimler

- Flutter SDK ve Dart SDK.
- Android Studio veya Visual Studio Code.
- Android Emulator ya da fiziksel bir Android cihaz.
- Firebase projesi ve uygun uygulama yapılandırması.
- Git.

Flutter kurulumunun doğru yapıldığını kontrol etmek için:
```bash
flutter doctor
```
### 1. Repoyu klonla
Aşağıdaki adresi yeni FlowState reposunu oluşturduktan sonra onun gerçek URL'siyle değiştir:
```bash
git clone https://github.com/nilsukonak/FlowState.git
cd FlowState
```
### 2. Paketleri yükle
```bash
flutter pub get
```
### 3. Firebase yapılandırmasını tamamla

Projeyi kendi Firebase projenle çalıştırmak için Android ve/veya iOS uygulama yapılandırmalarını tamamlaman gerekir.
Firebase yapılandırmasının kullanılan FlutterFire sürümüne göre hazırlanması gerekebilir. Gerekli yapılandırma dosyalarını kendi Firebase projen üzerinden üret veya güncelle.
Firebase istemci yapılandırma dosyaları tek başına sunucu erişim güvenliği sağlamaz. Firestore Security Rules, Authentication ve gerekli platform ayarları doğru yapılandırılmalıdır. Özel servis hesabı anahtarlarını, parolaları veya diğer gizli bilgileri depoya yükleme.

### 4. Android bildirim yapılandırmasını kontrol et
Yerel bildirimlerin çalışabilmesi için Android izinleri, bildirim kanalları ve kullanılan eklentinin Android yapılandırması kontrol edilmelidir. Bazı Android sürümlerinde bildirim izni kullanıcıdan ayrıca istenir.

### 5. Uygulamayı çalıştır
Bağlı cihazları listele:
```bash
flutter devices
```
Ardından:
```bash
flutter run
```
### 6. Derleme sorunlarını giderme
Bağımlılık veya derleme kaynaklı sorunlarda önce hata mesajının tamamını incele. Gerekirse:
```bash
flutter clean
flutter pub get
flutter run
```
Kullanılan Flutter SDK sürümünün ve Android SDK ayarlarının projedeki paketlerin gereksinimleriyle uyumlu olduğundan emin ol.Ben sdk = 36 kullandım.

##  Bildirim Mantığı Hakkında
Görev hatırlatıcıları, görev tarihi ve belirlenen saatler üzerinden planlanır. Görev oluşturulduğunda veya tarihi değiştirildiğinde eski bildirimlerin tekrar değerlendirilmesi gerekir. Görev silindiğinde ilgili bildirimlerin iptal edilmesi de önemlidir.
Bildirimler sunucu tarafından gönderilen push notification değildir; yerel cihazda planlanan bildirimlerdir. Bu nedenle uygulamanın Firebase üzerinden veri alması ile cihazın zamanlanmış bildirimi göstermesi birbirinden ayrı süreçlerdir.

##  Test ve Doğrulama

Projeyi geliştirirken özellikleri gerçek kullanım akışlarında kontrol etmek önemlidir.

Önerilen kontroller:

- Yeni hesap oluşturma ve giriş yapma.
- Parola sıfırlama akışı.
- Google ile oturum açma yapılandırması.
- Görev ekleme, düzenleme ve silme.
- Görev durumunu değiştirme ve filtreleme.
- Arama alanını kullanma ve temizleme.
- Görev istatistiklerinin güncellenmesi.
- Bildirim izinleri ve planlanan hatırlatıcılar.
- Uygulama yeniden açıldığında verilerin tutarlılığı.
Testleri çalıştırmak için:
```bash
flutter test
```
Bu komut mevcut testleri çalıştırır; testlerin tüm özellikleri kapsadığı veya hepsinin başarılı olduğu anlamına gelmez.

##  Güvenlik ve Gizlilik

- Firebase Authentication ile kullanıcı kimliği doğrulanmalıdır.
- Firestore erişimi uygun Security Rules ile sınırlandırılmalıdır.
- Gizli anahtarlar ve servis hesabı kimlik bilgileri Git'e yüklenmemelidir.
- Gerçek kullanıcı verileri ve kişisel bilgiler ekran görüntülerinde paylaşılmamalıdır.
- Örnek yapılandırmalar kullanılırken gerçek proje kimlik bilgileri korunmalıdır.


---

# English

## FlowState — Mobile Task Management Application

FlowState is a mobile task management application built with Flutter and Dart. It combines Firebase-backed authentication, cloud-based task management, task filtering, progress summaries, theme management, and scheduled local notifications.

The project focuses on both user-facing features and application engineering practices, including state management, repository-based data access, navigation, notification scheduling, and platform configuration.

### Key Features

- **Authentication:** Email and password authentication through Firebase Authentication, password reset, and Google Sign-In integration.
- **Task management:** Create, edit, delete, and complete tasks; manage descriptions, dates, priorities, and categories.
- **Search and filtering:** Search tasks and filter them by status.
- **Dashboard summaries:** Total, active, and completed task counts, plus completion rate.
- **Local reminders:** Schedule reminders for 9:00 AM and 5:00 PM based on task dates, and cancel reminders when tasks are deleted.
- **Theme management:** Light and dark theme support through Provider.
- **Navigation:** Route management with AutoRoute.
- **Cloud data:** Store and manage task data through Cloud Firestore.
- **Application structure:** Separate responsibilities across providers, routing, themes, data access, and notification services.

### Technology Stack

| Technology | Purpose |
|---|---|
| Flutter and Dart | Mobile application development |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud data storage |
| Provider | State management |
| AutoRoute | Application navigation |
| Hive and SharedPreferences | Local storage dependencies |
| Google Sign-In | Google account authentication |
| Flutter Local Notifications | Scheduled local reminders |
| Timezone | Time-zone support for notification scheduling |

### Getting Started

**Prerequisites:** Flutter SDK, Dart SDK, Git, an Android or iOS development environment, and Firebase configuration.

Clone the repository:

```bash
git clone https://github.com/nilsukonak/FlowState.git
cd FlowState
```

Install dependencies:

```bash
flutter pub get
```

Configure Firebase for your own project and ensure that platform-specific settings and Firestore Security Rules are correctly configured.

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

Run the existing tests:

```bash
flutter test
```

### Notifications

FlowState uses local notifications scheduled on the device. Reminder delivery depends on device permissions, Android version, battery optimization, and platform restrictions. Exact delivery at a specific minute cannot be guaranteed on every device.

### Security

Do not commit private service-account keys, passwords, or other secrets. Configure Firebase Authentication and Firestore Security Rules for your own Firebase project. Never include real user data in screenshots or example files.


