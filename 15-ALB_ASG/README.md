# 14-Dns-To-Db2 - Modularized Infrastructure

This project demonstrates a modularized version of the DNS-to-Database infrastructure, breaking down the monolithic Terraform configuration into reusable modules.

## Architecture

The infrastructure is organized into the following modules:

### Modules Structure
```
modules/
├── vpc/          # VPC, subnets, NAT gateway
├── security/     # Security groups
├── compute/      # EC2 instances (bastion, app servers)
├── database/     # RDS MySQL database
├── loadbalancer/ # Application Load Balancer
└── dns/          # Route53 records and ACM certificates
```

### Benefits of Modularization

1. **Reusability**: Modules can be reused across environments
2. **Maintainability**: Easier to maintain and update specific components
3. **Testing**: Individual modules can be tested separately
4. **Separation of Concerns**: Each module has a specific responsibility
5. **Team Collaboration**: Different teams can work on different modules

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan the deployment**:
   ```bash
   terraform plan
   ```

3. **Deploy the infrastructure**:
   ```bash
   terraform apply
   ```

## Configuration

- **Variables**: Defined in `variables.tf`
- **Environment-specific values**: Set in `dev.auto.tfvars`
- **Outputs**: Defined in `outputs.tf`

## Module Dependencies

The modules have the following dependencies:
1. VPC (foundation)
2. Security (depends on VPC)
3. DNS (can be created independently)
4. Compute (depends on VPC, Security)
5. Database (depends on VPC, Security)
6. Load Balancer (depends on VPC, Security, DNS for certificate)

## Comparison with Monolithic Version

| Aspect | Monolithic (13-Dns-To-DB) | Modularized (14-Dns-To-Db2) |
|--------|---------------------------|------------------------------|
| Files | Single directory with all resources | Organized into module directories |
| Reusability | Limited | High |
| Maintainability | Difficult for large configs | Easy to maintain |
| Testing | All or nothing | Module-level testing |
| Team Collaboration | Conflicts likely | Parallel development |