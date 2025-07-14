import json
import subprocess

# Predefined rules
port_presets = {
    "ssh": {"from_port": 22, "to_port": 22, "description": "SSH access"},
    "http": {"from_port": 80, "to_port": 80, "description": "HTTP access"},
    "https": {"from_port": 443, "to_port": 443, "description": "HTTPS access"},
    "tcp": {"from_port": 0, "to_port": 65535, "description": "All TCP traffic"},
}

def ask_user():
    sg_name = input("Enter Security Group name (e.g. my-sg): ").strip()
    if not sg_name:
        print("Security Group name is required.")
        exit(1)

    print("\nWhich inbound rules do you want to add?")
    print("Options: ssh, http, https, tcp, custom")
    print("Example: ssh,http,custom")
    choices_input = input("Enter your choices: ")

    if not choices_input.strip():
        print("No options entered. Exiting.")
        exit(1)

    choices = [choice.strip().lower() for choice in choices_input.split(",")]

    ingress_rules = []

    for choice in choices:
        if choice in port_presets:
            ingress_rules.append(port_presets[choice])
        elif choice == "custom":
            while True:
                try:
                    from_port = int(input("Enter custom from_port: "))
                    to_port = int(input("Enter custom to_port: "))
                    desc = input("Enter description: ").strip()
                    ingress_rules.append({
                        "from_port": from_port,
                        "to_port": to_port,
                        "description": desc
                    })
                    more = input("Add another custom rule? (y/n): ").lower()
                    if more != "y":
                        break
                except ValueError:
                    print("Invalid input. Try again.")
        else:
            print(f"Unknown option '{choice}', skipping.")

    return sg_name, ingress_rules

def main():
    sg_name, ingress_rules = ask_user()

    egress_rules = [{
        "from_port": 0,
        "to_port": 0,
        "description": "Allow all outbound traffic"
    }]

    tfvars = {
        "sg_name": sg_name,
        "ingress_rules": ingress_rules,
        "egress_rules": egress_rules,
        "allowed_cidrs": ["0.0.0.0/0"],
        "environment": "dev",
        "managed_by": "terraform"
    }

    with open("terraform.tfvars.json", "w") as f:
        json.dump(tfvars, f, indent=2)

    print("\nterraform.tfvars.json generated:")
    print(json.dumps(tfvars, indent=2))

    print("\nRunning: terraform apply -var-file=terraform.tfvars.json")
    subprocess.run(["terraform", "apply", "-var-file=terraform.tfvars.json"])

if __name__ == "__main__":
    main()
