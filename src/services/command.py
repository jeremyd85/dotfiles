from ..models import Command
import subprocess

class Linux(Command):

    def execute(self):
        if self.require_sudo:
            if self.authorizer.validate
            self.cmd = "sudo " + self.cmd
        result = subprocess.run(self.cmd, capture_output=True, text=True)
        return result

