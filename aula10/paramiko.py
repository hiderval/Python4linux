
from paramiko import * #SSHClient
import paramiko
import sys
client = SSHClient()
client.load_system_host_keys()
client.connect('ssh.example.com')
stdin, stdout, stderr = client.exec_command('ls -l')

#192.168.203.X
IP = '192.168.203.9'
Usarname = 'noturno'
Password = 'noturno'

class SSH:
    def __init__(self):
        self.ssh = SSHClient()
        self.ssh = load_system_host_keys()
        self.ssh = set_missing_key_policy(paramiko.AutoAddPolicy())
        self.ssh = connect(hostname = IP, usarname = Usarname, password = Password)
        
        
    def exec_cmd(self, comando):
        stdin, stdout, stderr = self.ssh.exec_command(comando)
        if stderr.channel.recv_exit_status() != 0:
            print(stderr.read())
        else:
            print(stdout.read())

if __name__ == '__main__':
    
    ssh = SSH()
    ssh.exec_cmd('ls-l')
        
        
