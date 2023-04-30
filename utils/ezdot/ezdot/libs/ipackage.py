from __future__ import annotations
import subprocess

class IPackageConfig():
    pass

class GithubShPackageConfig(IPackageConfig):
    def __init__(self,
                 script_path: str|None):
        self.script_path = script_path

class IPackage():
    def __init__(self, name:str,
                 version:str|None=None,
                 settings: IPackageConfig|None=None,
                 dotfiles: list[str]=[]):
        self.name: str = name
        self.version: str|None = version  # If version is None then version=Latest

        self.dependencies: list[IPackage] = []
        self.settings = None
        self.dotfiles: list[str] = []

    def set_dependencies(self, dependencies: list[IPackage]):
        self.dependencies: list[IPackage] = dependencies

    def set_package_settings(self, settings: IPackageConfig):
        self.settings = settings

    def set_dotfiles(self, dotfiles: list[str]):
        self.dotfiles: list[str] = dotfiles

    def install(self, force:bool=False) -> bool:
        return False

    def uninstall(self) -> bool:
        return False

    def _install_dependencies(self, force:bool=False) -> bool:
        return False

    def _install_dotfiles(self, force:bool=False)  -> bool:
        return False

    def verify(self) -> bool:
        return False

class PipPackage(IPackage):
    PIP_GLOBAL_PATH="${HOME}/.local/bin/pip"

    def install(self, force:bool=False) -> bool:
        package_name: str = self.name
        if self.version is not None:
            package_name=f"{self.name}==self.version"
        subprocess.run([f'{self.PIP_GLOBAL_PATH} install {package_name}'], shell=True)
        return True

    def uninstall(self) -> bool:
        package_name: str = self.name
        subprocess.run([f'{self.PIP_GLOBAL_PATH} uninstall {package_name} --yes'], shell=True)
        return True

class PipxPackage(IPackage):
    PIPX_GLOBAL_PATH="${HOME}/.local/bin/pipx"

    def install(self, force:bool=False) -> bool:
        package_name: str = self.name
        if self.version is not None:
            package_name=f"{self.name}==self.version"

        subprocess.run([f'{self.PIPX_GLOBAL_PATH} install {package_name} --force'], shell=True)
        return True

    def uninstall(self) -> bool:
        package_name: str = self.name
        subprocess.run([f'{self.PIPX_GLOBAL_PATH} uninstall {package_name}'], shell=True)
        return True

class GithubShPackage(IPackage):

    #  def __init__(self, git_repository_name: str, name: str) -> None:
    #      self.git_repository_name = git_repository_name
    #      self.name = name

    BASE_URL = "https://raw.github.com/"
    def install(self, force:bool=False) -> bool:
        if self.settings is None:
            raise KeyError("The package configs wan ")
        f"{self.BASE_URL}/{self.name}/{self.version}/{self.settings.script_path}"
        # sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

        # sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
        package_name: str = self.name
        if self.version is not None:
            package_name=f"{self.name}==self.version"

        subprocess.run([f'{self.PIPX_GLOBAL_PATH} install {package_name} --force'], shell=True)
        return True

if __name__ == "__main__":
    pip_package = PipxPackage("cowsay")
    pip_package.install()
    pip_package.uninstall()

    git_pack = GithubShPackage(name="robbyrussell/oh-my-zsh",
                               version="master",
                               settings=GithubShPackageConfig(script_path="tools/install.sh"))
