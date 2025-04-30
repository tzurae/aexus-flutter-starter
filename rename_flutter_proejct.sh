#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE} === Rename your project === ${NC}"
echo ""

# 檢查是否已經在 flutter_boilerplate_project 目錄中
if [[ ! -f "pubspec.yaml" ]] || ! grep -q "name: boilerplate" pubspec.yaml; then
    echo -e "${RED}錯誤: 請在 flutter_boilerplate_project 根目錄中運行此腳本${NC}"
    exit 1
fi

read -p "Please enter the new project name: " NEW_PROJECT_NAME
echo -e "${GREEN}New project name: ${NEW_PROJECT_NAME}${NC}"

if ! [[ $NEW_PROJECT_NAME =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo -e "${RED}錯誤: 项目名称必须以小写字母开头，只能包含小写字母、数字和下划线${NC}"
    exit 1
fi

read -p "Please enter your package name for the identifier of Andriod and IOS: " PACKAGE_NAME
echo -e "${GREEN}New package name: ${PACKAGE_NAME}${NC}"

if ! [[ $PACKAGE_NAME =~ ^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$ ]]; then
    echo -e "${RED}錯誤: 项目名称必须以小写字母开头，只能包含小写字母、数字和下划线${NC}"
    exit 1
f^14.8.1i

read -p "Please enter your display name: " DISPLAY_NAME

echo ""
echo -e "${YELLOW}將進行以下的更改${NC}"
echo -e "Project name: ${GREEN} $NEW_PROJECT_NAME${NC}"
echo -e "Package name: ${GREEN} $PACKAGE_NAME${NC}"
echo -e "Display name: ${GREEN} $DISPLAY_NAME${NC}"
echo ""

read -p "Would you proceed? (y/n): " CONFIRM

if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
   echo -e "${YELLOW}Bye Bye"
   exit 0
fi

# 保存當前目錄
CURRENT_DIR=$(pwd)
OLD_PROJECT_NAME="rizzlt_flutter_starter"
OLD_PACKAGE_NAME="com.rizzlt.flutter.starter"
OLD_DISPLAY_NAME="Flutter Project"

if [[ "$OSTYPE" == "darwin*" ]]; then
    # macOS
    SED_IN_REPLACE="sed -i ''"
else
    # Linux
    SED_IN_REPLACE="sed -i"
fi


echo -e "${YELLOW} 更新 pubspec.yaml....${NC}"
$SED_IN_REPLACE "s/name: $OLD_PROJECT_NAME/name: $NEW_PROJECT_NAME/" pubspec.yaml

# 2. 更改 Android 配置
echo -e "${YELLOW}更新 Android 配置...${NC}"
# 更新 build.gradle
$SED_IN_REPLACE "s/applicationId \"$OLD_PACKAGE_NAME\"/applicationId \"$PACKAGE_NAME\"/" android/app/build.gradle

# 更新 AndroidManifest.xml 文件
$SED_IN_REPLACE "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/main/AndroidManifest.xml
$SED_IN_REPLACE "s/android:label=\"$OLD_DISPLAY_NAME\"/android:label=\"$DISPLAY_NAME\"/" android/app/src/main/AndroidManifest.xml

# 更新 MainActivity.java
$SED_IN_REPLACE "s/package $OLD_PACKAGE_NAME/package $PACKAGE_NAME/" android/app/src/main/kotlin/com/rizzlt/flutter/starter/MainActivity.java

# 更新 debug AndroidManifest.xml
if [ -f "android/app/src/debug/AndroidManifest.xml" ]; then
    $SED_IN_REPLACE "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/debug/AndroidManifest.xml
fi

# 更新 profile AndroidManifest.xml
if [ -f "android/app/src/profile/AndroidManifest.xml" ]; then
    $SED_IN_REPLACE "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/profile/AndroidManifest.xml
fi

# 3. 更改 iOS 配置
echo -e "${YELLOW}更新 iOS 配置...${NC}"
# 更新 Info.plist
$SED_IN_REPLACE "s/<string>$OLD_DISPLAY_NAME<\/string>/<string>$DISPLAY_NAME<\/string>/" ios/Runner/Info.plist
$SED_IN_REPLACE "s/<string>$OLD_PROJECT_NAME<\/string>/<string>$NEW_PROJECT_NAME<\/string>/" ios/Runner/Info.plist

# 更新 project.pbxproj
$SED_IN_REPLACE "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/" ios/Runner.xcodeproj/project.pbxproj

# 4. 更改 macOS 配置
echo -e "${YELLOW}更新 macOS 配置...${NC}"
if [ -d "macos" ]; then
    # 更新 Info.plist
    if [ -f "macos/Runner/Info.plist" ]; then
        $SED_IN_REPLACE "s/<string>flutter_boilerplate_project<\/string>/<string>$NEW_PROJECT_NAME<\/string>/" macos/Runner/Info.plist
    fi

    # 更新 project.pbxproj
    if [ -f "macos/Runner.xcodeproj/project.pbxproj" ]; then
        $SED_IN_REPLACE "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/" macos/Runner.xcodeproj/project.pbxproj
    fi

    # 更新 AppInfo.xcconfig
    if [ -f "macos/Runner/Configs/AppInfo.xcconfig" ]; then
        $SED_IN_REPLACE "s/PRODUCT_NAME = flutter_boilerplate_project/PRODUCT_NAME = $NEW_PROJECT_NAME/" macos/Runner/Configs/AppInfo.xcconfig
        $SED_IN_REPLACE "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/" macos/Runner/Configs/AppInfo.xcconfig
    fi
fi

# 5. 更改 Linux 配置
echo -e "${YELLOW}更新 Linux 配置...${NC}"
if [ -d "linux" ]; then
    # 更新 my_application.cc
    if [ -f "linux/my_application.cc" ]; then
        $SED_IN_REPLACE "s/gtk_header_bar_set_title(header_bar, \"flutter_boilerplate_project\")/gtk_header_bar_set_title(header_bar, \"$DISPLAY_NAME\")/" linux/my_application.cc
        $SED_IN_REPLACE "s/gtk_window_set_title(window, \"flutter_boilerplate_project\")/gtk_window_set_title(window, \"$DISPLAY_NAME\")/" linux/my_application.cc
    fi

    # 更新 CMakeLists.txt
    if [ -f "linux/CMakeLists.txt" ]; then
        $SED_IN_REPLACE "s/project(flutter_boilerplate_project LANGUAGES CXX)/project($NEW_PROJECT_NAME LANGUAGES CXX)/" linux/CMakeLists.txt
        $SED_IN_REPLACE "s/set(BINARY_NAME \"flutter_boilerplate_project\")/set(BINARY_NAME \"$NEW_PROJECT_NAME\")/" linux/CMakeLists.txt
    fi
fi

# 6. 更改 Windows 配置
echo -e "${YELLOW}更新 Windows 配置...${NC}"
if [ -d "windows" ]; then
    # 更新 CMakeLists.txt
    if [ -f "windows/CMakeLists.txt" ]; then
        $SED_IN_REPLACE "s/project(flutter_boilerplate_project LANGUAGES CXX)/project($NEW_PROJECT_NAME LANGUAGES CXX)/" windows/CMakeLists.txt
        $SED_IN_REPLACE "s/set(BINARY_NAME \"flutter_boilerplate_project\")/set(BINARY_NAME \"$NEW_PROJECT_NAME\")/" windows/CMakeLists.txt
    fi

    # 更新 main.cpp
    if [ -f "windows/runner/main.cpp" ]; then
        $SED_IN_REPLACE "s/L\"flutter_boilerplate_project\"/L\"$DISPLAY_NAME\"/" windows/runner/main.cpp
    fi

    # 更新 Runner.rc
    if [ -f "windows/runner/Runner.rc" ]; then
        $SED_IN_REPLACE "s/VALUE \"FileDescription\", \"flutter_boilerplate_project\"/VALUE \"FileDescription\", \"$DISPLAY_NAME\"/" windows/runner/Runner.rc
        $SED_IN_REPLACE "s/VALUE \"InternalName\", \"flutter_boilerplate_project\"/VALUE \"InternalName\", \"$NEW_PROJECT_NAME\"/" windows/runner/Runner.rc
        $SED_IN_REPLACE "s/VALUE \"OriginalFilename\", \"flutter_boilerplate_project.exe\"/VALUE \"OriginalFilename\", \"$NEW_PROJECT_NAME.exe\"/" windows/runner/Runner.rc
        $SED_IN_REPLACE "s/VALUE \"ProductName\", \"flutter_boilerplate_project\"/VALUE \"ProductName\", \"$DISPLAY_NAME\"/" windows/runner/Runner.rc
    fi
fi

# 7. 更改 Web 配置
echo -e "${YELLOW}更新 Web 配置...${NC}"
if [ -d "web" ]; then
    # 更新 index.html
    if [ -f "web/index.html" ]; then
        $SED_IN_REPLACE "s/<title>flutter_boilerplate_project<\/title>/<title>$DISPLAY_NAME<\/title>/" web/index.html
        $SED_IN_REPLACE "s/content=\"flutter_boilerplate_project\"/content=\"$DISPLAY_NAME\"/" web/index.html
    fi

    # 更新 manifest.json
    if [ -f "web/manifest.json" ]; then
        $SED_IN_REPLACE "s/\"name\": \"flutter_boilerplate_project\"/\"name\": \"$DISPLAY_NAME\"/" web/manifest.json
        $SED_IN_REPLACE "s/\"short_name\": \"flutter_boilerplate_project\"/\"short_name\": \"$DISPLAY_NAME\"/" web/manifest.json
    fi
fi

# 8. 更新 lib/constants/strings.dart 中的應用名稱
echo -e "${YELLOW}更新應用常數...${NC}"
if [ -f "lib/constants/strings.dart" ]; then
    $SED_IN_REPLACE "s/static const String appName = \"Boilerplate Project\"/static const String appName = \"$DISPLAY_NAME\"/" lib/constants/strings.dart
fi

# 9. 運行 flutter pub get 更新依賴
echo -e "${YELLOW}更新依賴...${NC}"
flutter pub get

# 10. 運行 flutter pub run build_runner build 生成必要文件
echo -e "${YELLOW}生成必要文件...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs

echo -e "${YELLOW}更新 Dart 文件中的 import 語句...${NC}"
find . -name "*.dart" -type f -exec $SED_IN_PLACE "s/package:$OLD_PROJECT_NAME\//package:$NEW_PROJECT_NAME\//g" {} \;

echo -e "${GREEN}專案重命名完成!${NC}"
echo -e "${BLUE}新專案名稱: $NEW_PROJECT_NAME${NC}"
echo -e "${BLUE}套件名稱: $PACKAGE_NAME${NC}"
echo -e "${BLUE}顯示名稱: $DISPLAY_NAME${NC}"
echo ""
echo -e "${YELLOW}注意: 如果你需要更改 Java/Kotlin 包結構，請手動調整 Android 源碼文件。${NC}"
echo -e "${YELLOW}你可能需要重新打開 IDE 以應用所有更改。${NC}"

