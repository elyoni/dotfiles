# syntax = docker/dockerfile:1.3
FROM ubuntu:20.04 AS base_box
# === User Settings===
ENV USER yoni
ENV HOME "/home/$USER"

ENV TMP_IMAGE_SCRIPT /tmp/docker-build
ENV SCRIPT_INSTALL scripts

ENV PATH="$HOME/.local/bin:${PATH}"

ARG RUN_SCRIPT="install_prepare_file_system.sh"
RUN --mount=type=bind,source=${SCRIPT_INSTALL}/${RUN_SCRIPT},target=${TMP_IMAGE_SCRIPT}/${RUN_SCRIPT} \
            --mount=type=bind,source=${SCRIPT_INSTALL}/utils,target=${TMP_IMAGE_SCRIPT}/utils \
            ${TMP_IMAGE_SCRIPT}/${RUN_SCRIPT} run_install && \
            ${TMP_IMAGE_SCRIPT}/${RUN_SCRIPT} verify_installation

ARG RUN_SCRIPT="install_basic_system_apps.sh"
RUN --mount=type=bind,source=${SCRIPT_INSTALL}/${RUN_SCRIPT},target=${TMP_IMAGE_SCRIPT}/${RUN_SCRIPT} \
            --mount=type=bind,source=${SCRIPT_INSTALL}/utils,target=${TMP_IMAGE_SCRIPT}/utils \
            ${TMP_IMAGE_SCRIPT}/${RUN_SCRIPT} run_install && \
            ${TMP_IMAGE_SCRIPT}/${RUN_SCRIPT} verify_installation

USER $USER
WORKDIR $HOME
