# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_P="Flexget-${PV}"
SRC_URI="http://download.flexget.com/${MY_P}.tar.gz
	http://download.flexget.com/archive/${MY_P}.tar.gz
	https://github.com/Flexget/Flexget/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
KEYWORDS="~amd64 ~x86"


DESCRIPTION="Multipurpose automation tool for content like torrents, nzbs, podcasts, comics"
HOMEPAGE="http://flexget.com/"

LICENSE="MIT"
SLOT="0"
IUSE="test transmission"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/feedparser-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.7.5[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-1.999[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-0.9.0
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.1:4[${PYTHON_USEDEP}]
	<dev-python/beautifulsoup-4.5:4[${PYTHON_USEDEP}]
	!~dev-python/beautifulsoup-4.2.0:*
	>=dev-python/html5lib-0.11[${PYTHON_USEDEP}]
	dev-python/PyRSS2Gen[${PYTHON_USEDEP}]
	dev-python/pynzb[${PYTHON_USEDEP}]
	dev-python/progressbar[${PYTHON_USEDEP}]
	dev-python/rpyc[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.0[${PYTHON_USEDEP}]
	<dev-python/requests-3.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	>=dev-python/guessit-2.0.3[${PYTHON_USEDEP}]
	>=dev-python/APScheduler-3.0.3[${PYTHON_USEDEP}]
	!~dev-python/APScheduler-3.1.0
	>=dev-python/pytvmaze-1.4.8[${PYTHON_USEDEP}]
	>=dev-python/ordereddict-1.1[${PYTHON_USEDEP}]
	>=dev-python/cherrypy-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/flask-0.7[${PYTHON_USEDEP}]
	>=dev-python/flask-restful-0.3.3[${PYTHON_USEDEP}]
	=dev-python/flask-restplus-0.8.6[${PYTHON_USEDEP}]
	>=dev-python/Flask-Compress-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/Flask-Cors-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.0.3[${PYTHON_USEDEP}]
	dev-python/Safe[${PYTHON_USEDEP}]
"
##OLD REQ
	#dev-python/tmdb3[${PYTHON_USEDEP}]
	#dev-python/python-tvrage[${PYTHON_USEDEP}]

RDEPEND="${DEPEND}
	transmission? ( dev-python/transmissionrpc[${PYTHON_USEDEP}] )
"
DEPEND+=" test? ( dev-python/nose[${PYTHON_USEDEP}] )"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" dev-python/paver[${PYTHON_USEDEP}]"
else
	S="${WORKDIR}/${MY_P}"
	DEPEND+=" dev-python/paver[${PYTHON_USEDEP}]"
fi

python_prepare_all() {
	# Prevent setup from grabbing nose from pypi
	#sed -e /setup_requires/d -i pavement.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	cp -lr tests setup.cfg "${BUILD_DIR}" || die
	run_in_build_dir nosetests -v --attr=!online > "${T}/tests-${EPYTHON}.log" \
		|| die "Tests fail with ${EPYTHON}"
}
