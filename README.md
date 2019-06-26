# Jet Quenching Tools (jqt) 

  - moved JetToyHI - `almost` no changes in implementation
  - a warning fixed for `std::vector<double> softDropGroomer::getJetProfile(Int_t i) const`
     - returning empty vector if `i` outside of expected range

## Software

Inside the `PU14` directory you can find code we borrowed from the Pileup2014 workshop that takes care of reading in the events and mixing background with signal events.
Inside the `include` directory you can find a couple of classes performing background subtraction, grooming jets, and a jet-to-jet matching algorithm.
Follow the installation instructions below to run an example program.


## Install on personal laptop (more computationally involved)

If you are using mac or linux, the steps are relatively straightforward.  For windows machines I'm not sure what to do.  These are the things you need to install:

* C++ compiler: on mac you could install xcode (found on App Store) to get the g++ compilers
* Latest version of ROOT: follow instructions here https://root.cern.ch/downloading-root
* Fastjet and contrib package: follow the steps in the above about the fastjet installation
* Pythia 8: it can be found here - http://home.thep.lu.se/~torbjorn/Pythia.html

Make sure that the root-config, pythia8-config and fastjet-config executables can be found in the $PATH environment variable.  Once the above is done, we can proceed with the compilation of the JetToyHI code:

```
. ./scripts/build.sh <dir_to_install_to>
runFromFile -hard <dir_to_jqt_sources>/samples/PythiaEventsTune14PtHat120.pu14 -pileup <dir_to_jqt_sources>/samples/ThermalEventsMult12000PtAv0.70.pu14 -nev 10
```

## Install on lxplus (in the process of making up-to-date)

If you don't have an lxplus account, you can request one here: https://account.cern.ch/account/Externals/

First install fastjet and the contrib package (you only have to do this once)
```sh
ssh -Y <username>@lxplus.cern.ch

cd <dirInWhichYouWantToInstall>

source /cvmfs/sft.cern.ch/lcg/external/gcc/4.8.1/x86_64-slc6-gcc48-opt/setup.sh

source /cvmfs/sft.cern.ch/lcg/app/releases/ROOT/6.06.08/x86_64-slc6-gcc48-opt/root/bin/thisroot.sh

You will have produced a root file with a tree. In this tree properties of jets are stored in std::vector format and are all alligned to the signal jets. So you can for example plot `sigJetPt` vs `csJetPt` to get the response matrix for constituent-subtracted jets. An example ROOT plotting macro which will draw the jet energy and mass scale can be found here: `plot/plotJetEnergyScale.C`.


## Contribute
* If you want to contribute to this code you need to have a github account. Go here to do so: https://github.com/join.
* Fork the original repository. Go to: https://github.com/JetQuenchingTools/JetToyHI and click 'Fork' in the upper right corner.
* Instead of cloning the original repository as shown above, clone your own.
* After committing your changes to your own branch, push them to your own fork. Don't know how to do this, ask your colleages or use google which might bring you here https://services.github.com/on-demand/downloads/github-git-cheat-sheet/
* Do a pull request once you have finished your developements.

## Samples
Event samples can be found in the jet quenching CERNBOX:
* From lxplus: /eos/project/j/jetquenching/www
* Webbrowser CERNBOX: https://cernbox.cern.ch/index.php/s/kRy9M7NC9iilE9Z
* Webbrowser: http://jetquenchingtools.web.cern.ch/JetQuenchingTools/ (You can use wget and curl on this)
* Mount eos on a laptop or local desktop: https://cern.service-now.com/service-portal/article.do?n=KB0003493

You will find samples from various event generators. For underlying event we have: 'thermal' which is independent particle production using a Boltzmann distribution with a fixed multiplicity and mean p<sub>T</sub> (indicated in the file names). For the hard signal we have PYTHIA8 and JEWEL events with various p<sub>T,hat</sub> settings.

More details about the available samples can be found here: https://jetquenchingtools.github.io/ (public)
(old twiki at cern: https://twiki.cern.ch/twiki/bin/view/JetQuenchingTools/PU14Samples)


## convert PU14 to HepMC script -
Just compile and link with HepMC and run.
