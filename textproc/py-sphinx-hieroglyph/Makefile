# Created by: Andreas Sommer <andreas.sommer87@googlemail.com>
# $FreeBSD$

PORTNAME=	sphinx-hieroglyph
PORTVERSION=	0.7.1
PORTREVISION=	1
CATEGORIES=	textproc python
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}

MAINTAINER=	andreas.sommer87@googlemail.com
COMMENT=	Sphinx extension which builds HTML presentations

LICENSE=	BSD3CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

RUN_DEPENDS=	${PYTHON_PKGNAMEPREFIX}sphinx>=1.3:textproc/py-sphinx

USE_GITHUB=	yes
GH_ACCOUNT=	nyergler
GH_PROJECT=	hieroglyph

USES=		python shebangfix
USE_PYTHON=	autoplist distutils
SHEBANG_FILES=	src/hieroglyph/themes/slides2/static/scripts/md/render.py

NO_ARCH=	yes

.include <bsd.port.mk>
