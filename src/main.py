import subprocess
from argparse import ArgumentParser
import yaml
from pathlib import Path




def get_package_managers():
    pkg_managers = {}
    pkg_configs = PACKAGE_MANAGERS.iterdir()
    for config_path in pkg_configs:
        manager_name = config_path.name
        with open(config_path, 'r') as config_file:
            pkg_managers[manager_name] = yaml.load(config_file, Loader=yaml.FullLoader)
    return pkg_managers


def compare_package_managers():
    all_software = set()
    pkg_managers = get_package_managers()
    for manager in pkg_managers.values():
        if manager:
            software = manager['software'].keys()
            all_software.update(software)
        else:
            print('No software found')
    print(all_software)
    pkg_infos = []
    for pkg_name in all_software:
        pkg_info = {}
        pkg_info['name'] = pkg_name
        print(f'Name: {pkg_name}')
        pkg_info['display_name'] = input('Enter Display Name: ')
        print(yaml.dump(pkg_info))



if __name__ == '__main__':
    parser = ArgumentParser('')
    compare_package_managers()
