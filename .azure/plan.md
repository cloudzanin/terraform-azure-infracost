# Azure Change Plan

## Goal

Convert the current Terraform configuration into a lower-cost Windows VM deployment in Sweden Central and make GitHub Actions use shared Azure Storage remote state so deploy and destroy runs operate on the same Terraform state.

## Scope

1. Change the default Azure region from Switzerland North to Sweden Central.
2. Replace the Linux VM resource with a Windows VM resource.
3. Update the default image to a Windows Server image.
4. Keep the default VM size on a low-cost burstable SKU where practical.
5. Reduce default disk cost by switching Premium disks to lower-cost Standard storage.
6. Replace SSH-focused access defaults with Windows/RDP-focused access defaults.
7. Update documentation text that still describes the deployment as Linux-only.
8. Configure Terraform to use an Azure Storage remote backend.
9. Update GitHub Actions so deploy and destroy initialize Terraform against the same remote state.
10. Document the backend secrets and one-time backend bootstrap requirement.

## Proposed Implementation

1. Change `azurerm_linux_virtual_machine` to `azurerm_windows_virtual_machine`.
2. Add a Windows admin password path using Terraform-managed password generation so the config remains deployable without manual password entry.
3. Replace the SSH NSG rule variable/default with an RDP NSG rule variable/default on port 3389.
4. Set location default to `Sweden Central`.
5. Keep `Standard_B1s` as the lowest-cost practical default VM size unless Azure validation shows an availability issue.
6. Change OS and data disk defaults from `Premium_LRS` to `Standard_LRS` to reduce cost.
7. Update README summary text to reflect a Windows VM.
8. Add an `azurerm` backend block in the root Terraform configuration.
9. Keep backend values partial in code and pass backend coordinates from GitHub Actions via `-backend-config` so secrets and environment-specific values are not hardcoded.
10. Add a separate Terraform bootstrap stack that creates the backend resource group, storage account, and blob container.
11. Update deploy and destroy workflows to use the same backend resource group, storage account, container, and state key.
12. Add README guidance for required GitHub secrets and the one-time bootstrap flow for backend resources.

## Assumptions

1. "Cheapest" means cheapest practical default configuration, not a spot VM.
2. A public IP remains enabled by default so the VM is still reachable.
3. A Windows VM should expose RDP rather than SSH.
4. Terraform should remain self-contained and runnable from GitHub Actions.
5. Backend storage resources will be created once by a separate Terraform bootstrap stack to avoid the bootstrap problem.

## Risk Notes

1. Windows requires password authentication; this is a material behavior change from the current SSH-based Linux setup.
2. Defaulting RDP access to an open CIDR would be unsafe, so the rule should remain disabled unless CIDRs are provided.
3. `Standard_B1s` availability and support for the chosen image can vary by region; validation is required.
4. Remote backend adoption changes how state is stored; existing resources may need state migration or import depending on what was already created.
5. The Azure Storage backend requires backend coordinates to exist before `terraform init` can succeed.

## Validation

1. Run `terraform validate` after the edit.
2. If Terraform is available, run `terraform fmt` and `terraform validate` locally in the repo.
3. Confirm deploy and destroy workflows both call `terraform init` with identical backend configuration.
4. Confirm the bootstrap stack can be applied independently before running the root stack.

## Status

Bootstrap backend changes implemented. Ready for validation.