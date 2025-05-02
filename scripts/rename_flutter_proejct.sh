#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE} === Rename your project === ${NC}"
echo ""

# Check if we're already in the flutter_boilerplate_project directory
if [[ ! -f "pubspec.yaml" ]] || ! grep -q "name: boilerplate" pubspec.yaml; then
    echo -e "${RED}Error: Please run this script in the flutter_boilerplate_project root directory${NC}"
    exit 1
fi

read -p "Please enter the new project name: " NEW_PROJECT_NAME
echo -e "${GREEN}New project name: ${NEW_PROJECT_NAME}${NC}"

if ! [[ $NEW_PROJECT_NAME =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo -e "${RED}Error: Project name must start with a lowercase letter and can only contain lowercase letters, numbers, and underscores${NC}"
    exit 1
fi

read -p "Please enter your package name for the identifier of Andriod and IOS: " PACKAGE_NAME
echo -e "${GREEN}New package name: ${PACKAGE_NAME}${NC}"

if ! [[ $PACKAGE_NAME =~ ^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$ ]]; then
    echo -e "${RED}Error: Package name must start with a lowercase letter and can only contain lowercase letters, numbers, and underscores${NC}"
    exit 1
fi

read -p "Please enter your display name: " DISPLAY_NAME
echo ""
echo -e "${YELLOW}The following changes will be made:${NC}"
echo -e "Project name: ${GREEN} $NEW_PROJECT_NAME${NC}"
echo -e "Package name: ${GREEN} $PACKAGE_NAME${NC}"
echo -e "Display name: ${GREEN} $DISPLAY_NAME${NC}"
echo ""

read -p "Would you proceed? (y/n): " CONFIRM

if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
   echo -e "${YELLOW}Bye Bye"
   exit 0
fi

# Save current directory
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


echo -e "${YELLOW}Updating pubspec.yaml....${NC}"
$SED_IN_REPLACE "s/name: $OLD_PROJECT_NAME/name: $NEW_PROJECT_NAME/" pubspec.yaml

# 2. Change Android configuration
echo -e "${YELLOW}Updating Android configuration...${NC}"
# Update build.gradle
$SED_IN_REPLACE "s/applicationId \"$OLD_PACKAGE_NAME\"/applicationId \"$PACKAGE_NAME\"/" android/app/build.gradle

# Update AndroidManifest.xml files
$SED_IN_REPLACE "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/main/AndroidManifest.xml
$SED_IN_REPLACE "s/android:label=\"$OLD_DISPLAY_NAME\"/android:label=\"$DISPLAY_NAME\"/" android/app/src/main/AndroidManifest.xml

# Update MainActivity.java
$SED_IN_REPLACE "s/package $OLD_PACKAGE_NAME/package $PACKAGE_NAME/" android/app/src/main/kotlin/com/rizzlt/flutter/starter/MainActivity.java

# Update debug AndroidManifest.xml
if [ -f "android/app/src/debug/AndroidManifest.xml" ]; then
    $SED_IN_REPLACE "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/debug/AndroidManifest.xml
fi

# Update profile AndroidManifest.xml
if [ -f "android/app/src/profile/AndroidManifest.xml" ]; then
    $SED_IN_REPLACE "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$PACKAGE_NAME\"/" android/app/src/profile/AndroidManifest.xml
fi

# 3. Change iOS configuration
echo -e "${YELLOW}Updating iOS configuration...${NC}"
# Update Info.plist
$SED_IN_REPLACE "s/<string>$OLD_DISPLAY_NAME<\/string>/<string>$DISPLAY_NAME<\/string>/" ios/Runner/Info.plist
$SED_IN_REPLACE "s/<string>$OLD_PROJECT_NAME<\/string>/<string>$NEW_PROJECT_NAME<\/string>/" ios/Runner/Info.plist

# Update project.pbxproj
$SED_IN_REPLACE "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/" ios/Runner.xcodeproj/project.pbxproj

# 4. Change macOS configuration
echo -e "${YELLOW}Updating macOS configuration...${NC}"
if [ -d "macos" ]; then
    # Update Info.plist
    if [ -f "macos/Runner/Info.plist" ]; then
        $SED_IN_REPLACE "s/<string>flutter_boilerplate_project<\/string>/<string>$NEW_PROJECT_NAME<\/string>/" macos/Runner/Info.plist
    fi

    # Update project.pbxproj
    if [ -f "macos/Runner.xcodeproj/project.pbxproj" ]; then
        $SED_IN_REPLACE "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/" macos/Runner.xcodeproj/project.pbxproj
    fi

    # Update AppInfo.xcconfig
    if [ -f "macos/Runner/Configs/AppInfo.xcconfig" ]; then
        $SED_IN_REPLACE "s/PRODUCT_NAME = flutter_boilerplate_project/PRODUCT_NAME = $NEW_PROJECT_NAME/" macos/Runner/Configs/AppInfo.xcconfig
        $SED_IN_REPLACE "s/PRODUCT_BUNDLE_IDENTIFIER = $OLD_PACKAGE_NAME/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/" macos/Runner/Configs/AppInfo.xcconfig
    fi
fi

# 5. Change Linux configuration
echo -e "${YELLOW}Updating Linux configuration...${NC}"
if [ -d "linux" ]; then
    # Update my_application.cc
    if [ -f "linux/my_application.cc" ]; then
        $SED_IN_REPLACE "s/gtk_header_bar_set_title(header_bar, \"flutter_boilerplate_project\")/gtk_header_bar_set_title(header_bar, \"$DISPLAY_NAME\")/" linux/my_application.cc
        $SED_IN_REPLACE "s/gtk_window_set_title(window, \"flutter_boilerplate_project\")/gtk_window_set_title(window, \"$DISPLAY_NAME\")/" linux/my_application.cc
    fi

    # Update CMakeLists.txt
    if [ -f "linux/CMakeLists.txt" ]; then
        $SED_IN_REPLACE "s/project(flutter_boilerplate_project LANGUAGES CXX)/project($NEW_PROJECT_NAME LANGUAGES CXX)/" linux/CMakeLists.txt
        $SED_IN_REPLACE "s/set(BINARY_NAME \"flutter_boilerplate_project\")/set(BINARY_NAME \"$NEW_PROJECT_NAME\")/" linux/CMakeLists.txt
    fi
fi

# 6. Change Windows configuration
echo -e "${YELLOW}Updating Windows configuration...${NC}"
if [ -d "windows" ]; then
    # Update CMakeLists.txt
    if [ -f "windows/CMakeLists.txt" ]; then
        $SED_IN_REPLACE "s/project(flutter_boilerplate_project LANGUAGES CXX)/project($NEW_PROJECT_NAME LANGUAGES CXX)/" windows/CMakeLists.txt
        $SED_IN_REPLACE "s/set(BINARY_NAME \"flutter_boilerplate_project\")/set(BINARY_NAME \"$NEW_PROJECT_NAME\")/" windows/CMakeLists.txt
    fi

    # Update main.cpp
    if [ -f "windows/runner/main.cpp" ]; then
        $SED_IN_REPLACE "s/L\"flutter_boilerplate_project\"/L\"$DISPLAY_NAME\"/" windows/runner/main.cpp
    fi

    # Update Runner.rc
    if [ -f "windows/runner/Runner.rc" ]; then
        $SED_IN_REPLACE "s/VALUE \"FileDescription\", \"flutter_boilerplate_project\"/VALUE \"FileDescription\", \"$DISPLAY_NAME\"/" windows/runner/Runner.rc
        $SED_IN_REPLACE "s/VALUE \"InternalName\", \"flutter_boilerplate_project\"/VALUE \"InternalName\", \"$NEW_PROJECT_NAME\"/" windows/runner/Runner.rc
        $SED_IN_REPLACE "s/VALUE \"OriginalFilename\", \"flutter_boilerplate_project.exe\"/VALUE \"OriginalFilename\", \"$NEW_PROJECT_NAME.exe\"/" windows/runner/Runner.rc
        $SED_IN_REPLACE "s/VALUE \"ProductName\", \"flutter_boilerplate_project\"/VALUE \"ProductName\", \"$DISPLAY_NAME\"/" windows/runner/Runner.rc
    fi
fi

# 7. Change Web configuration
echo -e "${YELLOW}Updating Web configuration...${NC}"
if [ -d "web" ]; then
    # Update index.html
    if [ -f "web/index.html" ]; then
        $SED_IN_REPLACE "s/<title>flutter_boilerplate_project<\/title>/<title>$DISPLAY_NAME<\/title>/" web/index.html
        $SED_IN_REPLACE "s/content=\"flutter_boilerplate_project\"/content=\"$DISPLAY_NAME\"/" web/index.html
    fi

    # Update manifest.json
    if [ -f "web/manifest.json" ]; then
        $SED_IN_REPLACE "s/\"name\": \"flutter_boilerplate_project\"/\"name\": \"$DISPLAY_NAME\"/" web/manifest.json
        $SED_IN_REPLACE "s/\"short_name\": \"flutter_boilerplate_project\"/\"short_name\": \"$DISPLAY_NAME\"/" web/manifest.json
    fi
fi

# 8. Update application name in lib/constants/strings.dart
echo -e "${YELLOW}Updating application constants...${NC}"
if [ -f "lib/constants/strings.dart" ]; then
    $SED_IN_REPLACE "s/static const String appName = \"Boilerplate Project\"/static const String appName = \"$DISPLAY_NAME\"/" lib/constants/strings.dart
fi

# 9. Run flutter pub get to update dependencies
echo -e "${YELLOW}Updating dependencies...${NC}"
flutter pub get

# 10. Run flutter pub run build_runner build to generate necessary files
echo -e "${YELLOW}Generating necessary files...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs

echo -e "${YELLOW}Updating import statements in Dart files...${NC}"
find . -name "*.dart" -type f -exec $SED_IN_PLACE "s/package:$OLD_PROJECT_NAME\//package:$NEW_PROJECT_NAME\//g" {} \;

echo -e "${GREEN}Project rename completed!${NC}"
echo -e "${BLUE}New project name: $NEW_PROJECT_NAME${NC}"
echo -e "${BLUE}Package name: $PACKAGE_NAME${NC}"
echo -e "${BLUE}Display name: $DISPLAY_NAME${NC}"
echo ""
echo -e "${YELLOW}Note: If you need to change the Java/Kotlin package structure, please adjust the Android source files manually.${NC}"
echo -e "${YELLOW}You may need to reopen your IDE to apply all changes.${NC}"
