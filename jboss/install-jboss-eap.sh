#Pre-requisite:
# 1. OpenJDK installed already

#migration guide: https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html-single/migration_guide/index#migrating_from_eap_5_to_eap_7

JBOSS_JAR=jboss-eap-7.4.0-installer.jar
JBOSS_PATCH=https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=105398

#download the latest jboss-eap jar file
curl -O https://developers.redhat.com/content-gateway/file/${JBOSS_JAR}

#install jboss eap
sudo java -jar ${JBOSS_JAR} -console

#Select options:
# - select English
# - set jboss installation path: /opt/jboss-eap
# - set all packs
# - set admin username: admin/P@ssw0rd
# - set default runtime configuration
# - set the automatic installation scpt properties files (depends on client's configuration)

#set up the service to boot up properly
#create user that run the service and set the password
sudo useradd--no-create-home --shell /bin/shell/ jboss-eap

#modify jboss cinfig file
cd /opt/jboss-eap
sudo vim bin/init.d/jboss-eap.conf
# - uncomment the JBOSS_HOME
# - uncomment the JBOSS_USER

#copy the config file to etc default directory
sudo cp bin/init.d/jboss-eap.conf /etc/default/

#copy the startup script to /etc/init.d
sudo cp bin/init.d/jboss-eap-rhel.sh /etc/init.d/

#set it to executable
sudo chmod +x /etc/init.d/jboss-eap-rhel.sh

#set the service to automatically turn ON
sudo chkconfig --add jboss-eap-rhel.sh
sudo chkconfig jboss-eap-rhel.sh on
sudo mkdir /var/run/jboss-eap
sudo chown -R jboss-eap:jboss-eap /var/run/jboss-eap/
sudo chown -R jboss-eap:jboss-eap /opt/jboss-eap/

#set SE Linux policy
cd ~/selinux/
sudo make -f /user/share/selinux/devel/Makefile jboss-eap-rhel.pp

#add policy module
sudo semodule -i jboss-eap-rhel.pp

#start the service
sudo systemtl start jboss-eap-rhel

#check the status
sudo systemctl status jboss-eap-rhel


