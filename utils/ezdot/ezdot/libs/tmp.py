import subprocess
from pathlib import Path
from urllib import request
import os
import stat

#  from requests.models import ProtocolError

GITHUB_URL_RAW="https://raw.github.com"
GITHUB_URL_CLONE="https://github.com"

class GithubFilePackage()

def github_file_download(project_name: str,
                         version: str,
                         file_path: str,
                         output_file_dir:str = ".",
                         output_file_name:str = ""):
    # Example:
    #   github_file_download("robbyrussell/oh-my-zsh", "master", "tools/install.sh")
    _project_name: str = project_name
    _version: str = version
    _file_path: str = file_path
    _output_file_dir: str = output_file_dir
    _file_url: str

    _output_file_name: str
    _output_file_name: str = _file_path.split(os.path.sep)[-1] if \
            output_file_name == "" else output_file_name


    os.makedirs(_output_file_dir, exist_ok=True) 

    _file_url = f"{GITHUB_URL_RAW}/{_project_name}/{_version}/{_file_path}"
    print(f"Download file: {_file_url}")
    print(f"Download localtion: {os.path.join(_output_file_dir, _output_file_name)}")
    request.urlretrieve(_file_url, os.path.join(_output_file_dir, _output_file_name), )

def github_clone_package(name:str, version: str|None = None, destination: str = ".", depth: int = 1):
    # Clone a git project, the name is the name of the project
    # Example:
    #   name="zsh-users/zsh-syntax-highlighting"
    #   version="my_test_branch"
    _version = "" if version is None else f" --branch={version} "
    f"git clone {GITHUB_URL_CLONE}/{name}.git --depth={depth}{_version}{destination}"


    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
     

def change_file_permmision(script_directory: str, script_name: str) -> bool:
    _script_path = os.path.join(script_directory, script_name)
    file_stats = os.stat(_script_path)
    try:
        os.chmod(_script_path, file_stats.st_mode | stat.S_IEXEC)
        # Return True the file has permission and False if not
        return os.access(_script_path, mode=os.X_OK)  
    except PermissionError:
        error = f"ERROR: The file {_script_path} has not permmision"
        raise PermissionError(error)

def execute_shell_script(script_directory: str, script_name: str) -> bool:
    _script_path = os.path.join(script_directory, script_name)
    if not os.access(_script_path, mode=os.X_OK):
        error = f"The file {_script_path} don't have execute permmision"
        raise PermissionError(error)

    command = os.path.join(".", _script_path)
    output: subprocess.CompletedProcess = subprocess.run(command, shell=True)
    try:
        output.check_returncode()
    except subprocess.CalledProcessError:
        return False

    return True

def apt_get_install_package(name: str, version: str = "", sudo: bool=True):
    _sudo: str = "sudo " if sudo else ""
    _version: str = "" if version == "" else f"=={version}"
    command = f"{_sudo} apt-get install -y {name}{_version}"
    subprocess.run(command, shell=True)

def apt_get_verify_installed_package(name: str, version: str = ""):
    command = "dpkg-query -W --showformat='${Status}\n'" + f" {name}" + \
            '|grep "install ok installed"'
    output = subprocess.run(command, shell=True)
    try:
        output.check_returncode()
        return True
    except subprocess.CalledProcessError:
        return False


def dotfiles_link_file(source: str, destination: str):
    _source = source
    _destination = destination
    os.symlink(_source, _destination)

def dotfiles_link_file_verify(source: str, destination: str):
    _source = source

    link_point_to: str = os.readlink(destination)
    return link_point_to == _source

def dotfiles_link_folder(source: str, destination: str, force=False):
    # The function can raise FileExistsError if the folder already exists
    # If the user will choose force = True it will override the folder
    _destination: Path = Path(destination)
    _source: Path = Path(source)

    if _destination.is_symlink():
        # Link exists, remove the link
        _destination.unlink()

    if _destination.is_dir() and force:
        # Folder exists, remove the folder
        _destination.rmdir()

    _destination.symlink_to(_source, target_is_directory=True)

def dotfiles_link_folder_verify(source: str, destination: str):
    _source = source

    link_point_to: str = os.readlink(destination)
    return link_point_to == _source


DOTFILE_DIR: str = "/tmp/dotfiles"
HOME_DIR: str = os.getenv("HOME", ".")

#  apt_get_install_package(name="zsh")
#  apt_get_verify_installed_package(name="zsh")
#
#  github_file_download(project_name="robbyrussell/oh-my-zsh",
#                       version="master",
#                       file_path="tools/install.sh",
#                       output_file_dir="/tmp/install",
#                       output_file_name="new_install.sh")
#
#  change_file_permmision("/tmp/install", "new_install.sh")
#  execute_shell_script("/tmp/install", "new_install.sh")
#
#  dotfiles_link_file( os.path.join(DOTFILE_DIR, "zsh/zshrc"),
#          os.path.join(HOME_DIR, ".zshrc"))

if not dotfiles_link_file_verify( os.path.join(DOTFILE_DIR, "zsh", "zshrc"),
                                 os.path.join(HOME_DIR, ".zshrc")):
    print("Not good")


dotfiles_link_folder(os.path.join(DOTFILE_DIR, "zsh", "zsh_config"),
        os.path.join(HOME_DIR, ".config", "zsh"))

if not dotfiles_link_folder_verify(os.path.join(DOTFILE_DIR, "zsh", "zsh_config"),
                               os.path.join(HOME_DIR, ".config", "zsh")):
    print("ERROR")
