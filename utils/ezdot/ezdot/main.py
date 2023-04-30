from ezdot.libs.apt_get_package import AptPackage

def main():
    zsh_p = AptPackage("zsh")
    zsh_p.install()


if __name__ == "__main__":
    main()


from ezdot.package import Application, AptPackage, PipPackage, MakePackage, GithubScriptPackage
tmux_app = Application(
        name="tmux",
        description="Terminal multiplexer",
        dependencies=[
            AptPackage(name="libevent-dev"),
            AptPackage(name="ncurses-dev"),
            AptPackage(name="build-essential"),
            AptPackage(name="bison"),
            AptPackage(name="pkg-config"),
            MakePackage(configure=True, make=True, install_sudo=True),
            PipPackage(name="tmux_test"),
            GithubScriptPackage(project_name="robbyrussell/oh-my-zsh",
                                version="master",
                                file_path="tools/install.sh",
                                output_file_dir="/tmp/install",
                                output_file_name="new_install.sh")
            ]
    )

