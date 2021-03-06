# Functions for installing Emergent 7.0.1 and its dependencies

# The directory in which to install Quarter and Emergent. If you change this,
# be sure to update emergent.desktop (the desktop shortcut) as well.
PREFIX=/usr/local

# The directory in which to install Qt
QTPREFIX=/opt/Qt5.2.1

# The path to the QT installation
export QTDIR=$QTPREFIX/5.2.1/gcc_64

SCRIPTDIR=$(dirname $(realpath $0))

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export CFLAGS="-I/usr/include $CFLAGS"
export CXXFLAGS="-I/usr/include $CXXFLAGS"

# Install as many of Emergent's dependencies we can through the package manger.
# This function installs general build tools as well so it should be run first.
install_deps() {
    DEPS="cmake libcoin80-dev libgsl-dev libjpeg-dev libpng-dev \
libreadline-dev libsndfile-dev pkg-config subversion zlib1g-dev \
build-essential libfontconfig1-dev libfreetype6-dev libx11-dev libxfixes-dev \
libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev \
libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev \
libxcb-sync0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev \
libxcb-render-util0-dev libncurses-dev libsqlite3-dev \
libgstreamer-plugins-base0.10-dev libapr1-dev libaprutil1-dev libserf-dev \
libserf-1-1 subversion"
    apt-get update
    apt-get install $DEPS -y
}


# Emergent depends on SVN 1.8.x, but Xenial only provides 1.9+ in repos
download_svn() {
    mkdir -p /usr/local/src/tars
    cd /usr/local/src/tars
    wget --progress=bar:force:noscroll \
http://mirror.nexcess.net/apache/subversion/subversion-1.8.17.tar.gz
    cd ..
    tar -xzf tars/subversion-1.8.17.tar.gz
}


install_svn() {
    cd /usr/local/src/subversion-1.8.17
    ./configure --prefix=$PREFIX
    make -j4 && make install
    # Our svn is built without HTTP(S) support, so default to the system binary
    # We only need our build for the libraries.
    rm /usr/local/bin/svn
}


download_qt() {
    cd $SCRIPTDIR
    wget --progress=bar:force:noscroll \
https://download.qt.io/archive/qt/5.2/5.2.1/qt-opensource-linux-x64-5.2.1.run
    chmod +x qt-opensource-linux-x64-5.2.1.run
}


install_qt() {
    cd $SCRIPTDIR
    ./qt-opensource-linux-x64-5.2.1.run --script qt-installer.qs
    rm qt-opensource-linux-x64-5.2.1.run

    # Add the library directory to the LD config You still need to run
    # sudo ldconfig to rebuild the cache, this is done
    # post-installation
    echo "$QTDIR/lib" >> /etc/ld.so.conf
}


# The ODE version in the Xenial repos causes compile errors, so we
# install from source
download_ode() {
    mkdir -p /usr/local/src/tars
    cd /usr/local/src/tars
    wget --progress=bar:force:noscroll \
https://downloads.sourceforge.net/project/opende/ODE/0.13/ode-0.13.tar.bz2
    cd ..
    tar -xjf tars/ode-0.13.tar.bz2
}


install_ode() {
    cd /usr/local/src/ode-0.13
    ./configure --prefix=$PREFIX --enable-shared
    make && make install
}


download_quarter() {
    mkdir -p /usr/local/src
    cd /usr/local/src
    svn co -q --username anonymous --password emergent\
        https://grey.colorado.edu/svn/coin3d/quarter/trunk quarter-trunk
}


install_quarter() {
    cd /usr/local/src/quarter-trunk
    export CPPFLAGS="-I$QTDIR/include/QtCore -I$QTDIR/include/QtWidgets \
-I$QTDIR/include/QtOpenGL -I$QTDIR/include/QtGui -fPIC"
    export CONFIG_QTLIBS="-lQt5Core -lQt5Widgets -lQt5OpenGL -lQt5Gui \
-lQt5Designer -lQt5UiTools -lQt5Xml -l:libicui18n.so.51 -l:libicuuc.so.51 \
-l:libicudata.so.51"
    ./configure --prefix=$PREFIX --disable-pkgconfig --disable-debug\
                --with-qt=$QTDIR \
                --with-qt-designer-plugin-path=$QTDIR/plugins/designer
    make -j8 && make install
    unset CONFIG_QTLIBS
    unset CPPFLAGS
}


download_emergent() {
    mkdir -p /usr/local/src
    cd /usr/local/src
    svn co -q https://grey.colorado.edu/svn/emergent/emergent/tags/7.0.1/\
        emergent-7.0.1
}


install_emergent() {
    cd /usr/local/src/emergent-7.0.1
    ./configure --prefix=$PREFIX --qt5 --flags="-DCMAKE_PREFIX_PATH=$PREFIX"
    make -j4 && make install
}


loose_ends() {
    # Modify paths
    echo "export LD_LIBRARY_PATH=$PREFIX/lib:"'$LD_LIBRARY_PATH' \
         >> ~/.bashrc
    echo "export PATH=$PREFIX/bin:"'$PATH' >> ~/.bashrc
    echo "export QTDIR=$QTDIR" >> ~/.bashrc
    echo "export QTDIR=$QTDIR" > /etc/profile.d/qtdir.sh 

    # Rebuild the dynamic library cache
    ldconfig
}
