# Riverpod Architecture Documentation

このドキュメントでは、PlantUMLシーケンス図に基づいたRiverpodアーキテクチャの実装について説明します。

## 🏗️ アーキテクチャ概要

このプロジェクトは、Clean ArchitectureとRiverpodを組み合わせた3層アーキテクチャを採用しています：

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   CounterPage   │  │ CounterDisplay  │  │CounterControls│ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │     Counter     │  │CounterRepository│  │   Providers │ │
│  │   (Entity)      │  │  (Interface)    │  │             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Infrastructure Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │CounterDataSource│  │CounterRepository│  │   API/DB    │ │
│  │                 │  │    (Impl)       │  │             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📁 ディレクトリ構造

```
lib/
├── main.dart                          # アプリケーションエントリーポイント
├── domain/                            # ドメイン層
│   ├── entities/                      # エンティティ
│   │   └── counter.dart              # Counterエンティティ
│   ├── repositories/                  # リポジトリインターフェース
│   │   └── counter_repository.dart   # CounterRepository
│   └── providers/                     # Riverpodプロバイダー
│       └── counter_providers.dart    # Counter関連プロバイダー
├── infrastructure/                    # インフラストラクチャ層
│   ├── data_sources/                  # データソース
│   │   └── counter_data_source.dart  # CounterDataSource
│   └── repositories/                  # リポジトリ実装
│       └── counter_repository_impl.dart # CounterRepositoryImpl
└── presentation/                      # プレゼンテーション層
    ├── pages/                         # ページ
    │   └── counter_page.dart         # CounterPage
    └── widgets/                       # ウィジェット
        ├── counter_display.dart      # CounterDisplay
        └── counter_controls.dart     # CounterControls
```

## 🔄 Riverpodパターンの実装

### 1. Query/Subscription パターン (ref.watch)

**シーケンス図の対応部分:**
```
page -> provider: **ref.watch** or **ref.listen**
provider -> provider: キャッシュがあるか確認
alt キャッシュあり
  provider --> page: キャッシュ済みのデータを返却
end
provider -> domain: データ取得に必要なドメインのメソッドを呼び出す
domain -> dataSource: 各データソースからデータを取得する
dataSource --> domain: レスポンスを返却
domain --> provider: Providerが必要なデータを返却
provider --> page: データを提供する
```

**実装例:**
```dart
// domain/providers/counter_providers.dart
@riverpod
Future<Counter> counter(CounterRef ref) async {
  final repository = ref.watch(counterRepositoryProvider);
  return await repository.getCounter();
}

// presentation/widgets/counter_display.dart
class CounterDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterAsync = ref.watch(counterProvider); // Query/Subscription
    return counterAsync.when(
      data: (counter) => Text('${counter.value}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 2. Refresh パターン (ref.refresh)

**シーケンス図の対応部分:**
```
page -> provider: **ref.refresh** or **ref.invalidate**
provider -> domain: データ取得に必要なドメインのメソッドを呼び出す
domain -> dataSource: 各データソースからデータを取得する
dataSource --> domain: レスポンスを返却
domain --> provider: Providerが必要なデータを返却
provider --> page: データを提供する
```

**実装例:**
```dart
// presentation/pages/counter_page.dart
IconButton(
  onPressed: () {
    ref.refresh(counterProvider); // Refresh pattern
  },
  icon: Icon(Icons.refresh),
)
```

### 3. Mutation パターン (ref.read)

**シーケンス図の対応部分:**
```
page -> provider: **ref.read**（必要なパラメータを渡してコール）
provider -> domain: 必要なドメインのメソッドを呼び出す
domain -> dataSource: 各データソースへの変更処理を実行する
dataSource --> domain: レスポンスを返却
domain --> provider: 非同期による完了報告 or Exception
provider --> page: 非同期による完了報告 or Exception
```

**実装例:**
```dart
// domain/providers/counter_providers.dart
@riverpod
class CounterNotifier extends _$CounterNotifier {
  Future<void> increment() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(counterRepositoryProvider);
      final newCounter = await repository.increment();
      state = AsyncValue.data(newCounter);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// presentation/widgets/counter_controls.dart
class CounterControls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterNotifier = ref.watch(counterNotifierProvider.notifier);
    
    return FloatingActionButton(
      onPressed: () {
        counterNotifier.increment(); // Mutation pattern
      },
      child: Icon(Icons.add),
    );
  }
}
```

## 🎯 各層の責任

### Presentation Layer (プレゼンテーション層)
- **責任**: UIの表示とユーザーインタラクション
- **コンポーネント**: Pages, Widgets
- **Riverpod使用**: `ref.watch`, `ref.read`, `ref.refresh`

### Domain Layer (ドメイン層)
- **責任**: ビジネスロジックとエンティティ
- **コンポーネント**: Entities, Repository Interfaces, Providers
- **Riverpod使用**: Provider定義, ドメインロジックの実装

### Infrastructure Layer (インフラストラクチャ層)
- **責任**: 外部データソースとの通信
- **コンポーネント**: DataSources, Repository Implementations
- **Riverpod使用**: 依存性注入の対象

## 🔧 依存性注入

Riverpodを使用した依存性注入の例：

```dart
// DataSourceの提供
@riverpod
CounterDataSource counterDataSource(CounterDataSourceRef ref) {
  return CounterDataSource();
}

// Repositoryの提供（DataSourceに依存）
@riverpod
CounterRepository counterRepository(CounterRepositoryRef ref) {
  final dataSource = ref.watch(counterDataSourceProvider);
  return CounterRepositoryImpl(dataSource);
}

// ビジネスロジックの提供（Repositoryに依存）
@riverpod
Future<Counter> counter(CounterRef ref) async {
  final repository = ref.watch(counterRepositoryProvider);
  return await repository.getCounter();
}
```

## 📊 データフロー

1. **初期化時**:
   ```
   App → ProviderScope → CounterPage → CounterDisplay → counterProvider
   ```

2. **データ取得時**:
   ```
   counterProvider → counterRepositoryProvider → counterDataSourceProvider → CounterDataSource
   ```

3. **状態変更時**:
   ```
   CounterControls → counterNotifierProvider → CounterRepositoryImpl → CounterDataSource
   ```

4. **UI更新時**:
   ```
   CounterDataSource → CounterRepositoryImpl → counterNotifierProvider → CounterDisplay
   ```

## 🚀 使用方法

### アプリケーションの実行
```bash
cd packages/flutter_app
flutter run
```

### コード生成の実行
```bash
cd packages/flutter_app
dart run build_runner build
```

### テストの実行
```bash
cd packages/flutter_app
flutter test
```

## 🎨 UI機能

このアプリケーションでは以下の機能を実装しています：

1. **カウンター表示**: 現在の値をリアルタイムで表示
2. **インクリメント**: 値を1増加
3. **デクリメント**: 値を1減少
4. **リセット**: 値を0にリセット
5. **リフレッシュ**: データを再取得
6. **ローディング状態**: 処理中の表示
7. **エラーハンドリング**: エラー状態の表示

## 🔄 状態管理の特徴

- **リアクティブ**: データの変更が自動的にUIに反映
- **キャッシュ**: 同じデータの重複取得を防止
- **非同期処理**: ローディングとエラー状態の適切な管理
- **依存性注入**: テスト可能な疎結合な設計
- **型安全**: コンパイル時の型チェック

---

**このアーキテクチャにより、保守性が高く、テスト可能で、スケーラブルなFlutterアプリケーションを構築できます。** 