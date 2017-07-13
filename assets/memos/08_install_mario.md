# Installation of mario from scratch

## 1. Install ROS

Add package sick_tim to the script

## 2. Configure lazer

### 2.1 Check the launch

If the default launch is not working for the front lazer, check the IP in the file `src/mario/launch/mario_[full|default].launch`.

### 2.2 Check the scan

Check that the intensity is received (if it is not, the array is empty or eventually zero values):

- if received, nothing to do
- if not received, go on [this link](http://wiki.ros.org/sick_tim) section 6 (enable intensity), to do on the windows PC

ASK LAZAROS IF IT REQUIRES A REBOOT OR SOMETHING ELSE

### 2.3 Connect rear lazer

Connect the rear lazer to the Linux PC (USB cable).

## 3. Intel ZR300

### 3.1 Connect it

- BUY A USB3 CABLE FOR THE REALSENSE
- TAKE VELCRO TO FIX THE REALSENSE

1. Shutdown the robot
2. Fix the Realsense to the tablet with velcro install the USB cable

## 4. Mario motors

Copy/Paste this folder to have the mario motors `C:\Workspace\MapperAPI`

## 5. SLAM

- Add in the script the creation of the folder `maps` at the root of mario

## 6. Run ROS nodes through Windows

### 6.1 Install the Web API on the Windows PC

- Navigate to `mario/web_api`
- Run `npm install`
- Add a user
    - Change the values for username and password in `insert_caregiver.js`
    - Run `node insert_caregiver.js`
- Run the Web API `node app.js`

### 6.2 Connect to the Web API on the Linux PC

- Open the web browser
- Go the URL 192.168.1.46:7070
- If the URL is wrong, search on the internet how to find the Linux PC IP through the dos
- Login with the credentials given in the section 6.1
- Check if the MapperAPI is running on the Windows PC
- Launch through the Web Browser

## 7. Install Web apps

- Download the mario svn: `cd Desktop; svn checkout https://mare.istc.cnr.it/svn/mario/`
- Or update it with `cd Desktop\mario; svn update`
- Update the current folder on the Desktop
    - Change the following folders in `Desktop\current`:
        - `caregiver_ui` -> `branches\ortelio\caregiver_ui`
        - `calendar.app` -> `branches\ortelio\calender.app`
        - `games.app2` -> `branches\ortelio\games.app2`
        - `news.app2` -> `branches\ortelio\news.app2`
        - `music.app2` -> `mario\branches\cnet`,
        - `MarioUI` -> `mario\trunk\cnet`,
        - `marvin_standalone` -> `mario\trunk\cnr`,
        - `launchMARIO` -> `mario\trunk\launchMARIO`,
        - `ST2Controller` -> `mario\trunk\r2m\Speech2Text`,
- Change the following file: `C:\Natlink\Natlink\Macrosystem\_S2TEngine.py` by this `mario\trunk\r2m\Speech2Text\_S2TEngine.py`
- Run the apps: double click on `Desktop\current\launchMARIO\launchMARIO.bat`
