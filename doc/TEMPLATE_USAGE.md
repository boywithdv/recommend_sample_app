# Flutter Template 使用方法

このドキュメントでは、Flutter Templateを新しいプロジェクトのベースとして使用する方法を説明します。

## 🚀 クイックスタート

### 方法1: 自動スクリプトを使用（推奨）

```bash
# スクリプトを実行
./scripts/create_project.sh my_awesome_app

# 作成されたプロジェクトに移動
cd my_awesome_app

# VS Codeで開く
code .
```

### 方法2: 手動で作成

```bash
# 1. テンプレートをクローン
git clone <your-template-repo-url> my-new-project
cd my-new-project

# 2. Git履歴をクリア
rm -rf .git
git init

# 3. プロジェクト名を変更
# 以下のファイルを編集:
# - pubspec.yaml (ルート)
# - melos.yaml
# - packages/flutter_app/pubspec.yaml
# - .vscode/launch.json
# - README.md

# 4. 依存関係をインストール
melos bootstrap
```

## 📋 スクリプトの詳細

### 使用方法

```bash
./scripts/create_project.sh <プロジェクト名> [テンプレートパス]
```

### パラメータ

- **プロジェクト名**: 必須。新しいプロジェクトの名前（小文字、数字、アンダースコアのみ）
- **テンプレートパス**: オプション。テンプレートのパス（デフォルト: 現在のディレクトリ）

### 例

```bash
# 基本的な使用方法
./scripts/create_project.sh my_app

# 特定のテンプレートパスを指定
./scripts/create_project.sh my_app /path/to/flutter_template

# プロジェクト名に数字を含む
./scripts/create_project.sh app_2024
```

## 🔧 手動での変更項目

スクリプトを使用しない場合、以下のファイルを手動で編集する必要があります：

### 1. ルート pubspec.yaml

```yaml
name: your_project_name_monorepo  # 変更
```

### 2. melos.yaml

```yaml
name: your_project_name  # 変更
```

### 3. packages/flutter_app/pubspec.yaml

```yaml
name: your_project_name  # 変更
description: "Your project description"  # 変更
```

### 4. .vscode/launch.json

```json
{
    "configurations": [
        {
            "name": "your_project_name",  // 変更
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "your_project_name_app",  // 変更
            "cwd": "packages/flutter_app",
            "request": "launch",
            "type": "dart"
        }
    ]
}
```

### 5. README.md

プロジェクト名と説明を新しいプロジェクトに合わせて更新

## 📁 ディレクトリ構造の変更（オプション）

アプリケーションディレクトリの名前も変更したい場合：

```bash
# ディレクトリ名を変更
mv packages/flutter_app packages/your_project_name_app

# melos.yaml を更新
# packages: セクションを以下のように変更:
packages:
  - packages/your_project_name_app

# .vscode/launch.json の cwd パスを更新
```

## ✅ 作成後の確認事項

新しいプロジェクトが正常に作成されたか確認する項目：

1. **依存関係のインストール**
   ```bash
   melos bootstrap
   ```

2. **Flutterアプリの実行**
   ```bash
   cd packages/flutter_app  # または packages/your_project_name_app
   flutter run
   ```

3. **VS Codeでの実行**
   - VS Codeでプロジェクトを開く
   - F5キーを押す
   - デバッグ設定が正しく表示されることを確認

4. **テストの実行**
   ```bash
   melos test
   ```

## 🚨 注意事項

- プロジェクト名は小文字、数字、アンダースコアのみ使用可能
- 既存のディレクトリと同じ名前は使用不可
- スクリプト実行前にMelosがインストールされていることを確認
- 作成後は必ず依存関係のインストールを実行

## 🔄 テンプレートの更新

テンプレート自体を更新する場合：

1. テンプレートの変更をコミット
2. 新しいプロジェクトを作成する際は最新のテンプレートを使用
3. 既存のプロジェクトには影響しない

## 📞 トラブルシューティング

### よくある問題

1. **Melosがインストールされていない**
   ```bash
   dart pub global activate melos
   ```

2. **依存関係のインストールに失敗**
   ```bash
   melos clean
   melos bootstrap
   ```

3. **VS Code設定が正しく動作しない**
   - .vscode/launch.json のパスを確認
   - プロジェクト名が正しく更新されているか確認

4. **Flutterアプリが起動しない**
   ```bash
   cd packages/flutter_app
   flutter doctor
   flutter pub get
   flutter run
   ```

---

**Happy Fluttering! 🚀** 