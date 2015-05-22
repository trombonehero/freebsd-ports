# $FreeBSD$

PORTNAME=	libpololu
PORTVERSION=	140513
CATEGORIES=	devel
MASTER_SITES=	http://www.pololu.com/file/download/ \
		http://www.pololu.com/file/download/
PKGNAMESUFFIX=	-avr
DISTNAME=	libpololu-avr-140513
EXTRACT_SUFX=	.zip?file_id=0J757

MAINTAINER=	jonathan@FreeBSD.org
COMMENT=	Support libraries for Pololu robots

LICENSE=	MIT

BUILD_DEPENDS=	avr-gcc:${PORTSDIR}/devel/avr-gcc \
		${LOCALBASE}/avr/lib/libc.a:${PORTSDIR}/devel/avr-libc

PREFIX=		${LOCALBASE}/avr

WRKSRC=		${WRKDIR}/libpololu-avr
MAKE_CMD=	${GMAKE}
MAKE_ENV=	LIB=${STAGEDIR}${PREFIX}/lib
ALL_TARGET=	library_files

.include <bsd.port.mk>
