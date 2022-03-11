from dataclasses import dataclass
from enum import Enum
from typing import Optional
from abc import abstractmethod, ABC


class PlatformEnum(Enum):

    LINUX = 'linux'
    WINDOWS = 'windows'
    MAC = 'mac'


class PackageManagerEnum(Enum):

    BREW = 'brew'
    CASK = 'cask'
    FLATPAK = 'flatpak'
    SNAP = 'snap'
    WINGET = 'winget'
    APT = 'apt'


@dataclass
class Package:

    identifier: str
    name: str
    manager: PackageManagerEnum
    ppa: Optional[str]
    version: Optional[str]


@dataclass
class PackageDetails:

    identifier: str
    display_name: Optional[str]
    package_managers: list[str]

    def name(self):
        return self.display_name or self.identifier


class Authorizer(ABC):

    def authorize(self):
        pass


@dataclass
class Command(ABC):

    require_sudo: bool
    cmd: str
    authorizer: Authorizer

    @abstractmethod
    def execute(self):
        pass
