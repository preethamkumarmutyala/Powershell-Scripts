import getpass
from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim
import ssl

def connect_to_vcenter(host, user, pwd, port):
    context = ssl._create_default_https_context()
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE
    si = SmartConnect(host=host,
                      user=user,
                      pwd=pwd,
                      port=port,
                      sslContext=context)
    return si

def fetch_vms(content):
    vm_list = []
    container = content.rootFolder
    view_type = [vim.VirtualMachine]
    recursive = True
    container_view = content.viewManager.CreateContainerView(container,
                                                              view_type,
                                                              recursive)
    vms = container_view.view
    for vm in vms:
        vm_info = {
            "Name": vm.name,
            "Power State": vm.runtime.powerState,
            "Guest OS": vm.config.guestFullName
        }
        vm_list.append(vm_info)
    container_view.Destroy()
    return vm_list

def main():
    # Prompt user for input
    host = input("Enter vCenter Server IP or hostname: ")
    user = input("Enter vCenter username: ")
    pwd = getpass.getpass(prompt="Enter vCenter password: ")
    port = 443  # Default port for vCenter
    
    try:
        si = connect_to_vcenter(host, user, pwd, port)
        content = si.RetrieveContent()
        vms = fetch_vms(content)
        
        print(f"{'Name':<30} {'Power State':<15} {'Guest OS':<30}")
        print("-" * 75)
        for vm in vms:
            print(f"{vm['Name']:<30} {vm['Power State']:<15} {vm['Guest OS']:<30}")
    
    except Exception as e:
        print(f"An error occurred: {e}")
    
    finally:
        Disconnect(si)

if __name__ == "__main__":
    main()
