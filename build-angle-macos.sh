#!/bin/bash
set -e

# Install ninja
brew install ninja

# Get depot tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PWD/depot_tools:$PATH

# Get source code of angle
git clone https://chromium.googlesource.com/angle/angle
cd angle
python3 scripts/bootstrap.py
gclient sync

# Configure project
gn gen out/Release --args='is_debug=false angle_enable_d3d9=false angle_enable_d3d11=false angle_enable_gl=false angle_enable_null=false angle_enable_metal=true angle_enable_vulkan=false angle_enable_essl=false angle_enable_glsl=false is_component_build=false treat_warnings_as_errors=false'

# Build project
ninja -j `sysctl -n hw.logicalcpu` -k1 -C out/Release

# Find libEGL.dylib and libGLESv2.dylib in angle/out/Release/