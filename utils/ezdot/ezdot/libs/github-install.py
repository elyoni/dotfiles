import requests

class Git

class GithubInstall():
    #  BASE_URL = "https://github.com/jonas/tig/releases"
    BASE_URL = "https://api.github.com/repos"
    def __init__(self, git_repository_name: str, name: str) -> None:
        self.git_repository_name = git_repository_name 
        self.name = name

    def download_release(self, version: str, suffix: str) -> None:
        #  URL="https://api.github.com/repos/jonas/tig/releases/tags/tig-2.5.8"
        URL = f"{self.BASE_URL}/{self.git_repository_name}/releases/tags/{self.name}-{version}"
        # 2. download the data behind the URL
        response = requests.get(URL)
        # 3. Open the response into a new file called instagram.ico
        open("instagram.ico", "wb").write(response.content)
        response.json()["assets"][0]["browser_download_url"].endswith('cheese')


if __name__ == "__main__":
    git_inst = GithubInstall("jonas/tig", "tig")
    git_inst.download_release("2.5.8", "tar.gz")


if __name__ == "__main__":
    app = Application(type="enum.github",
                      name="tig",
                      version=["latest"|"1.1.1"],
                      settings=GithubConfig(repo="jonas/tig"),
                      dependencies=Dependencies([PackageApt(name="one", version="1.1.1"),
                                                 PackageApt(name="two"),
                                                 PackagePip(name="three")])
                      dotfiles=[source:target,
                                source:target],
                      )


    app = GithubPackage(name="tig",
                      version=["latest"|"1.1.1"],
                      settings=GithubConfig(repo="jonas/tig", suffix="tar.gz"),
                      dependencies=Dependencies([PackageApt(name="one", version="1.1.1"),
                                                 PackageApt(name="two"),
                                                 PackagePip(name="three")])
                      dotfiles=[source:target,
                                source:target],
                      )

    if not app.verify():
        app.install():
            app.download()
            app.make()
            app.dotfiles_install()
        #  return app.verify()
                     
                         suffix="tar.gz")


    app = Application(type="enum.pip", name="cdiff")
    if not app.verify():
        app.install():
            app.pip_install()
            app.dotfiles_install()
        #  return app.verify()
    
    app = Application(type="enum.apt", name="pulseaudio")
    if not app.verify():
        app.install():
            app.pip_install()
            app.dotfiles_install()
        #  return app.verify():


    sudo pip install --upgrade cdiff
