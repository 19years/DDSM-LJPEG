# DDSM-LJPEG
This repository is created for converting Mammography of [Digital Database for Screening Mammography (DDSM)](http://marathon.csee.usf.edu/Mammography/Database.html) form LJPEG to more ordinary format.


## Install
1. Download the resources.
```
# make sure to clone with --recursive
git clone --recursive git@github.com:Xiaoming-Zhao/DDSM-LJPEG.git
```

2. ljpeg
```
cd ljpeg/jpegdir
make
```

3. ddsm
```
cd ddsm/ddsm-software
g++ -Wall -O2 ddsmraw2pnm.c -o ddsmraw2pnm
```