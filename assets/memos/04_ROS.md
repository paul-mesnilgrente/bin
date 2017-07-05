# ROS Memo

## 1. Commands

| Command                                   | What it does                                          |
|-------------------------------------------|-------------------------------------------------------|
| **Navigation Commands**                   |                                                       |
| rospack find <package>                    | print path of the package that you search for         |
| roscd [locationname[/subdir]]             | cd to the path printed before                         |
| roscd log                                 | go to the log folder of ROS                           |
| rosls [locationname[/subdir]]             | normal ls, but we can use packages name               |
| **Packages**                              |                                                       |
| catkin_create_pkg <name> [depends...]     | create a package with its depedencies                 |
| rospack depends1 <package_name>           | print the dependencies of the package                 |
| rospack depends <package_name>            | print the dependencies recursively                    |
| **Build the ROS package**                 |                                                       |
| catkin_make [make_targets]                | build the workspace or the project                    |
| catkin_make --source my_src               | if the src folder is somewhere else                   |
| **Nodes**                                 |                                                       |
| rosnode list                              | list all nodes running on the computer                |
| rosnode info <node>                       | liste infos on the node, like pub/sub and services    |
| rosrun [package_name] [node_name]         | run the node of a specific package                    |
| rosrun ... \_\_name:=<name>               | usefull if your running multiple instance of the node |
| rosnode ping <node_name>                  | ping a running node                                   |
| **Topics**                                |                                                       |
| rostopic -h                               | get help for topics                                   |
| rostopic echo <topic_name>                | shows the data published on a topic                   |
| rostopic list                             | list all the topics running                           |
| rostopic -v                               | verbose to know about published and subscribed        |
| rostopic pub [topic] [msg_type] -- [args] | publish a message manually                            |
| -1 right after pub                        | publish the message only one time                     |
|  -r <hz> right after [msg_type]           | publish the msg with a frequency of <hz>              |
| rostopic hz <topic_name>                  | print the frequency of publishing                     |
| **Messages**                              |                                                       |
| rostopic type <topic_name>                | know the type of the message                          |
| rosmsg show <msg_type>                    | show the content of the message                       |
| **Services**                              |                                                       |
| rosservice list                           | list all the services running                         |
| rosservice type <service_name>            | show the type of the service                          |
| rosservice call [service] [args]          | call manually a service with some args                |
| roservice type <srv_name>                 | show the service type                                 |
| rossrv show                               | show the args of the service                          |
| **Parameters**                            |                                                       |
| rosparam list                             | list the parameters currently on the server           |
| rosparam set <param_name> [args]          | get the parameter                                     |
| rosparam get <param_name>                 | et the parameter (maybe clear after)                  |
| rosparam dump [file_name] [namespace]     | save parameters in a file                             |
|  rosparam load [file_name] [namespace]    |  load parameter from a file                           |
| **Launch**                                |                                                       |
|  roslaunch [package] [filename.launch]    | permits to launch multiple nodes in one line          |
| **Editor**                                |                                                       |
| rosed [package_name] [filename]           | fastly edit a file (do not forget tab completion)     |
| **Test**                                  |                                                       |
| catkin_make run_tests<tab><tab>           |                                                       |

Shortcut to have the content of message : `rostopic type <topic_name> | rosmsg show`

## 2. Usual actions to perform

### 2.1 Create a package

1. Use this command `catkin_create_pkg` to create the package.
2. Open the package.xml
    1. Change the description tag (short sentence)
    2. Change the maintener tag
    3. Change the licence tag
    4. If you want that the dependencies put on the creation to be available at the build and the runtime, copy paste the line of build_depend and change the tag to run_depend
3. The end

The package.xml must look like this at the end:

```xml
<?xml version="1.0"?>
<package>
  <name>beginner_tutorials</name>
  <version>0.1.0</version>
  <description>The beginner_tutorials package</description>

  <maintainer email="you@yourdomain.tld">Your Name</maintainer>
  <license>BSD</license>
  <url type="website">http://wiki.ros.org/beginner_tutorials</url>
  <author email="you@yourdomain.tld">Jane Doe</author>

  <buildtool_depend>catkin</buildtool_depend>

  <build_depend>roscpp</build_depend>
  <build_depend>rospy</build_depend>
  <build_depend>std_msgs</build_depend>

  <run_depend>roscpp</run_depend>
  <run_depend>rospy</run_depend>
  <run_depend>std_msgs</run_depend>

</package>
```

### 2.2 Interesting packages

```bash
# plot values sended by topics
rosrun rqt_plot rqt_plot
# print relations between nodes
rosrun rqt_graph rqt_graph
# print witch logs of nodes
rosrun rqt_console rqt_console
# choose what to print in the console
rosrun rqt_logger_level rqt_logger_level
```

### 2.3 ROS Launch

```xml
<launch>

  <group ns="turtlesim1">
    <node pkg="turtlesim" name="sim" type="turtlesim_node"/>
  </group>

  <group ns="turtlesim2">
    <node pkg="turtlesim" name="sim" type="turtlesim_node"/>
  </group>

  <node pkg="turtlesim" name="mimic" type="mimic">
    <remap from="input" to="turtlesim1/turtle1"/>
    <remap from="output" to="turtlesim2/turtle1"/>
  </node>

</launch>
```
