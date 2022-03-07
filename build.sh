echo installing Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo Downloading dependencies
brew install cmake
brew install wget
brew install zip
brew install unzip
brew install p7zip

#!/bin/bash
LOC= /Users/fareedahammad   # change path later to universal

# Tarball directory
mkdir metacall
cd metacall

mkdir dependencies
cd dependencies

echo Installing Runtimes

mkdir runtimes

echo installing ruby
mkdir runtimes/ruby
cd runtimes/ruby
wget https://github.com/MSP-Greg/ruby-loco/releases/download/ruby-master/ruby-mswin.7z    # --- i dont know which file is for mac
7za e ruby-mswin.7z
rm ruby-mswin.7z
cd ruby-mswin
./configure
make
cd ../

echo installing python
mkdir python
cd python
wget https://www.python.org/ftp/python/3.9.10/python-3.9.10-macos11.pkg
installer -pkg python-3.9.10-macos11.pkg -target $LOC/Desktop/Metacall/metacall/dependencies/runtimes/python
rm python-3.9.10-macos11.pkg
cd ../

echo installing dotnet
mkdir dotnet
cd dotnet
# --- the below zip is for windows. so find dotnet installer for macos
wget https://download.visualstudio.microsoft.com/download/pr/d1ca6dbf-d054-46ba-86d1-36eb2e455ba2/e950d4503116142d9c2129ed65084a15/dotnet-sdk-5.0.403-win-x64.zip  
unzip dotnet-sdk-5.0.403-win-x64.zip
rm dotnet-sdk-5.0.403-win-x64.zip
cd dotnet-sdk-5.0.403-win-x64
./configure
make
cd ../

echo installing nodejs
mkdir nodejs
cd nodejs
wget https://nodejs.org/download/release/v14.18.2/node-v14.18.2.tar.gz
tar -xzf node-v14.18.2.tar.gz
rm node-v14.18.2.tar.gz
cd node-v14.18.2
./configure
make

echo installing nodejs headers
wget https://nodejs.org/download/release/v14.18.2/node-v14.18.2-headers.tar.gz
tar -xzf node-v14.18.2-headers.tar.gz
rm node-v14.18.2-headers.tar.gz
cd node-v14.18.2-headers
./configure
make

echo installing node-shared
wget https://github.com/metacall/node.dll/releases/download/v0.0.1/node-shared-v14.18.2-x64.zip
unzip node-shared-v14.18.2-x64.zip 
rm node-shared-v14.18.2-x64.zip
cd node-shared-v14.18.2-x64
./configure
make

echo installing NodeJS DLL
wget https://raw.githubusercontent.com/metacall/core/66fcaac300611d1c4210023e7b260296586a42e0/cmake/NodeJSGYPPatch.py


echo Building MetaCall
cd $LOC

git clone --depth 1 https://github.com/metacall/core.git


# Patch for FindRuby.cmake
# Patch for FindPython.cmake
# Patch for FindCoreCLR.cmake
# Patch for FindDotNET.cmake
# Patch for FindNodeJS.cmake


mkdir $LOC/core/build
cd $LOC/core/build

# Build MetaCall

cmake -Wno-dev \
	-DCMAKE_BUILD_TYPE=Release \
	-DOPTION_BUILD_SECURITY=OFF \
	-DOPTION_FORK_SAFE=OFF \
	-DOPTION_BUILD_SCRIPTS=OFF \
	-DOPTION_BUILD_TESTS=OFF \
	-DOPTION_BUILD_EXAMPLES=OFF \
	-DOPTION_BUILD_LOADERS_PY=ON \
	-DOPTION_BUILD_LOADERS_NODE=ON \
	-DNPM_ROOT= $escaped_loc/runtimes/nodejs\  # change path
	-DOPTION_BUILD_LOADERS_CS=ON \
	-DOPTION_BUILD_LOADERS_RB=ON \
	-DOPTION_BUILD_LOADERS_TS=ON \
	-DOPTION_BUILD_PORTS=ON \
	-DOPTION_BUILD_PORTS_PY=ON \
	-DOPTION_BUILD_PORTS_NODE=ON \
	-DCMAKE_INSTALL_PREFIX= $LOC \    # change path
	-G "NMake Makefiles" ..
cmake --build . --target install

echo MetaCall Built Successfully