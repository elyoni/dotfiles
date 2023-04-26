import subprocess
from urllib import request
import os
import stat

GITHUB_URL_RAW="https://raw.github.com"
def github_file_download(project_name: str,
                         version: str,
                         file_path: str,
                         output_file_dir:str = "",
                         output_file_name:str = ""):
    # Example:
    #   github_file_download("robbyrussell/oh-my-zsh", "master", "tools/install.sh")
    _project_name: str = project_name
    _version: str = version
    _file_path: str = file_path
    _output_file_name: str
    _output_file_dir: str
    _file_url: str

    _output_file_name = _file_path.split(os.path.sep)[-1] if output_file_name == "" \
            else output_file_name

    _output_file_dir = "." if output_file_dir == "" \
            else output_file_dir
    # Create the folder if not exists
    os.makedirs(_output_file_dir, exist_ok=True) 

    _file_url = f"{GITHUB_URL_RAW}/{_project_name}/{_version}/{_file_path}"
    request.urlretrieve(_file_url, os.path.join(_output_file_dir, _output_file_name))

def bash_execute_script(script_path: str):
    #  current_stats = os.stat(script_path)
    st = os.stat(script_path)
    os.chmod(script_path, st.st_mode | stat.S_IEXEC)
    print(os.access(script_path, mode=os.X_OK))
    # TODO: Need to catch the exception of PermissionError()
    # Traceback (most recent call last):
    #  File "tmp.py", line 40, in <module>
    #    github_file_download(project_name="robbyrussell/oh-my-zsh",
    #  File "tmp.py", line 30, in github_file_download
    #    request.urlretrieve(_file_url, os.path.join(_output_file_dir, _output_file_name))
    #  File "/usr/lib/python3.8/urllib/request.py", line 257, in urlretrieve
    #    tfp = open(filename, 'wb')
    #PermissionError: [Errno 13] Permission denied: '/tmp/install/new_install.sh'



github_file_download(project_name="robbyrussell/oh-my-zsh",
                     version="master",
                     file_path="tools/install.sh",
                     output_file_dir="/tmp/install/",
                     output_file_name="new_install.sh")
bash_execute_script("/tmp/install/new_install.sh")
