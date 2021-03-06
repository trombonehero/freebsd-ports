# Created by: Pakhom Golynga <pg@pakhom.spb.ru>
# $FreeBSD$

PORTNAME=	zabbix34
PORTVERSION=	3.4.0
PORTREVISION?=	0
CATEGORIES=	net-mgmt
MASTER_SITES=	SF/zabbix/ZABBIX%20Latest%20Stable/${PORTVERSION}
PKGNAMESUFFIX?=	-server
DISTNAME=	zabbix-${PORTVERSION}

MAINTAINER=	pg@pakhom.spb.ru
COMMENT=	Enterprise-class open source distributed monitoring (${PKGNAMESUFFIX:S/^-//})

LICENSE=	GPLv2+
LICENSE_FILE=	${WRKSRC}/COPYING

LIB_DEPENDS=	libpcre.so:devel/pcre

CONFLICTS=	zabbix[0-24-9][0-35-9]${PKGNAMESUFFIX} zabbix[0-9]${PKGNAMESUFFIX}

IGNORE_WITH_MYSQL=	41

ZABBIX_BUILD=	${PKGNAMESUFFIX:S/^-//}

.if ${ZABBIX_BUILD} != "frontend" # frontend only needs the version/distribution settings
.if ${ZABBIX_BUILD} != "agent"
USE_RC_SUBR=	zabbix_${ZABBIX_BUILD}
.else
USE_RC_SUBR=	zabbix_${ZABBIX_BUILD}d
.endif

USES=		pkgconfig iconv

USERS=		zabbix
GROUPS=		zabbix

.if ${ZABBIX_BUILD} != "proxy"
PLIST_SUB=	PROXY="@comment "
.else
PLIST_SUB=	PROXY=""
.endif

.if ${ZABBIX_BUILD} == "server"
LIB_DEPENDS+=	libevent.so:devel/libevent
PLIST_SUB+=	SERVER=""
.else
PLIST_SUB+=	SERVER="@comment "
.endif

PLIST_SUB+=	ZABBIX_BUILD=${ZABBIX_BUILD} PORTVERSION=${PORTVERSION}
SUB_LIST=	ZABBIX_BUILD=${ZABBIX_BUILD}

MAKE_ARGS+=	ARCH=freebsd
GNU_CONFIGURE=	yes
CONFIGURE_ARGS+=	--enable-${ZABBIX_BUILD} \
			--sysconfdir=${ETCDIR} \
			--datadir=${ETCDIR} \
			--with-iconv=${ICONV_PREFIX}

.if ${ZABBIX_BUILD} != "agent"
LIB_DEPENDS+=	libnetsnmp.so:net-mgmt/net-snmp
USES+=		execinfo

CPPFLAGS+=	-I${LOCALBASE}/include

SUB_FILES=	pkg-message

CONFIGURE_ARGS+=	--with-net-snmp

OPTIONS_DEFINE=		IPV6 FPING JABBER CURL LDAP IPMI SSH NMAP JAVAGW \
			LIBXML2

OPTIONS_DEFAULT=	FPING CURL UNIXODBC MYSQL OPENSSL
OPTIONS_SUB=		yes

CURL_DESC=		Support for web monitoring
FPING_DESC=		Build/install fping for ping checks
IPMI_DESC=		Support for IPMI checks
JABBER_DESC=		Support for Jabber media type
LDAP_DESC=		Support for LDAP server checks
NMAP_DESC=		Build/install nmap for o/s detection
SSH_DESC=		Support for SSH-based checks
ODBC_DESC=		Support for database checks via ODBC
JAVAGW_DESC=		Support for Java gateway
LIBXML2_DESC=		Support for libxml2 (required by monitoring VMware)

OPTIONS_SINGLE=		DB ODBC SSL
OPTIONS_SINGLE_DB=	MYSQL PGSQL SQLITE ORACLE
OPTIONS_SINGLE_ODBC=	IODBC UNIXODBC
OPTIONS_SINGLE_SSL=	OPENSSL GNUTLS POLARSSL

MYSQL_CONFIGURE_WITH=	mysql
MYSQL_USES+=		mysql

PGSQL_CONFIGURE_WITH=	postgresql
PGSQL_USES+=		pgsql

SQLITE_CONFIGURE_WITH=	sqlite3
SQLITE_USES+=		sqlite:3

ORACLE_CONFIGURE_WITH=	oracle

CURL_CONFIGURE_WITH=	libcurl
CURL_LIB_DEPENDS=	libcurl.so:ftp/curl

LDAP_CONFIGURE_WITH=	ldap
LDAP_USE=		OPENLDAP=yes

IPMI_CONFIGURE_WITH=	openipmi
IPMI_LIB_DEPENDS=	libOpenIPMI.so:sysutils/openipmi

JABBER_CONFIGURE_WITH=	jabber
JABBER_LIB_DEPENDS=	libiksemel.so:textproc/iksemel

FPING_RUN_DEPENDS=	fping:net/fping

SSH_CONFIGURE_WITH=	ssh2
SSH_LIB_DEPENDS=	libssh2.so:security/libssh2

IODBC_CONFIGURE_WITH=	iodbc
IODBC_LIB_DEPENDS=	libiodbc.so:databases/libiodbc

UNIXODBC_CONFIGURE_WITH=unixodbc
UNIXODBC_LIB_DEPENDS=	libodbc.so:databases/unixODBC
.else
OPTIONS_SINGLE=	SSL
OPTIONS_SINGLE_SSL=	OPENSSL GNUTLS POLARSSL
.endif # if ${ZABBIX_BUILD} != "agent"

IPV6_CONFIGURE_ENABLE=	ipv6

NMAP_RUN_DEPENDS=	nmap:security/nmap \
			sudo:security/sudo

JAVAGW_CONFIGURE_ENABLE=java
JAVAGW_USE=		JAVA=yes

LIBXML2_CONFIGURE_WITH=	libxml2
LIBXML2_LIB_DEPENDS=	libxml2.so:textproc/libxml2

OPENSSL_CONFIGURE_WITH=	openssl
OPENSSL_USES=		ssl
OPENSSL_VARS=		BROKEN_SSL="libressl libressl-devel" \
			BROKEN_SSL_REASON="PSK is not provided by LibreSSL"

GNUTLS_CONFIGURE_WITH=	gnutls
GNUTLS_LIB_DEPENDS=	libgnutls.so:security/gnutls

POLARSSL_CONFIGURE_WITH=mbedtls
POLARSSL_LIB_DEPENDS=	libmbedtls.so:security/polarssl13

.include <bsd.port.pre.mk>

post-patch:
	@${GREP} -rl "/etc/zabbix" ${WRKSRC} \
	  | ${XARGS} ${REINPLACE_CMD} -e 's#/etc/zabbix#${ETCDIR}#g'
	@${REINPLACE_CMD} -e 's#/usr/sbin/fping#${LOCALBASE}/sbin/fping#g' \
		${WRKSRC}/conf/zabbix_*.conf

.if ${ZABBIX_BUILD} == "server"
	@${REINPLACE_CMD} -e 's#PidFile=/tmp/zabbix_server.pid#PidFile=/var/run/zabbix/zabbix_server.pid#g' \
		${WRKSRC}/conf/zabbix_server*.conf
	@${REINPLACE_CMD} -e 's#Include=/usr/local/usr/local/etc/zabbix3#Include=/usr/local/etc/zabbix3/zabbix#g' \
		${WRKSRC}/conf/zabbix_server*.conf
.endif

.if ${ZABBIX_BUILD} == "proxy"
	@${REINPLACE_CMD} -e 's#PidFile=/tmp/zabbix_proxy.pid#PidFile=/var/run/zabbix/zabbix_proxy.pid#g' \
		${WRKSRC}/conf/zabbix_proxy*.conf
	@${REINPLACE_CMD} -e 's#Include=/usr/local/usr/local/etc/zabbix3#Include=/usr/local/etc/zabbix3/zabbix#g' \
		${WRKSRC}/conf/zabbix_proxy*.conf
.endif

.if ${ZABBIX_BUILD} == "agent"
	@${REINPLACE_CMD} -e 's#PidFile=/tmp/zabbix_agentd.pid#PidFile=/var/run/zabbix/zabbix_agentd.pid#g' \
		${WRKSRC}/conf/zabbix_agentd*.conf
	@${REINPLACE_CMD} -e 's#Include=/usr/local/usr/local/etc/zabbix3#Include=/usr/local/etc/zabbix3/zabbix#g' \
		${WRKSRC}/conf/zabbix_agentd*.conf
.endif

.if ${ZABBIX_BUILD} != "agent"
.  for d in mysql oracle postgresql sqlite3
	@${REINPLACE_CMD} \
		-e 's|/bin/ping|/sbin/ping|g' \
		-e 's|/usr/bin/traceroute|/usr/sbin/traceroute|g' \
		-e 's|sudo /usr/bin/nmap|sudo ${LOCALBASE}/bin/nmap|g' \
		${WRKSRC}/database/${d}/data.sql
.  endfor
.endif
	@${REINPLACE_CMD} \
		-Ee 's|(@sysconfdir@/(\$$\([A-Z]*_CONFIG\)))" ([|][|] cp "../../conf/\$$\([A-Z]*_CONFIG\)" "\$$\(DESTDIR\)@sysconfdir@)"|\1.sample" \3/\2.sample"|;' \
		${WRKSRC}/src/zabbix_${ZABBIX_BUILD}/Makefile.in
	@${FIND} ${WRKSRC} -type f \( -name '*.bak' -or -name '*.orig' \) \
		-exec ${RM} {} +

post-install:

.if ${PORT_OPTIONS:MJAVAGW}
	${MV} ${STAGEDIR}${PREFIX}/sbin/zabbix_java/settings.sh \
		${STAGEDIR}${PREFIX}/sbin/zabbix_java/settings.sh.sample
.endif

.if ${ZABBIX_BUILD} != "agent"
	${MKDIR} ${STAGEDIR}${DATADIR}/${ZABBIX_BUILD:Q}/database
	(cd ${WRKSRC}/upgrades/ && ${COPYTREE_SHARE} dbpatches \
		${STAGEDIR}${DATADIR}/${ZABBIX_BUILD:Q}/upgrades/)
	(cd ${WRKSRC}/database/ && \
		${COPYTREE_SHARE} "ibm_db2 mysql oracle postgresql sqlite3" \
		${STAGEDIR}${DATADIR}/${ZABBIX_BUILD:Q}/database/)
.endif
.else # frontend
.include <bsd.port.pre.mk>
.endif

.include <bsd.port.post.mk>
