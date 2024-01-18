#!/usr/bin/env bash

# GLOBALS
FINAL_OUTPUT_DIRECTORY="/etc/update-motd.d/"
FINAL_OUTPUT_FILE_NAME="99-hint"

# Check if cowsay-motd-cwl is a path
COWSAY_CWL_HOME=""  # Set this as an absolute path to avoid having to git clone each time
COWSAY_CWL_GITHUB_REPO="https://github.com/alexiswl/cowsay-motd-cwl"

# CWL / COWSAY VARS
BORDER_COLOUR="red"
QUOTES_DIR="${COWSAY_CWL_HOME}/quotes/"
OUTPUT_FILENAME="cowsay.sh"

# Workdir
cwltool_run_dir="$(mktemp -d)"

# Run CWLTOOL
(
  # || exit is to satisfy shellcheck - https://github.com/koalaman/shellcheck/wiki/SC2164
  cd "${cwltool_run_dir}" || exit
  if [[ -z "${COWSAY_CWL_HOME}" || ! -d "${COWSAY_CWL_HOME}" ]]; then
    COWSAY_CWL_HOME="$PWD/$(basename "${COWSAY_CWL_GITHUB_REPO}")"
    # Clone cowsay-motd-cwl
    git clone "${COWSAY_CWL_GITHUB_REPO}";
  fi

  cwltool "${COWSAY_CWL_HOME}/workflow/motd_workflow.cwl" <( \
    jq --null-input --raw-output \
     --arg quotes_dir "${QUOTES_DIR}" \
     --arg border_colour "${BORDER_COLOUR}" \
     --arg output_filename "${OUTPUT_FILENAME}" \
     '
       {
         "quotes_dir": {
           "class": "Directory",
           "location": $quotes_dir
         },
         "border_colour": $border_colour,
         "output_file_name": $output_filename
       }
     '
  );
  chmod 775 "${OUTPUT_FILENAME}";
  sudo mv "${OUTPUT_FILENAME}" "${FINAL_OUTPUT_DIRECTORY}/${FINAL_OUTPUT_FILE_NAME}";
)

# Delete our temp dirs
rm -rf "${cwltool_run_dir}"
