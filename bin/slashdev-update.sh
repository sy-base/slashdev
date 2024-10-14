#!/bin/bash
######
HOME_DIR="/home/appuser"
GIT_STATUS_FILE=".git-pull-output"
LOG_FILE="hugo.log"
######
source "${HOME_DIR}/.deployment_branch"
source "${HOME_DIR}/.asdf/asdf.sh"
######
if [ ! -d "${HOME_DIR}/slashdev" ]; then {
    git clone -b ${DEPLOYMENT_BRANCH} https://github.com/sy-base/slashdev.git
    echo "---- [$(date)] Slashdev repository retrieved" >> "${HOME_DIR}/${LOG_FILE}"
    cat "${HOME_DIR}/slashdev/.tool-versions" > "${HOME_DIR}/.tool-versions"
    asdf install hugo
    hugo -s "${HOME_DIR}/slashdev/src" -d "${HOME_DIR}/www-data" --cleanDestinationDir -e production -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
}; fi

cd ${HOME_DIR}/slashdev
git fetch > "${HOME_DIR}/${GIT_STATUS_FILE}"

# Check if there are updates
_local=$(git rev-parse @)
_remote=$(git rev-parse @{u})

if [ $_local = $_remote ]; then {
    echo "No updates fetched. Skipping action."
    exit 0;
} else {
    echo "Updates were fetched. Performing action."
    echo "---- [$(date)] Updates were fetched." >> "${HOME_DIR}/${LOG_FILE}"
    git pull >> "${HOME_DIR}/${LOG_FILE}"
    _git_pull_rc=$?
    if [ "${_git_pull_rc}" != 0 ]; then {
        rm -rf "${HOME_DIR}/slashdev"
        git clone -b ${DEPLOYMENT_BRANCH} https://github.com/sy-base/slashdev.git
        echo "---- [$(date)] Slashdev repository retrieved" >> "${HOME_DIR}/${LOG_FILE}"
    }; fi
    cat "${HOME_DIR}/slashdev/.tool-versions" > "${HOME_DIR}/.tool-versions"
    asdf install hugo
    echo "---- [$(date)] Hugo Build Prod" >> "${HOME_DIR}/${LOG_FILE}"
    hugo -s "${HOME_DIR}/slashdev/src" -d "${HOME_DIR}/www-data" --cleanDestinationDir -e production -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
    echo "---- [$(date)] Hugo Build DEV" >> "${HOME_DIR}/${LOG_FILE}"
    hugo -s "$HOME/slashdev/src" -d "$HOME/www-dev" -D -E -F --logLevel debug --cleanDestinationDir -e development -b "" >> "${HOME_DIR}/${LOG_FILE}" 2>&1
}; fi

# Clean up
echo "---- [$(date)] End of updates." >> "${HOME_DIR}/${LOG_FILE}"
rm -f "${HOME_DIR}/${GIT_STATUS_FILE}"
