Installation de QWT sur ubuntu
==============================

Download
--------

Download the zip [here](https://sourceforge.net/projects/qwt/files/qwt/?SetFreedomCookie).
Extract it.

Installation
------------

```bash
cd ~/Téléchargements/qwt-6.1.3
~/Qt/5.8/gcc_64/bin/qmake qwt.pro
make -j4
sudo make install
```

Liaison des librairies
----------------------

```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qwt-6.1.3/lib
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qwt-6.1.3/lib' >> ~/.bashrc
echo '/usr/local/qwt-6.1.3/lib' | sudo tee -a /etc/ld.so.conf
sudo ldconfig
```

Liason qwt au projet Qt
-----------------------

Ajouter dans le fichier .pro du projet :

```txt
CONFIG += qwt
LIBS += -lqwt
INCLUDEPATH += /usr/local/qwt-6.1.3/include/
LIBS += -L "/usr/local/qwt-6.1.3/lib/"
```

Sources
-------

- [http://qwt.sourceforge.net/qwtinstall.html](http://qwt.sourceforge.net/qwtinstall.html)
- [https://codeyarns.com/2014/01/14/how-to-add-library-directory-to-ldconfig-cache/](https://codeyarns.com/2014/01/14/how-to-add-library-directory-to-ldconfig-cache/)
