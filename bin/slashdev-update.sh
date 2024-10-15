#!/bin/bash
######
HOME_DIR="/home/appuser"
GIT_STATUS_FILE=".git-pull-output"
LOG_FILE="hugo.log"
FORCE_BUILD=false
######
source "${HOME_DIR}/.deployment_branch"
source "${HOME_DIR}/.asdf/asdf.sh"
######
_dev_branch="develop"
_prod_branch="${DEPLOYMENT_BRANCH}"

if [ ! -d "${HOME_DIR}/slashdev" ]; then {
    git clone -b ${_prod_branch} https://github.com/sy-base/slashdev.git
    echo "---- [$(date)] Slashdev repository retrieved" >> "${HOME_DIR}/${LOG_FILE}"
    cat "${HOME_DIR}/slashdev/.tool-versions" > "${HOME_DIR}/.tool-versions"
    asdf install hugo
    FORCE_BUILD=true
    #hugo -s "${HOME_DIR}/slashdev/src" -d "${HOME_DIR}/www-data" --cleanDestinationDir -e production -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
    #git checkout ${_dev_branch}
    #hugo -s "$HOME/slashdev/src" -d "$HOME/www-dev" --cleanDestinationDir -e development -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
}; fi

cd ${HOME_DIR}/slashdev
git fetch > "${HOME_DIR}/${GIT_STATUS_FILE}"

# Check if there are updates
_local=$(git rev-parse @)
_remote=$(git rev-parse @{u})

if [ $_local = $_remote ] && [ "${FORCE_BUILD}" = false ]; then {
    echo "No updates fetched. Skipping action."
    exit 0;
} else {
    if [ "${FORCE_BUILD}" = true ]; then echo "---- [$(date)] Build FORCED" >> "${HOME_DIR}/${LOG_FILE}"; fi
    echo "---- [$(date)] Updates were fetched." >> "${HOME_DIR}/${LOG_FILE}"
    git pull >> "${HOME_DIR}/${LOG_FILE}"
    _git_pull_rc=$?
    if [ "${_git_pull_rc}" != 0 ]; then {
        cd ${HOME_DIR}
        rm -rf "${HOME_DIR}/slashdev"
        git clone -b ${_prod_branch} https://github.com/sy-base/slashdev.git
        cd ${HOME_DIR}/slashdev
        echo "---- [$(date)] Slashdev repository retrieved" >> "${HOME_DIR}/${LOG_FILE}"
    }; fi
    cat "${HOME_DIR}/slashdev/.tool-versions" > "${HOME_DIR}/.tool-versions"
    git checkout ${_prod_branch} >> "${HOME_DIR}/${LOG_FILE}"
    asdf install hugo
    echo "---- [$(date)] Hugo Build Prod" >> "${HOME_DIR}/${LOG_FILE}"
    hugo -s "${HOME_DIR}/slashdev/src" -d "${HOME_DIR}/www-data" --cleanDestinationDir -e production -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
    echo "---- [$(date)] Hugo Build DEV" >> "${HOME_DIR}/${LOG_FILE}"
    git checkout ${_dev_branch} >> "${HOME_DIR}/${LOG_FILE}"
    hugo -s "$HOME/slashdev/src" -d "$HOME/www-dev" --cleanDestinationDir -e development -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
}; fi

# Clean up
git checkout ${_prod_branch} >> "${HOME_DIR}/${LOG_FILE}"
echo "---- [$(date)] End of updates." >> "${HOME_DIR}/${LOG_FILE}"
rm -f "${HOME_DIR}/${GIT_STATUS_FILE}"
