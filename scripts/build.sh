#!/bin/bash

INSTALL_DIR=${1}

[ -z ${INSTALL_DIR} ] && echo "[error] missing argument" && echo "usage: ${0} <install-directory>" && exit

function os_linux()
{
	_system=$(uname -a | cut -f 1 -d " ")
	[ $_system == "Linux" ] && echo "True"
}

function os_darwin()
{
	_system=$(uname -a | cut -f 1 -d " ")
	[ $_system == "Darwin" ] && echo "True"
}

function n_cores()
{
	local _ncores="1"
	[ $(os_darwin) ] && local _ncores=$(system_profiler SPHardwareDataType | grep "Number of Cores" | cut -f 2 -d ":" | sed 's| ||')
	[ $(os_linux) ] && local _ncores=$(lscpu | grep "CPU(s):" | head -n 1 | cut -f 2 -d ":" | sed 's| ||g')
	#[ ${_ncores} -gt "1" ] && retval=$(_ncores-1)
	echo ${_ncores}
}

function thisdir()
{
        SOURCE="${BASH_SOURCE[0]}"
        while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
          DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
          SOURCE="$(readlink "$SOURCE")"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        done
        DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        echo ${DIR}
}
SCRIPTPATH=$(thisdir)

mkdir -p ${SCRIPTPATH}/../build
cd ${SCRIPTPATH}/../build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DCMAKE_BUILD_TYPE=Release ${HOME}/devel/jqt \
&& cmake --build . --target all -- -j $(n_cores) \
&& cmake --build . --target install
cd -

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${INSTALL_DIR}/lib
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:${INSTALL_DIR}/lib
export PATH=$PATH:${INSTALL_DIR}/bin

