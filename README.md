# Northstar Enterprise Active Directory Lab

## Overview

Northstar is a simulated enterprise Windows environment built to develop and demonstrate hands-on experience with **Active Directory, Windows Server, DNS, Group Policy, PowerShell automation, and Windows endpoint administration**.

The lab represents a fictional organization with IT, HR, Finance, and Sales departments. It includes a Windows Server 2025 domain controller and a domain-joined Windows 11 workstation running in Microsoft Hyper-V.

The project focuses on practical enterprise administration: building the environment, automating common tasks, applying centralized policies, validating configurations, and troubleshooting issues.

---

## Technologies

**Windows Server 2025** • **Windows 11 Pro** • **Active Directory Domain Services** • **DNS** • **Group Policy** • **PowerShell** • **Hyper-V** • **TCP/IP**

---

## Lab Architecture

```text
                    Hyper-V Host
                         │
                  LAB-NET (Internal)
                   10.10.10.0/24
                         │
              ┌──────────┴──────────┐
              │                     │
            DC01                 CLIENT01
      Windows Server 2025       Windows 11 Pro
         10.10.10.10             10.10.10.20
              │                     │
         AD DS + DNS            Domain Joined
              │                     │
              └── ad.northstar.test ┘
```

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller / DNS | `10.10.10.10` |
| CLIENT01 | Windows 11 Workstation | `10.10.10.20` |

**Domain:** `ad.northstar.test`  
**NetBIOS:** `NORTHSTAR`

---

## What I've Built

### Active Directory Infrastructure

Deployed a Windows Server 2025 Active Directory forest and configured **DC01** as the Domain Controller, DNS server, and Global Catalog.

Designed an organizational structure representing a multi-department company:

```text
Northstar
├── Users
│   ├── IT
│   ├── HR
│   ├── Finance
│   └── Sales
├── Computers
│   └── Workstations
├── Groups
├── Servers
├── Admin Accounts
└── Service Accounts
```

Created departmental Global Security Groups:

- `GG-IT-Users`
- `GG-HR-Users`
- `GG-Finance-Users`
- `GG-Sales-Users`

---

### PowerShell User Provisioning

Developed a CSV-driven PowerShell script to automate Active Directory user provisioning.

The script automatically:

- Imports employee data from CSV
- Creates users in the appropriate departmental OU
- Configures account and department attributes
- Assigns users to their departmental security group
- Checks for existing accounts to prevent duplicate creation
- Securely requests the initial password at runtime

Used the script to provision **10 domain users across IT, HR, Finance, and Sales**.

**Project files:** [PowerShell Provisioning Script](scripts/New-NorthstarUsers.ps1) | [Sample User Data](scripts/users.csv)

---

### DNS & Domain Services

Configured and validated Active Directory-integrated DNS on DC01.

Verified:

- Domain name resolution
- AD DNS zones
- Domain Controller discovery
- LDAP SRV records
- DNS health using `dcdiag`
- DNS resolution from CLIENT01

CLIENT01 uses DC01 as its DNS server, allowing it to discover Active Directory services within the Northstar domain.

---

### Windows 11 Domain Integration

Configured CLIENT01 with a static network configuration and joined it to:

`ad.northstar.test`

Successfully authenticated to Windows using a provisioned Northstar domain account and verified that authentication was being handled by **DC01**.

CLIENT01 was then moved into:

`Northstar > Computers > Workstations`

This allows workstation-specific policies to be centrally targeted through Group Policy.

---

### Group Policy

Created a dedicated workstation security GPO:

**Northstar - Workstation Security Baseline**

The policy is linked to the **Workstations OU** and currently configures:

- 15-minute machine inactivity lock
- Northstar interactive logon security notice

Policy deployment was validated on CLIENT01 using `gpupdate`, `gpresult`, and direct verification of the configured workstation setting.

---

## Troubleshooting

During the original domain deployment, I encountered an issue where the expected Active Directory DNS zone was not being created correctly.

I isolated the problem by testing network connectivity separately from DNS, inspecting DNS zones and AD records, reviewing domain-controller diagnostics, and reproducing the issue after restoring the server to a clean checkpoint.

The environment was ultimately rebuilt using `ad.northstar.test`, after which the AD-integrated DNS zones and SRV records were successfully created and validated.

The exact cause of the original namespace-specific failure was not conclusively identified, so the project documents the observed behavior and troubleshooting process rather than assuming an unverified root cause.

---

## Current Progress

**Completed:**

- Windows Server 2025 Domain Controller
- Active Directory Domain Services
- AD-integrated DNS
- Enterprise-style OU structure
- Department security groups
- PowerShell bulk user provisioning
- Windows 11 domain-joined workstation
- Domain user authentication
- Centralized workstation Group Policy
- DNS troubleshooting and validation

**Next:**

- Departmental file shares
- NTFS and share permissions
- AGDLP role-based access model
- Drive mapping through Group Policy
- PowerShell onboarding/offboarding automation
- Additional workstation security controls
- Administrative troubleshooting scenarios

---

## Skills Demonstrated

`Active Directory` `Windows Server` `DNS` `Group Policy` `PowerShell` `Hyper-V` `Windows 11` `Identity Management` `Endpoint Administration` `Networking` `Troubleshooting`

---

## Documentation

Detailed technical documentation, PowerShell scripts, architecture diagrams, and configuration screenshots will be added as the environment develops.

```text
docs/           Detailed implementation documentation
scripts/        PowerShell automation and sample data
screenshots/    Configuration and validation evidence
diagrams/       Network and Active Directory architecture
```

---

## About This Project

This is an isolated home lab built for hands-on learning and technical portfolio development. It does not contain production credentials, real organizational data, or other sensitive information.

The environment will continue to evolve as additional Windows infrastructure, automation, identity, endpoint-management, and security technologies are implemented.
