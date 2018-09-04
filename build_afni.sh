# Written by Bill Gross, 9/4/2018
#
# Meant to install AFNI on an updated Mac, using Homebrew, with minimal interaction with the user

MAKENAME=macos_10.12_homebrew

AFNI_URL="https://afni.nimh.nih.gov/pub/dist/tgz/afni_src.tgz"
CONDA_INSTALL="Miniconda2-latest-MacOSX-x86_64.sh"
CONDA_URL="https://repo.continuum.io/miniconda/$conda"
HOMEBREW_INSTALL='/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
HOMEBREW_DEPS="gcc@8 openmotif gsl open-mpi glib gts pkg-config libpgm mesalib-glw"

CONDA_DIR="$HOME/miniconda2"
AFNI_SRCDIR="$HOME/afni_src"
AFNI_DIR="$HOME/afni"

# install anaconda
if [ ! -d $CONDA_DIR ]; then
  if [ ! -f $CONDA_INSTALL ]; then
    curl $CONDA_URL > $CONDA_INSTALL
  fi
  sh $CONDA_INSTALL -b -p $CONDA_DIR
fi

# get Homebrew
if ! `which -s brew`; then
  $HOMEBREW_INSTALL
fi

# install deps
brew install $HOMEBREW_DEPS

# get AFNI code
if [ ! -d $AFNI_SRCDIR ]; then
  curl $AFNI_URL | tar zx
fi

# build AFNI
cp Makefile.$MAKENAME $AFNI_SRCDIR/Makefile
pushd $AFNI_SRCDIR
make totality
popd
ln -s $AFNI_SRCDIR/$MAKENAME $AFNI_DIR

# Make sure a bashrc exists
if [ ! -f $HOME/.bashrc ]; then
  touch $HOME/.bash_profile
  ln $HOME/.bash_profile $HOME/.bashrc
fi

echo "export PATH=$CONDA_DIR/bin:$AFNI_DIR:\$PATH" >> $HOME/.bashrc
