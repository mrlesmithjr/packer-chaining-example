#!/usr/bin/env bash

# Define custom settings to pass to templates
USERNAME="ubuntu"
PASSWORD="P@55w0rd"
VM_NAME="ubuntu1804"
MANIFEST="manifest.json"

# Update http/preseed.cfg to match username/password
sed -i "" "s/^d-i passwd\/user-fullname string.*/d-i passwd\/user-fullname string ${USERNAME}/g" http/preseed.cfg
sed -i "" "s/^d-i passwd\/username string.*/d-i passwd\/username string ${USERNAME}/g" http/preseed.cfg
sed -i "" "s/^d-i passwd\/user-password password.*/d-i passwd\/user-password password ${PASSWORD}/g" http/preseed.cfg
sed -i "" "s/d-i passwd\/user-password-again password.*/d-i passwd\/user-password-again password ${PASSWORD}/g" http/preseed.cfg

# Sets counter for loop of templates. Ensures that the first one is the actual
# base image install.
COUNTER=1

# List of templates to build in order
TEMPLATES=("Ubuntu-18.04.json" "Ubuntu-18.04-base.json"
  "Ubuntu-18.04-vagrant.json")

# Defines whether to pass -force flag to packer build to overwrite existing
# artifacts and allow build to continue if artifacts already exist.
FORCE_OVERWRITE=false

for template in "${TEMPLATES[@]}"; do
  if [ "${COUNTER}" == "1" ]; then
    if ${FORCE_OVERWRITE}; then
      packer build -force -var "username=${USERNAME}" \
        -var "password=${PASSWORD}" -var "vm_name=${VM_NAME}" \
        -var "manifest=${MANIFEST}" ${template}
    else
      packer build -var "username=${USERNAME}" \
        -var "password=${PASSWORD}" -var "vm_name=${VM_NAME}" \
        -var "manifest=${MANIFEST}" ${template}
    fi
  else
    BUILDS=$(jq '.builds' ${MANIFEST})
    LAST_RUN_UUID=$(jq -r '.last_run_uuid' ${MANIFEST})

    for row in $(echo "${BUILDS}" | jq -r '.[] | @base64'); do
      _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
      }
      if [ "$(_jq '.packer_run_uuid')" == "${LAST_RUN_UUID}" ]; then
        FILES="$(_jq '.files')"
        for file in $(echo "${FILES}" | jq -r '.[] | @base64'); do
          FILENAME=$(echo ${file} | base64 --decode | jq -r ${1} '.name')
          if [[ "${FILENAME}" == *ovf ]]; then
            if ${FORCE_OVERWRITE}; then
              packer build -force -var "username=${USERNAME}" \
                -var "password=${PASSWORD}" -var "vm_name=${VM_NAME}" \
                -var "source_path=${FILENAME}" -var "manifest=${MANIFEST}" \
                ${template}
            else
              packer build -var "username=${USERNAME}" \
                -var "password=${PASSWORD}" -var "vm_name=${VM_NAME}" \
                -var "source_path=${FILENAME}" -var "manifest=${MANIFEST}" \
                ${template}
            fi
          fi
        done
      fi
    done
  fi
  COUNTER=$((COUNTER+1))
done