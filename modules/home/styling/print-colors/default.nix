{
  python3Packages,
  ...
}:

python3Packages.buildPythonApplication {
  pname = "print-colors";
  version = "1.0.0";

  src = ./.;

  propagatedBuildInputs = [ python3Packages.pyyaml ];

  doCheck = false;

  meta = {
    description = "Display colors from a YAML color palette file in the terminal.";
  };
}
