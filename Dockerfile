FROM rockylinux:8

# Install EPEL repository and key
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8

# Install necessary utilities including yum-utils for repository management
# Install dnf-command(config-manager) for managing DNF repositories
RUN yum install -y yum-utils \
    && yum install -y 'dnf-command(config-manager)'

# Disable mod_auth_openidc module stream specifically for EL8 derivatives, excluding RedHat
RUN dnf module disable -y mod_auth_openidc

# Import the Globus key
RUN rpm --import https://downloads.globus.org/toolkit/gt6/stable/repo/rpm/RPM-GPG-KEY-Globus

# Set up the Globus repositories according to their respective statuses
# Install Globus Connect Server
RUN yum install -y https://downloads.globus.org/globus-connect-server/testing/installers/repo/rpm/globus-repo-latest.noarch.rpm \
    && dnf config-manager --set-enabled Globus-Connect-Server-5-Testing \
    && yum install -y globus-connect-server54

# Clean up yum caches to reduce image size
RUN yum clean all

# These are the default ports in use by Globus Connect Server v5.4
EXPOSE 443/tcp 50000-51000/tcp
