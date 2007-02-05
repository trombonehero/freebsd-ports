#-*- mode: Makefile; tab-width: 4; -*-
# ex:ts=4
#
# $FreeBSD$
#
# Please view me with 4 column tabs!

# Please make sure all changes to this file are past through the maintainer.
# Do not commit them yourself (unless of course you're the Port's Wraith ;).
KDE_MAINTAINER=		kde@FreeBSD.org

# This section contains the USE_ definitions.
# XXX: Write HAVE_ definitions sometime.

# QT_COMPONENTS		- Triggers individual Qt4 component port dependencies. Possible 
#			  values: See _QT_COMPONENTS_ALL below. Only works if USE_QT_VER is set
#			  to 4.
# USE_QT_VER		- Says that the port uses the Qt toolkit.  Possible values:
#					  3, 4; each specify the major version of Qt to use.
# USE_KDELIBS_VER	- Says that the port uses KDE libraries.  Possible values:
#					  3 specifies the major version of KDE to use.
#					  This implies USE_QT of the appropriate version.
# USE_KDEBASE_VER	- Says that the port uses the KDE base.  Possible values:
#					  3 specifies the major version of KDE to use.
#					  This implies USE_KDELIBS of the appropriate version.

# tagged MASTER_SITE_KDE_kde
kmaster=				${MASTER_SITE_KDE:S@%/@%/:kde@g}
.if !defined(MASTER_SITE_SUBDIR)
MASTER_SITE_KDE_kde=	${kmaster:S@%SUBDIR%/@@g}
.else
ksub=${MASTER_SITE_SUBDIR}
MASTER_SITE_KDE_kde=	${kmaster:S@%SUBDIR%/@${ksub}/@g}
.endif # !defined(MASTER_SITE_SUBDIR)

# USE_KDEBASE_VER section
.if defined(USE_KDEBASE_VER)
.if ${USE_KDEBASE_VER} == CVS
LIB_DEPENDS+=	kfontinst:${PORTSDIR}/x11/kdebase
USE_KDELIBS_VER=CVS
.elif ${USE_KDEBASE_VER} == 3
# kdebase 3.x common stuff
LIB_DEPENDS+=	kfontinst:${PORTSDIR}/x11/kdebase3
USE_KDELIBS_VER=3
.endif # ${USE_KDEBASE_VER} == 3
.endif # defined(USE_KDEBASE_VER)

# USE_KDELIBS_VER section
.if defined(USE_KDELIBS_VER)

## This is needed for configure scripts to figure out
## which threads lib to use

CONFIGURE_ENV+= PTHREAD_LIBS="${PTHREAD_LIBS}"

## Every KDE application is inherently IPv6-capable

CATEGORIES+=ipv6

##  XXX - This really belongs into bsd.port.mk
.if !defined(_NO_KDE_CONFTARGET_HACK)
CONFIGURE_TARGET=
CONFIGURE_ARGS+=--build=${MACHINE_ARCH}-portbld-freebsd${OSREL} \
		--x-libraries=${X11BASE}/lib --x-includes=${X11BASE}/include \
		--disable-as-needed
.endif

.if ${USE_KDELIBS_VER} == CVS
LIB_DEPENDS+=	kimproxy:${PORTSDIR}/x11/kdelibs
USE_QT_VER=		CVS
PREFIX=			${KDE_CVS_PREFIX}
.elif ${USE_KDELIBS_VER} == 3
# kdelibs 3.x common stuff
LIB_DEPENDS+=	kimproxy:${PORTSDIR}/x11/kdelibs3
USE_QT_VER=		3
PREFIX=			${KDE_PREFIX}
.else
IGNORE=			cannot install: unsupported value in USE_KDELIBS_VER
.endif # ${USE_KDELIBS_VER} == 3
.endif # defined(USE_KDELIBS_VER)

# End of USE_KDELIBS_VER section

# USE_QT_VER section
.if ${USE_QT_VER} == CVS

KDE_CVS_PREFIX?=	${LOCALBASE}/kde-cvs
QT_CVS_PREFIX?=		${X11BASE}/qt-cvs
QTCPPFLAGS?=
QTCFGLIBS?=

