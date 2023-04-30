from ezdot.libs.ipackage import IPackage
import subprocess

class AptPackage(IPackage):
    def __init__(self, name: str,
                 version: str = "",
                 sudo: bool=True) -> None:
        self._name: str = name
        self._sudo: str = "sudo " if sudo else ""
        self._version: str = "" if version == "" else f"=={version}"
        super().__init__() # Init other variables

    def install(self, with_dependeices=True, force:bool=False) -> bool:
        command = f"{self._sudo} apt-get install -y {self._name}{self._version}"
        subprocess.run(command, shell=True)
        return True

    def verify(self) -> bool:
        # Verify if the package as been installed on the system
        # TODO: Need to add the support for version
        command = "dpkg-query -W --showformat='${Status}\n'" + \
                f" {self._name}" + \
                '|grep "install ok installed"'
        output = subprocess.run(command, shell=True)
        try:
            output.check_returncode()
            return True
        except subprocess.CalledProcessError:
            return False

    def uninstall(self) -> bool:
        # TODO
        return False
