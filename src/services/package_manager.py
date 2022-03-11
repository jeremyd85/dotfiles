from src.models.base import Package, PackageManagerEnum, PlatformEnum
import subprocess
from getpass import getpass
from abc import ABC, abstractmethod
from dataclasses import dataclass


@dataclass
class PackageManager(ABC):

    identifier: PackageManagerEnum
    name: str
    platforms: list[PlatformEnum]

    @abstractmethod
    def batch_install(self, packages: list[Package]) -> bool:
        pass

    @abstractmethod
    def install(self, package: Package) -> bool:
        pass

    @abstractmethod
    def upgrade_all(self) -> bool:
        pass

    @abstractmethod
    def update_all(self) -> bool:
        pass

    @abstractmethod
    def remove(self, package: Package, level: int = 0):
        pass


class Apt(PackageManager):

    MANAGER_ENUM = PackageManagerEnum.APT

    def install(self, package: Package) -> bool:
        if package.manager != Apt.MANAGER_ENUM:
            return False
        # TODO: Add ppa before install
        cmd = f'apt install -y {package.name}'
        result = subprocess.run(cmd, capture_output=True, text=True)
        return not bool(result.stderr)

    def upgrade_all(self, ) -> bool:
        cmd = 'apt full-upgrade -y'
        result = subprocess.run(cmd, capture_output=True, text=True)
        return not bool(result.stderr)

    def update_all(self) -> bool:
        cmd = 'apt update -y'
        result = subprocess.run(cmd, capture_output=True, text=True)
        return not bool(result.stderr)

    def remove(self, package: Package, level: int = 0) -> bool:
        level_map = {
            0: f'apt remove {package.name}',
            1: f'apt purge {package.name}'
        }
        cmd = level_map[level]
        result = subprocess.run(cmd, capture_output=True, text=True)
        # TODO: Could use apt autoremove
        return not bool(result.stderr)

    def batch_install(self, packages: list[Package]) -> bool:
        # TODO: Add ppa before install
        cmd = f'apt install -y {" ".join(map(lambda pkg: pkg.name, packages))}'
        result = subprocess.run(cmd, capture_output=True, text=True)
        return not bool(result.stderr)