MOC?=				${QT_CVS_PREFIX}/bin/moc
BUILD_DEPENDS+=		${MOC}:${PORTSDIR}/x11-toolkits/qt-copy
RUN_DEPENDS+=		${MOC}:${PORTSDIR}/x11-toolkits/qt-copy
QTCPPFLAGS+=		-D_GETOPT_H		# added to work around broken getopt.h #inc
.if !defined (QT_NONSTANDARD)
CONFIGURE_ARGS+=--with-extra-libs="${LOCALBASE}/lib" \
				--with-extra-includes="${LOCALBASE}/include"
CONFIGURE_ENV+=	MOC="${MOC}" CPPFLAGS="${CPPFLAGS} ${QTCPPFLAGS}" LIBS="${QTCFGLIBS}" \
				QTDIR="${QT_CVS_PREFIX}" KDEDIR="${KDE_CVS_PREFIX}"
.endif

.elif ${USE_QT_VER} == 3

# Yeah, it's namespace pollution, but this is really the best place for this
# stuff. Arts does NOT use it anymore.
KDE_VERSION=		3.5.5
KDE_ORIGVER=	${KDE_VERSION}
KDE_PREFIX?=	${LOCALBASE}

QTCPPFLAGS?=
QTCGFLIBS?=

# Qt 3.x common stuff
QT_PREFIX?=		${X11BASE}
MOC?=			${QT_PREFIX}/bin/moc
#LIB_DEPENDS+=	qt-mt.3:${PORTSDIR}/x11-toolkits/qt33
BUILD_DEPENDS+=	${QT_PREFIX}/bin/moc:${PORTSDIR}/x11-toolkits/qt33
RUN_DEPENDS+=	${QT_PREFIX}/bin/moc:${PORTSDIR}/x11-toolkits/qt33
QTCPPFLAGS+=	-I${LOCALBASE}/include -I${PREFIX}/include \
				-I${QT_PREFIX}/include -D_GETOPT_H
QTCFGLIBS+=		-Wl,-export-dynamic -L${LOCALBASE}/lib -L${X11BASE}/lib -ljpeg \
				-L${QT_PREFIX}/lib
.if defined(PACKAGE_BUILDING)
TMPDIR?=	/tmp
MAKE_ENV+=	TMPDIR="${TMPDIR}"
CONFIGURE_ENV+=	TMPDIR="${TMPDIR}"
.endif

.if !defined(QT_NONSTANDARD)
CONFIGURE_ARGS+=--with-qt-includes=${QT_PREFIX}/include \
				--with-qt-libraries=${QT_PREFIX}/lib \
				--with-extra-libs=${LOCALBASE}/lib \
				--with-extra-includes=${LOCALBASE}/include
CONFIGURE_ENV+=	MOC="${MOC}" CPPFLAGS="${CPPFLAGS} ${QTCPPFLAGS}" LIBS="${QTCFGLIBS}" \
				QTDIR="${QT_PREFIX}" KDEDIR="${KDE_PREFIX}"
.endif # !defined(QT_NONSTANDARD)

.elif ${USE_QT_VER} == 4

# Qt 4.x common stuff
QT_PREFIX?=	${LOCALBASE}
MOC?=		${QT_PREFIX}/bin/moc4
UIC?=		${QT_PREFIX}/bin/uic4
QMAKE?=		${QT_PREFIX}/bin/qmake-qt4
QMAKESPEC?=	${QT_PREFIX}/share/qt4/mkspecs/freebsd-g++

QTCPPFLAGS?=
QTCGFLIBS?=

.if !defined(QT_NONSTANDARD)
CONFIGURE_ARGS+=--with-qt-includes=${QT_PREFIX}/include \
				--with-qt-libraries=${QT_PREFIX}/lib \
				--with-extra-libs=${LOCALBASE}/lib \
				--with-extra-includes=${LOCALBASE}/include
CONFIGURE_ENV+=	MOC="${MOC}" UIC="${UIC} CPPFLAGS="${CPPFLAGS} ${QTCPPFLAGS}" LIBS="${QTCFGLIBS}" \
		QMAKE="${QMAKE} QMAKESPEC="${QMAKESPEC}" QTDIR="${QT_PREFIX}" KDEDIR="${KDE_PREFIX}"
MAKE_ENV+=	QMAKESPEC="${QMAKESPEC}"
.endif # !defined(QT_NONSTANDARD)

QT4_VERSION=	4.2.2

