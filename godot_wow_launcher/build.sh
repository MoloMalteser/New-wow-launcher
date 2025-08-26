#!/bin/bash

# Godot WoW Launcher Build Script
# This script helps build the launcher for different platforms

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="wow_launcher"
GODOT_VERSION="4.2"
BUILD_DIR="builds"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Godot is available
check_godot() {
    if ! command -v godot &> /dev/null; then
        print_error "Godot is not installed or not in PATH"
        print_status "Please install Godot $GODOT_VERSION and add it to your PATH"
        exit 1
    fi
    
    GODOT_VERSION_OUTPUT=$(godot --version 2>&1 || echo "unknown")
    print_status "Found Godot version: $GODOT_VERSION_OUTPUT"
}

# Function to create build directory
create_build_dir() {
    if [ ! -d "$BUILD_DIR" ]; then
        mkdir -p "$BUILD_DIR"
        print_status "Created build directory: $BUILD_DIR"
    fi
}

# Function to build for Windows
build_windows() {
    print_status "Building for Windows..."
    create_build_dir
    
    godot --headless --export-release "Windows Desktop" "$BUILD_DIR/${PROJECT_NAME}_windows.exe"
    
    if [ $? -eq 0 ]; then
        print_success "Windows build completed: $BUILD_DIR/${PROJECT_NAME}_windows.exe"
    else
        print_error "Windows build failed"
        exit 1
    fi
}

# Function to build for Linux
build_linux() {
    print_status "Building for Linux..."
    create_build_dir
    
    godot --headless --export-release "Linux/X11" "$BUILD_DIR/${PROJECT_NAME}_linux"
    
    if [ $? -eq 0 ]; then
        print_success "Linux build completed: $BUILD_DIR/${PROJECT_NAME}_linux"
        chmod +x "$BUILD_DIR/${PROJECT_NAME}_linux"
    else
        print_error "Linux build failed"
        exit 1
    fi
}

# Function to build for macOS
build_macos() {
    print_status "Building for macOS..."
    create_build_dir
    
    godot --headless --export-release "Mac OSX" "$BUILD_DIR/${PROJECT_NAME}_macos.zip"
    
    if [ $? -eq 0 ]; then
        print_success "macOS build completed: $BUILD_DIR/${PROJECT_NAME}_macos.zip"
    else
        print_error "macOS build failed"
        exit 1
    fi
}

# Function to build for Android
build_android() {
    print_status "Building for Android..."
    create_build_dir
    
    godot --headless --export-release "Android" "$BUILD_DIR/${PROJECT_NAME}_android.apk"
    
    if [ $? -eq 0 ]; then
        print_success "Android build completed: $BUILD_DIR/${PROJECT_NAME}_android.apk"
    else
        print_error "Android build failed"
        print_warning "Make sure you have Android SDK configured in Godot"
        exit 1
    fi
}

# Function to build for iOS
build_ios() {
    print_status "Building for iOS..."
    create_build_dir
    
    godot --headless --export-release "iOS" "$BUILD_DIR/${PROJECT_NAME}_ios.zip"
    
    if [ $? -eq 0 ]; then
        print_success "iOS build completed: $BUILD_DIR/${PROJECT_NAME}_ios.zip"
    else
        print_error "iOS build failed"
        print_warning "Make sure you have Xcode and iOS export configured in Godot"
        exit 1
    fi
}

# Function to build for all platforms
build_all() {
    print_status "Building for all platforms..."
    build_windows
    build_linux
    build_macos
    build_android
    build_ios
    print_success "All builds completed!"
}

# Function to clean build directory
clean_builds() {
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
        print_status "Cleaned build directory"
    else
        print_warning "Build directory does not exist"
    fi
}

# Function to show help
show_help() {
    echo "Godot WoW Launcher Build Script"
    echo ""
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  windows    Build for Windows"
    echo "  linux      Build for Linux"
    echo "  macos      Build for macOS"
    echo "  android    Build for Android"
    echo "  ios        Build for iOS"
    echo "  all        Build for all platforms"
    echo "  clean      Clean build directory"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 windows    # Build for Windows only"
    echo "  $0 all        # Build for all platforms"
    echo "  $0 clean      # Clean build directory"
}

# Main script logic
main() {
    print_status "Godot WoW Launcher Build Script"
    print_status "Project: $PROJECT_NAME"
    
    # Check if Godot is available
    check_godot
    
    # Parse command line arguments
    case "${1:-help}" in
        windows)
            build_windows
            ;;
        linux)
            build_linux
            ;;
        macos)
            build_macos
            ;;
        android)
            build_android
            ;;
        ios)
            build_ios
            ;;
        all)
            build_all
            ;;
        clean)
            clean_builds
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"