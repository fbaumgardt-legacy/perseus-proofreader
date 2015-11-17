Manual
==============
0. Prerequisites: node.js, npm, libxml2 and cmake:<br>
  ```
sudo apt-get install git scala cmake node npm libxml2-dev && npm install -g coffee-script
  ```
1. Checkout project and ogl-data submodule:<br>
 ```
cd <Verzeichnis in dem der Proofreader Ordner liegen soll>
```<br>
 ```
git clone https://github.com/fbaumgardt/perseus-proofreader
```
2. Run npm install in root directory to install dependencies:<br>
 ```
cd perseus-proofreader
```<br>
 ```
npm install
```
3. Import one or more works:<br>
 ```
cd vendor/ogl-data
```<br>
 ```
git clone https://github.com/opengreekandlatin/<repo-id>
```<br>
 ```
scala localInventory.scala <repo-id>
```<br>
 ```
scala globalInventory.scala <--archive/--heml/--hathi> <repo-id>
```
4. Run npm start<br>
 ```
npm start
```
5. Server runs on port 7070
