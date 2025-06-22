#!/bin/bash

# Flutter Template から新しいプロジェクトを作成するスクリプト

set -e

# 引数チェック
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <新しいプロジェクト名> [テンプレートパス]"
    echo "例: $0 my_awesome_app"
    echo "例: $0 my_awesome_app /path/to/flutter_template"
    exit 1
fi

PROJECT_NAME=$1
TEMPLATE_PATH=${2:-$(pwd)}

# プロジェクト名の検証
if [[ ! $PROJECT_NAME =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo "エラー: プロジェクト名は小文字、数字、アンダースコアのみ使用可能です"
    echo "例: my_awesome_app, flutter_app_2024"
    exit 1
fi

echo "🚀 新しいFlutterプロジェクトを作成中..."
echo "プロジェクト名: $PROJECT_NAME"
echo "テンプレートパス: $TEMPLATE_PATH"

# 新しいディレクトリを作成
if [ -d "$PROJECT_NAME" ]; then
    echo "エラー: ディレクトリ '$PROJECT_NAME' は既に存在します"
    exit 1
fi

# テンプレートをコピー
echo "📋 テンプレートをコピー中..."
cp -r "$TEMPLATE_PATH" "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Git履歴をクリア
echo "🗑️  Git履歴をクリア中..."
rm -rf .git
git init

# プロジェクト名を変更
echo "✏️  プロジェクト名を変更中..."

# ルート pubspec.yaml
sed -i.bak "s/name: recommend_sample_app/name: ${PROJECT_NAME}_monorepo/" pubspec.yaml
rm pubspec.yaml.bak

# melos.yaml
sed -i.bak "s/name: flutter_template/name: $PROJECT_NAME/" melos.yaml
rm melos.yaml.bak

# Flutterアプリの pubspec.yaml
sed -i.bak "s/name: flutter_template/name: $PROJECT_NAME/" packages/flutter_app/pubspec.yaml
sed -i.bak "s/description: \"A new Flutter project.\"/description: \"$PROJECT_NAME Flutter application.\"/" packages/flutter_app/pubspec.yaml
rm packages/flutter_app/pubspec.yaml.bak

# ディレクトリ名を変更（オプション）
if [ -d "packages/flutter_app" ]; then
    echo "📁 アプリディレクトリ名を変更中..."
    mv packages/flutter_app "packages/${PROJECT_NAME}_app"
    
    # melos.yaml のパッケージパスを更新
    sed -i.bak "s/- packages\/\*\*/- packages\/${PROJECT_NAME}_app/" melos.yaml
    rm melos.yaml.bak
fi

# 依存関係をインストール
echo "📦 依存関係をインストール中..."
if command -v melos &> /dev/null; then
    melos bootstrap
else
    echo "⚠️  Melosがインストールされていません。手動でインストールしてください:"
    echo "   dart pub global activate melos"
    echo "   melos bootstrap"
fi

# VS Code設定を更新
echo "⚙️  VS Code設定を更新中..."
if [ -f ".vscode/launch.json" ]; then
    # launch.json の設定名を更新
    sed -i.bak "s/\"name\": \"flutter_template\"/\"name\": \"$PROJECT_NAME\"/" .vscode/launch.json
    sed -i.bak "s/\"name\": \"flutter_template_app\"/\"name\": \"${PROJECT_NAME}_app\"/" .vscode/launch.json
    
    # ディレクトリパスを更新
    if [ -d "packages/${PROJECT_NAME}_app" ]; then
        sed -i.bak "s/\"cwd\": \"packages\/flutter_app\"/\"cwd\": \"packages\/${PROJECT_NAME}_app\"/" .vscode/launch.json
    fi
    rm .vscode/launch.json.bak
fi

# READMEを更新
echo "📝 READMEを更新中..."
sed -i.bak "s/# Flutter Template/# $PROJECT_NAME/" README.md
sed -i.bak "s/flutter_template/$PROJECT_NAME/g" README.md
rm README.md.bak

echo "✅ プロジェクト '$PROJECT_NAME' が正常に作成されました！"
echo ""
echo "次のステップ:"
echo "1. cd $PROJECT_NAME"
echo "2. melos bootstrap (まだ実行していない場合)"
echo "3. code . (VS Codeで開く)"
echo "4. F5 でアプリを実行"
echo ""
echo "🎉 新しいプロジェクトの開発を開始してください！" 