_QT_COMPONENTS_ALL=	accessible assistant codecs-cn codecs-jp codecs-kr \
			codecs-tw corelib designer doc gui iconengines \
			imageformats inputformats assistantclient \
			linguist moc network opengl pixeltool porting \
			qmake qt3support qtconfig qtestlib qvfb rcc sql svg \
			uic uic3 xml

accessible_DEPENDS=	accessibility/qt4-acessible
assistant_DEPENDS=	devel/qt4-assistant
codecs-cn_DEPENDS=	chinese/qt4-codecs-cn
codecs-jp_DEPENDS=	japanese/qt4-codecs-jp
codecs-kr_DEPENDS=	korean/qt4-codecs-kr
codecs-tw_DEPENDS=	misc/qt4-codecs-tw
corelib_DEPENDS=	devel/qt4-corelib
designer_DEPENDS=	devel/qt4-designer
doc_DEPENDS=		misc/qt4-doc
gui_DEPENDS=		x11-toolkits/qt4-gui
iconengines_DEPENDS=	graphics/qt4-iconengines
imageformats_DEPENDS=	graphics/qt4-imageformats
inputformats_DEPENDS=	x11/qt4-inputformats
assistantclient_DEPENDS=devel/qt4-libqtassistantclient
assistantclient_NAME=	libQtAssistantClient
linguist_DEPENDS=	devel/qt4-linguist
moc_DEPENDS=		devel/qt4-moc
network_DEPENDS=	net/qt4-network
opengl_DEPENDS=		x11/qt4-opengl
pixeltool_DEPENDS=	graphics/qt4-pixeltool
porting_DEPENDS=	devel/qt4-porting
qmake_DEPENDS=		devel/qmake4
qmake_QT4_PREFIX=	# empty
qt3support_DEPENDS=	devel/qt4-qt3support
qtconfig_DEPENDS=	devel/qtconfig
qtestlib_DEPENDS=	devel/qt4-qtestlib
qvfb_DEPENDS=		devel/qt4-qvfb
rcc_DEPENDS=		devel/qt4-rcc
svg_DEPENDS=		graphics/q4-svg
uic_DEPENDS=		devel/qt4-uic
uic3_DEPENDS=		devel/qt4-uic3
xml_DEPENDS=		textproc/qt4-xml

.if defined(QT_COMPONENTS)
.for ext in ${QT_COMPONENTS}
${ext}_QT4_PREFIX?=	qt4-
${ext}_QT4_VERSION?=	${QT4_VERSION}
${ext}_NAME?=		${ext}
.if ${_QT_COMPONENTS_ALL:M${ext}}!= ""
BUILD_DEPENDS+=	${${ext}_QT4_PREFIX}${${ext}_NAME}>=${${ext}_QT4_VERSION}:${PORTSDIR}/${${ext}_DEPENDS}
RUN_DEPENDS+=	${${ext}_QT4_PREFIX}${${ext}_NAME}>=${${ext}_QT4_VERSION}:${PORTSDIR}/${${ext}_DEPENDS}
.else
IGNORE= cannot install: unknown Qt4 component -- ${ext}
.endif
.endfor
.else
BUILD_DEPENDS=		qt4>=${QT4_VERSION}:${PORTSDIR}/devel/qt4
RUN_DEPENDS=		qt4>=${QT4_VERSION}:${PORTSDIR}/devel/qt4
.endif

.else
IGNORE=			cannot install: unsupported value of USE_QT_VER
.endif # defined(USE_QT_VER)

# End of USE_QT_VER section

# Assemble plist from parts
# <alane@freebsd.org> 2002-12-06
.if defined(KDE_BUILD_PLIST)
PLIST?=			${WRKDIR}/plist
PLIST_BASE?=	plist.base
PLIST_APPEND?=
plist_base=${FILESDIR}/${PLIST_BASE}
plist_base_rm=${FILESDIR}/${PLIST_BASE}.rm
plist_append=${PLIST_APPEND:C:([A-Za-z0-9._]+):${FILESDIR}/\1:}
plist_append_rm=${PLIST_APPEND:C:([A-Za-z0-9._]+):${FILESDIR}/\1.rm:}
kde-plist:
	${CAT} ${plist_base} ${plist_append} 2>/dev/null >${PLIST}
	-${CAT} ${plist_append_rm} ${plist_base_rm} 2>/dev/null >>${PLIST};true
.PHONY: kde-plist
pre-build: kde-plist
.endif # defined(KDE_BUILD_PLIST)
