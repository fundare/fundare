#!bin/bash
flutter clean;
cd ios;
sudo gem install cocoapods-deintegrate cocoapods-clean;
pod deintegrate;
pod clean;
rm Podfile;
cd ../;
flutter run;