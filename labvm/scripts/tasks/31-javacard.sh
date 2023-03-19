#!/bin/bash
# Intel SGX SDK install script

apt-get -y install pcscd pcsc-tools \
	libp11-3 opensc-pkcs11 libengine-pkcs11-openssl opensc \
	libglib2.0-dev libnss3-dev libtool make autoconf autoconf-archive automake \
	libsofthsm2-dev softhsm2 softhsm2-common help2man gnutls-bin libcmocka-dev libusb-dev \
	libudev-dev flex libnss3-tools libssl-dev libpcsclite1 pkg-config libpcsclite-dev \
	openjdk-8-jre-headless openjdk-8-jdk-headless maven ant

[[ -z "$SKIP_INSTALL_JAVACARD_SIM" ]] || return 0

# this will be ran as the `student` user
function _user_script() {
	git clone https://github.com/martinpaljak/oracle_javacard_sdks.git "$HOME/oracle_javacard_sdks"
	export JC_HOME="$HOME/oracle_javacard_sdks/jc222_kit"
	export JC_CLASSIC_HOME="$HOME/oracle_javacard_sdks/jc305u3_kit"
	
	[[ -d "$HOME/jcardsim" ]] || git clone https://github.com/arekinath/jcardsim.git "$HOME/jcardsim"
( cd "$HOME/jcardsim"; mvn initialize && mvn clean install )

	[[ -d "$HOME/IsoApplet" ]] || git clone -b main-javacard-v2.2.2 https://github.com/philipWendland/IsoApplet.git "$HOME/IsoApplet"
	(
		cd "$HOME/IsoApplet"; git submodule init && git submodule update;
		# ant
		javac -classpath "$HOME/jcardsim/target/jcardsim-3.0.5-SNAPSHOT.jar" "$HOME/IsoApplet/src/xyz/wendland/javacard/pki/isoapplet/"*.java
	)

	[[ -d "$HOME/vsmartcard" ]] || git clone https://github.com/frankmorgner/vsmartcard.git "$HOME/vsmartcard"
	(
		cd "$HOME/vsmartcard/virtualsmartcard"
		autoreconf -vis && ./configure && sudo make install
	)
	cat <<-EOF > "$HOME/jcardsim.cfg"
	com.licel.jcardsim.card.applet.0.AID=F276A288BCFBA69D34F31001
	com.licel.jcardsim.card.applet.0.Class=xyz.wendland.javacard.pki.isoapplet.IsoApplet
	com.licel.jcardsim.card.ATR=3B80800101
	com.licel.jcardsim.vsmartcard.host=localhost
	com.licel.jcardsim.vsmartcard.port=35963
	EOF
}

echo "$(declare -f _user_script); _user_script" | su -c bash student

