# Azure Change Plan

## Goal

Convert the current Azure Linux VM Terraform configuration into a lower-cost Windows VM deployment in Sweden Central.

## Scope

1. Change the default Azure region from Switzerland North to Sweden Central.
2. Replace the Linux VM resource with a Windows VM resource.
3. Update the default image to a Windows Server image.
4. Keep the default VM size on a low-cost burstable SKU where practical.
5. Reduce default disk cost by switching Premium disks to lower-cost Standard storage.
6. Replace SSH-focused access defaults with Windows/RDP-focused access defaults.
7. Update documentation text that still describes the deployment as Linux-only.

## Proposed Implementation

1. Change `azurerm_linux_virtual_machine` to `azurerm_windows_virtual_machine`.
2. Add a Windows admin password path using Terraform-managed password generation so the config remains deployable without manual password entry.
3. Replace the SSH NSG rule variable/default with an RDP NSG rule variable/default on port 3389.
4. Set location default to `Sweden Central`.
5. Keep `Standard_B1s` as the lowest-cost practical default VM size unless Azure validation shows an availability issue.
6. Change OS and data disk defaults from `Premium_LRS` to `Standard_LRS` to reduce cost.
7. Update README summary text to reflect a Windows VM.

## Assumptions

1. "Cheapest" means cheapest practical default configuration, not a spot VM.
2. A public IP remains enabled by default so the VM is still reachable.
3. A Windows VM should expose RDP rather than SSH.
4. Terraform should remain self-contained and runnable from GitHub Actions.

## Risk Notes

1. Windows requires password authentication; this is a material behavior change from the current SSH-based Linux setup.
2. Defaulting RDP access to an open CIDR would be unsafe, so the rule should remain disabled unless CIDRs are provided.
3. `Standard_B1s` availability and support for the chosen image can vary by region; validation is required.

## Validation

1. Run `terraform validate` after the edit.
2. If Terraform is available, run `terraform fmt` and `terraform validate` locally in the repo.

## Status

Implementation in progress.