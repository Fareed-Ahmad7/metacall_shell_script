echo installing Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo Downloading dependencies
brew install cmake
brew install nasm
brew install node
brew install ruby
brew install pyenv
brew install wget
brew install zip
brew install unzip
brew install --cask dotnet
brew install --cask dotnet-sdk
pyenv install 3.10.2
npm i headers

#!/bin/bash
LOC= /Users/fareedahammad   # change path later to universal

# Tarball directory
mkdir metacall
cd metacall

mkdir dependencies
cd dependencies

mkdir node_packages
cd node_packages

echo installing node-shared
wget https://github.com/metacall/node.dll/releases/download/v0.0.1/node-shared-v14.18.2-x64.zip
unzip node-shared-v14.18.2-x64.zip 
rm node-shared-v14.18.2-x64.zip

echo installing NodeJS DLL
wget https://raw.githubusercontent.com/metacall/core/66fcaac300611d1c4210023e7b260296586a42e0/cmake/NodeJSGYPPatch.py  # --- check if this file is appropriate for macos


echo Building MetaCall
cd $LOC

git clone --depth 1 https://github.com/metacall/core.git


# Patch for FindRuby.cmake
# Patch for FindPython.cmake
# Patch for FindCoreCLR.cmake
# Patch for FindDotNET.cmake
# Patch for FindNodeJS.cmake


mkdir $loc/core/build
cd $loc/core/build

# Build MetaCall

cmake -Wno-dev ^
	-DCMAKE_BUILD_TYPE=Release ^
	-DOPTION_BUILD_SECURITY=OFF ^
	-DOPTION_FORK_SAFE=OFF ^
	-DOPTION_BUILD_SCRIPTS=OFF ^
	-DOPTION_BUILD_TESTS=OFF ^
	-DOPTION_BUILD_EXAMPLES=OFF ^
	-DOPTION_BUILD_LOADERS_PY=ON ^
	-DOPTION_BUILD_LOADERS_NODE=ON ^
	-DNPM_ROOT= $escaped_loc/runtimes/nodejs^  # change path
	-DOPTION_BUILD_LOADERS_CS=ON ^
	-DOPTION_BUILD_LOADERS_RB=ON ^
	-DOPTION_BUILD_LOADERS_TS=ON ^
	-DOPTION_BUILD_PORTS=ON ^
	-DOPTION_BUILD_PORTS_PY=ON ^
	-DOPTION_BUILD_PORTS_NODE=ON ^
	-DCMAKE_INSTALL_PREFIX= $LOC ^    # change path
	-G "NMake Makefiles" ..
cmake --build . --target install

echo MetaCall Built Successfully