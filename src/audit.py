import const as c
import yaml


class PackageConfigAudit:

    expected_config = {
        'identifier': r'([a-z\d]+-{0,1}+)+',
        'display_name': '.*'
    }

    def get_identifiers(self):
        pkg_managers = {}
        pkg_configs = c.PACKAGE_MANAGER_PATH.iterdir()
        for config_path in pkg_configs:
            manager_name = config_path.name
            with open(config_path, 'r') as config_file:
                pkg_managers[manager_name] = yaml.load(config_file, Loader=yaml.FullLoader)
        return pkg_managers


if __name__ == '__main__':
    pass