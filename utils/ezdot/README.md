

YAML:
    type: "github"
    release: True
    repository: "jonas/tig"
    name: "tig"
    version: 2.5.0
    suffix: tar.gz
    dependencies:
        apt:
            - libncurses5-dev
            - libncursesw5-dev
    installation:
        path: $HOME/.local/ezdot/apps/$NAME-$VERSION
        type: make
