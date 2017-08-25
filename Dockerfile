FROM ubuntu:latest

RUN apt update && apt install -y sudo 

RUN useradd -g video --create-home --shell /bin/bash warrierr && \
		echo "warrierr ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/warrierr && \
		chmod 0400 /etc/sudoers.d/warrierr

USER warrierr
WORKDIR /mnt/host_home/ros-docker

RUN sudo apt update && sudo apt install -y apt-utils tmux vim lsb-release

RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
		sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
		sudo apt update && \
		sudo apt install -y ros-kinetic-desktop-full

RUN /bin/bash -c 'echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc' 

RUN /bin/bash -c 'echo "export ROS_MASTER_URI=http://$(/sbin/ip -o -4 addr list eth0 | awk ""'"'{print $4}'"'"" | cut -d/ -f1):11311" >> ~/.bashrc' 

RUN /bin/bash -c 'echo "export ROS_IP=$(/sbin/ip -o -4 addr list eth0 | awk ""'"'{print $4}'"'"" | cut -d/ -f1)" > ~/.bashrc' 
		
RUN /bin/bash -c 'source ~/.bashrc'

RUN sudo apt install -y ros-kinetic-joint-state-publisher \
												ros-kinetic-rqt-common-plugins 
RUN sudo apt update && \
		sudo apt install -y python-rosinstall \
												python-rosinstall-generator \
												python-wstool \
												build-essential

RUN sudo apt update && \
		sudo apt install -y mesa-utils \
												can-utils \
												liburdfdom-tools \
												evince \
												kmod \
												iproute \
												iputils-ping \
												nvidia-current
RUN sudo rosdep init

RUN rosdep update && \
 		rosdep install --from-paths src --ignore-src -y				
