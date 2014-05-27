FROM centos:centos6

# Install all necessary binaries
RUN yum install -y tar which openssh-server openssh-clients-5.3p1-94.el6.x86_64 sudo

# Copy installation files
ADD dmexpress.tar.gz	 /usr/

# Copy local pam.d/sshd (Needed for ssh login)
ADD ss_sshd /etc/pam.d/sshd

# Unpacking ssh keys
ADD ssh_info.tar /etc/ssh/

# Set environment
ENV PATH 	      /usr/dmexpress/bin:$PATH
ENV LD_LIBRARY_PATH   /usr/dmexpress/lib:$LD_LIBRARY_PATH

# Create user
RUN useradd -d /home/syncsort/ -s /bin/bash -p $(echo syncsort | openssl passwd -1 -stdin) syncsort

# Make syncsort a sudoer
ADD ss_sudoers /etc/sudoers

RUN chown -R syncsort /usr/dmexpress

# Add startup script
ADD ss_bashrc		/home/syncsort/.bashrc
ADD ss_initial_startup.sh	/home/syncsort/ss_initial_startup.sh

# Move DMX UCAs to Docker
ADD UseCaseAccelerators.tar /usr/dmexpress/examples/UseCaseAccelerators
RUN chmod -R  777 /usr/dmexpress/examples/

# Expose dmxd port
EXPOSE 32636
# Expose sshd port
EXPOSE 22

# Copy daemon start script
ADD startd.sh /tmp/
RUN chmod +x /tmp/startd.sh 
 
CMD /tmp/startd.sh
