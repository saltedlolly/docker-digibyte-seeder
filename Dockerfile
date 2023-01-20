#
#           Name:  DigiByte Seeder Dockererized
#
#        Purpose:  Dockerfile to setup a DigiByte Seeder.
#          
#         Author:  Olly Stedall @saltedlolly
#
#        Website:  https://diginode.digibyte.help
#
#		   Build:  docker build -t digibyte-seeder .
#							
#			 Run:  docker run -d -t --name dgbseeder digibyte-seeder
#    
#
# -----------------------------------------------------------------------------------------------------

# ARGUMENTS - Set these before running

# Set the URL of the DigiByte Seeder - e.g. dnsseed.example.com
ARG SEEDER_URL=dnsseed.example.com

# Set the address of the name server record - e.g. vps.example.com
ARG VPS_URL=vps.example.com

# Enter the SOA record email address replacing the @ sign with a period. e.g. name@email.com would be name.email.com
# This will publish the contact email of the administror managing the server.
ARG SOA_EMAIL_URL=name.email.com

# Set the IP address to bind the seeder to. This is the IP adress of the server running the seeder.
ARG IP_ADDRESS=localhost



# -----------------------------------------------------------------------------------------------------

FROM ubuntu:latest
USER root
WORKDIR /data

# Change this to choose between mainnet or testnet
# ARG DGBNETWORK="mainnet"

# Allow DNS ports
EXPOSE 53
EXPOSE 5353

# Install OS updates
RUN apt-get update
# RUN apk update

# Install packages required to compile the DigiNode Seeder
RUN apt-get install -y gcc g++ build-essential libboost-all-dev libssl-dev
# RUN apk install -y gcc g++ build-essential libboost-all-dev libssl-dev

# Install other required packages
RUN apt-get install -y git wget

# Install systemd
RUN apt-get install -y systemd systemd-sysv dbus dbus-user-session

# Set entrypoint for init
ENTRYPOINT ["/sbin/init"]

# Clean up installed packages
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clone and compile DigiByte Seeder
RUN git clone https://github.com/digicontributer/digibyte-seeder /data/digibyte-seeder \
	&& ( \
		cd /data/digibyte-seeder \
		&& make \
	)
# RUN ./data/digibyte-seeder/dnsseed -h $SEEDER_URL -n $VPS_URL -m $SOA_EMAIL_URL -p 5353 -a $IP_ADDRESS
RUN ./data/digibyte-seeder/dnsseed
