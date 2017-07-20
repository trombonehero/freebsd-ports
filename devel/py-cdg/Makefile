# $FreeBSD$

PORTNAME=	cdg
PORTVERSION=	0.1.0
CATEGORIES=	devel python
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}

MAINTAINER=	jonathan@FreeBSD.org
COMMENT=	Library for working with call- and data-flow graphs

LICENSE=	APACHE20

TEST_DEPENDS?=	${PYTHON_PKGNAMEPREFIX}nosetests>0:devel/py-nose

USES?=		python
USE_GITHUB=	yes
USE_PYTHON=	autoplist distutils

GH_ACCOUNT=	musec
GH_PROJECT=	py-cdg

.include <bsd.port.options.mk>

regression-test: build
	@cd ${WRKSRC} && ${PYTHON_CMD} ${PYDISTUTILS_SETUP} test

.include <bsd.port.mk>
