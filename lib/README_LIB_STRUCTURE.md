# Cấu trúc thư mục Flutter cho LaptopAI

Cấu trúc này dùng hướng `feature-first`:

- `core/`: cấu hình dùng chung như API, theme, network, storage, utils.
- `data/`: models, repositories, services gọi API.
- `features/`: từng chức năng chính của app: auth, home, product, cart, orders, benchmark, chat_ai, admin, profile.
- `routes/`: khai báo route màn hình.
- `shared/`: widget và layout dùng lại.

## Package cần thêm vào `pubspec.yaml`

```yaml
dependencies:
  http: ^1.2.2
  shared_preferences: ^2.3.2
  intl: ^0.19.0
```

Sau khi copy thư mục `lib` vào project Flutter, chạy:

```bash
flutter pub get
flutter analyze
flutter run
```
