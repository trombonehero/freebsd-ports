# Created by: Eric Freeman <freebsdports@chillibear.com>
# $FreeBSD$

PORTNAME=	larch
PORTVERSION=	1.1.2
PORTREVISION=	2
CATEGORIES=	mail rubygems
MASTER_SITES=	RG

MAINTAINER=	ruby@FreeBSD.org
COMMENT=	Larch copies messages from one IMAP server to another

LICENSE=	GPLv2

RUN_DEPENDS=	rubygem-highline>=1.5:devel/rubygem-highline \
		rubygem-sequel3>=3.14:devel/rubygem-sequel3 \
		rubygem-sqlite3>=1.3:databases/rubygem-sqlite3 \
		rubygem-trollop1>=1.13:devel/rubygem-trollop1

DEPRECATED=	Unmaintained by upstream, no changes since 2013
EXPIRATION_DATE=2017-08-31

NO_ARCH=	yes
USE_RUBY=	yes
USES=		gem

PLIST_FILES=	bin/larch

.include <bsd.port.mk>
