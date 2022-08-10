#!/bin/bash

verify_pip3_packages() {
    local packages_string=$1 # string of packages name separated by spaces
    echo "verify pip3 packages"
    IFS=' ' read -r -a python_packages <<<$packages_string
    for package in "${python_packages[@]}"; do
        echo "verifying $package"
        if ! pip3 freeze | grep -i $package &>/dev/null; then
            echo "verify pip3 packages failed"
            return 1
        fi
    done
    echo "verify pip3 packages passed"
}
verify_pipx_packages() {
    echo "Verifying pipx packages are installed"
    local failed_packages=()
    for package in "$@"; do
        echo "verifying $package"
        if ! hash "$package"; then
            failed_packages+=("$package")
        fi
    done
    if [ ${#failed_packages[@]} -eq 0 ]; then
        echo "verify pipx packages installation passed"
    else
        echo "verify pipx packages installation failed"
        echo "packages that have failed to install: ${failed_packages[*]}"
        return 1
    fi
}
verify_install_apt_packages() {
    local packages_string=$1 # string of packages name seperatied by spaces
    echo "verify install_apt_packages"
    if ! dpkg-query -Wf'${db:Status-abbrev}' $packages_string 2>/dev/null | grep -q '^i'; then
        echo "verify install_apt_packages failed"
        return 1
    fi
}

is_var_exist() {
    local var_name=$1
    if declare -p "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

extract_tar() {
    local _sudo
    if is_var_exist "sudo"; then
        _sudo="sudo"
    fi

    # Extract tar file, If there is no extract path the default is /tmp/tar_files/<file_name>
    local tar_file=$1
    local tmp_module_name=$(basename "${tar_file%%.*}")
    local tar_extracted_path=${2:-"/tmp/tar_files/${tmp_module_name}"}

    ${_sudo} mkdir -p "$tar_extracted_path"
    ${_sudo} tar -xvf "$tar_file" -C "$tar_extracted_path"
    echo $tar_extracted_path
}

extract_zip() {
    local tmp_module_name
    local _sudo
    if is_var_exist "sudo"; then
        _sudo="sudo"
    fi

    # Extract tar file, If there is no extract path the default is /tmp/tar_files/<file_name>
    local file=$1
    tmp_module_name=$(basename "${file%%.*}")
    local extracted_path=${2:-"/tmp/zip_files/${tmp_module_name}"}

    ${_sudo} mkdir -p "$extracted_path"
    ${_sudo} unzip "$file" -d "$extracted_path"
    echo "$extracted_path"
}

files_equal() {
    local file01=$1
    local file02=$2
    echo "Checks if $file01 and $file02 are equel"
    if cmp $file01 $file02; then
        echo "Files are equal"
        return 0
    else
        echo "Files are not equal"
        return 1
    fi
}

install_apt_packages()
{
    # Don't user "" with $apt_packages
    local apt_packages=$1
    sudo apt-get update
    sudo apt-get install $apt_packages -y
}

verify_apt_packages()
{
    local apt_packages=$1
    verify_install_apt_packages "$apt_packages"
}

install_pip_packages()
{
    local package_string="$1"
    local package_array
    IFS=', ' read -r -a package_array <<< "$package_string"
    for package in "${package_array[@]}"; do
        sudo pip3 install $package
    done
}

verify_pip_packages()
{
    local package_string="$1"
    verify_pip3_packages "$package_string"
}
