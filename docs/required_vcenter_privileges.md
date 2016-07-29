### Required vSphere Privileges

<!--- NOTE: the tables in this file are parsed by the integration tests to verify required permissions -->

The vSphere CPI requires its vCenter user to have the following privileges in order to deploy and manage your deployments.

#### vCenter Root Privileges

These privileges must be granted on the root vCenter Server entity.

<table id="vcenter-root-privileges">
  <thead>
    <tr>
      <th>Object</th><th>Privilege (UI)</th><th>Privilege (API)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="4">Role</td>
    </tr>
    <tr><td>Read-only</td><td>System.Anonymous</td></tr>
    <tr><td></td><td>System.Read</td></tr>
    <tr><td></td><td>System.View</td></tr>
    <tr>
      <td rowspan="2">Global</td>
    </tr>
    <tr><td>Manage custom attributes</td><td>Global.ManageCustomFields</td></tr>
  </tbody>
</table>

#### vCenter Datacenter Privileges

These privileges must be granted on any Datacenter entities the CPI will interact with.

<table id="vcenter-datacenter-privileges">
  <thead>
    <tr>
      <th>Object</th><th>Privilege (UI)</th><th>Privilege (API)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="4">Role</td>
    </tr>
    <tr><td>Users inherit the Read-Only role from the vCenter root level</td><td>System.Anonymous</td></tr>
    <tr><td></td><td>System.Read</td></tr>
    <tr><td></td><td>System.View</td></tr>
    <tr>
      <td rowspan="6">Datastore</td>
    </tr>
    <tr><td>Allocate space</td><td>Datastore.AllocateSpace</td></tr>
    <tr><td>Browse datastore</td><td>Datastore.Browse</td></tr>
    <tr><td>Low level file operations</td><td>Datastore.FileManagement</td></tr>
    <tr><td>Remove file</td><td>Datastore.DeleteFile</td></tr>
    <tr><td>Update virtual machine files</td><td>Datastore.UpdateVirtualMachineFiles</td></tr>
    <tr>
      <td rowspan="5">Folder</td>
    </tr>
    <tr><td>Create folder</td><td>Folder.Create</td></tr>
    <tr><td>Delete folder</td><td>Folder.Delete</td></tr>
    <tr><td>Move folder</td><td>Folder.Move</td></tr>
    <tr><td>Rename folder</td><td>Folder.Rename</td></tr>
    <tr>
      <td rowspan="2">Global</td>
    </tr>
    <tr><td>Set custom attribute</td><td>Global.SetCustomField</td></tr>
    <tr>
      <td rowspan="2">Host</td>
    </tr>
    <tr><td>Inventory > Modify cluster</td><td>Host.Inventory.EditCluster</td></tr>
    <tr>
      <td rowspan="4">Inventory Service</td>
    </tr>
    <tr><td>vSphere Tagging > Create vSphere Tag</td><td>InventoryService.Tagging.CreateTag</td></tr>
    <tr><td>vSphere Tagging > Delete vSphere Tag</td><td>InventoryService.Tagging.DeleteTag</td></tr>
    <tr><td>vSphere Tagging > Edit vSphere Tag</td><td>InventoryService.Tagging.EditTag</td></tr>
    <tr>
      <td rowspan="2">Network</td>
    </tr>
    <tr><td>Assign network</td><td>Network.Assign</td></tr>
    <tr>
      <td rowspan="4">Resource</td>
    </tr>
    <tr><td>Assign virtual machine to resource pool</td><td>Resource.AssignVMToPool</td></tr>
    <tr><td>Migrate powered off virtual machine</td><td>Resource.ColdMigrate</td></tr>
    <tr><td>Migrate powered on virtual machine</td><td>Resource.HotMigrate</td></tr>
    <tr>
      <td rowspan="52">Virtual Machine</td>
    </tr>
    <tr><td>Configuration > Add existing disk</td><td>VirtualMachine.Config.AddExistingDisk</td></tr>
    <tr><td>Configuration > Add new disk</td><td>VirtualMachine.Config.AddNewDisk</td></tr>
    <tr><td>Configuration > Add or remove device</td><td>VirtualMachine.Config.AddRemoveDevice</td></tr>
    <tr><td>Configuration > Advanced</td><td>VirtualMachine.Config.AdvancedConfig</td></tr>
    <tr><td>Configuration > Change CPU count</td><td>VirtualMachine.Config.CPUCount</td></tr>
    <tr><td>Configuration > Change resource</td><td>VirtualMachine.Config.Resource</td></tr>
    <tr><td>Configuration > Configure managedBy</td><td>VirtualMachine.Config.ManagedBy</td></tr>
    <tr><td>Configuration > Disk change tracking</td><td>VirtualMachine.Config.ChangeTracking</td></tr>
    <tr><td>Configuration > Disk lease</td><td>VirtualMachine.Config.DiskLease</td></tr>
    <tr><td>Configuration > Display connection settings</td><td>VirtualMachine.Config.MksControl</td></tr>
    <tr><td>Configuration > Extend virtual disk</td><td>VirtualMachine.Config.DiskExtend</td></tr>
    <tr><td>Configuration > Memory</td><td>VirtualMachine.Config.Memory</td></tr>
    <tr><td>Configuration > Modify device settings</td><td>VirtualMachine.Config.EditDevice</td></tr>
    <tr><td>Configuration > Raw device</td><td>VirtualMachine.Config.RawDevice</td></tr>
    <tr><td>Configuration > Reload from path</td><td>VirtualMachine.Config.ReloadFromPath</td></tr>
    <tr><td>Configuration > Remove disk</td><td>VirtualMachine.Config.RemoveDisk</td></tr>
    <tr><td>Configuration > Rename</td><td>VirtualMachine.Config.Rename</td></tr>
    <tr><td>Configuration > Reset guest information</td><td>VirtualMachine.Config.ResetGuestInfo</td></tr>
    <tr><td>Configuration > Set annotation</td><td>VirtualMachine.Config.Annotation</td></tr>
    <tr><td>Configuration > Settings</td><td>VirtualMachine.Config.Settings</td></tr>
    <tr><td>Configuration > Swapfile placement</td><td>VirtualMachine.Config.SwapPlacement</td></tr>
    <tr><td>Configuration > Unlock virtual machine</td><td>VirtualMachine.Config.Unlock</td></tr>
    <tr><td>Interaction > Answer question</td><td>VirtualMachine.Interact.AnswerQuestion</td></tr>
    <tr><td>Interaction > Configure CD media</td><td>VirtualMachine.Interact.SetCDMedia</td></tr>
    <tr><td>Interaction > Device connection</td><td>VirtualMachine.Interact.DeviceConnection</td></tr>
    <tr><td>Interaction > Power off</td><td>VirtualMachine.Interact.PowerOff</td></tr>
    <tr><td>Interaction > Power on</td><td>VirtualMachine.Interact.PowerOn</td></tr>
    <tr><td>Interaction > Reset</td><td>VirtualMachine.Interact.Reset</td></tr>
    <tr><td>Interaction > Suspend</td><td>VirtualMachine.Interact.Suspend</td></tr>
    <tr><td>Interaction > VMware Tools install</td><td>VirtualMachine.Interact.ToolsInstall</td></tr>
    <tr><td>Inventory > Create from existing</td><td>VirtualMachine.Inventory.CreateFromExisting</td></tr>
    <tr><td>Inventory > Create new</td><td>VirtualMachine.Inventory.Create</td></tr>
    <tr><td>Inventory > Move</td><td>VirtualMachine.Inventory.Move</td></tr>
    <tr><td>Inventory > Remove</td><td>VirtualMachine.Inventory.Delete</td></tr>
    <tr><td>Provisioning > Allow disk access</td><td>VirtualMachine.Provisioning.DiskRandomAccess</td></tr>
    <tr><td>Provisioning > Allow read-only disk access</td><td>VirtualMachine.Provisioning.DiskRandomRead</td></tr>
    <tr><td>Provisioning > Allow virtual machine download</td><td>VirtualMachine.Provisioning.GetVmFiles</td></tr>
    <tr><td>Provisioning > Allow virtual machine files upload</td><td>VirtualMachine.Provisioning.PutVmFiles</td></tr>
    <tr><td>Provisioning > Clone template</td><td>VirtualMachine.Provisioning.CloneTemplate</td></tr>
    <tr><td>Provisioning > Clone virtual machine</td><td>VirtualMachine.Provisioning.Clone</td></tr>
    <tr><td>Provisioning > Customize</td><td>VirtualMachine.Provisioning.Customize</td></tr>
    <tr><td>Provisioning > Deploy template</td><td>VirtualMachine.Provisioning.DeployTemplate</td></tr>
    <tr><td>Provisioning > Mark as template</td><td>VirtualMachine.Provisioning.MarkAsTemplate</td></tr>
    <tr><td>Provisioning > Mark as virtual machine</td><td>VirtualMachine.Provisioning.MarkAsVM</td></tr>
    <tr><td>Provisioning > Modify customization specification</td><td>VirtualMachine.Provisioning.ModifyCustSpecs</td></tr>
    <tr><td>Provisioning > Promote disks</td><td>VirtualMachine.Provisioning.PromoteDisks</td></tr>
    <tr><td>Provisioning > Read customization specifications</td><td>VirtualMachine.Provisioning.ReadCustSpecs</td></tr>
    <tr><td>Snapshot management > Create snapshot</td><td>VirtualMachine.State.CreateSnapshot</td></tr>
    <tr><td>Snapshot management > Remove snapshot</td><td>VirtualMachine.State.RemoveSnapshot</td></tr>
    <tr><td>Snapshot management > Rename snapshot</td><td>VirtualMachine.State.RenameSnapshot</td></tr>
    <tr><td>Snapshot management > Revert snapshot</td><td>VirtualMachine.State.RevertToSnapshot</td></tr>
    <tr>
      <td rowspan="4">vApp</td>
    </tr>
    <tr><td>Import</td><td>VApp.Import</td></tr>
    <tr><td>vApp application configuration</td><td>VApp.ApplicationConfig</td></tr>
    <tr><td>vApp instance configuration</td><td>VApp.InstanceConfig</td></tr>
  </tbody>
</table>
