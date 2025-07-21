import json
import subprocess
import argparse

# Predefined rules
port_presets = {
    "ssh": {"from_port": 22, "to_port": 22, "description": "SSH access"},
    "http": {"from_port": 80, "to_port": 80, "description": "HTTP access"},
    "https": {"from_port": 443, "to_port": 443, "description": "HTTPS access"},
    "tcp": {"from_port": 0, "to_port": 65535, "description": "All TCP traffic"},
}

def parse_args():
    parser = argparse.ArgumentParser(description="Generate terraform.tfvars.json from SG inputs.")
    parser.add_argument("--sg-name", required=True, help="Security Group name (e.g. my-sg)")
    parser.add_argument("--ingress-rules", required=True,
                        help="Comma-separated list: ssh,http,tcp or custom:8080:8080:my-desc")
    return parser.parse_args()

def build_ingress_rules(ingress_str):
    rules = []
    entries = ingress_str.split(",")
    for entry in entries:
        entry = entry.strip()
        if entry in port_presets:
            rules.append(port_presets[entry])
        elif entry.startswith("custom:"):
            try:
                _, from_port, to_port, desc = entry.split(":", 3)
                rules.append({
                    "from_port": int(from_port),
                    "to_port": int(to_port),
                    "description": desc
                })
            except Exception as e:
                print(f"Invalid custom rule: {entry} — {e}")
        else:
            print(f"⚠️ Skipping unknown rule type: {entry}")
    return rules

def main():
    args = parse_args()

    ingress_rules = build_ingress_rules(args.ingress_rules)

    egress_rules = [{
        "from_port": 0,
        "to_port": 0,
        "description": "Allow all outbound traffic"
    }]

    tfvars = {
        "sg_name": args.sg_name,
        "ingress_rules": ingress_rules,
        "egress_rules": egress_rules,
        "allowed_cidrs": ["0.0.0.0/0"],
        "environment": "dev",
        "managed_by": "terraform"
    }

    with open("terraform.tfvars.json", "w") as f:
        json.dump(tfvars, f, indent=2)

    print("✅ terraform.tfvars.json created")
    print(json.dumps(tfvars, indent=2))

    subprocess.run(["terraform", "apply", "-var-file=terraform.tfvars.json"], check=True)

if __name__ == "__main__":
    main()
