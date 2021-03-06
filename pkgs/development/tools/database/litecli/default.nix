{ lib, python3Packages, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.4.1";

  # Python 2 won't have prompt_toolkit 2.x.x
  # See: https://github.com/NixOS/nixpkgs/blob/f49e2ad3657dede09dc998a4a98fd5033fb52243/pkgs/top-level/python-packages.nix#L3408
  disabled = python3Packages.isPy27;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "FARWjtbS5zi/XQDyAVImUmArLj8xATz1jZ4jnXFdq1w=";
  };

  patches = [
    # Fix compatibility with sqlparse >= 0.4.0. Remove with the next release
    (fetchpatch {
      url = "https://github.com/dbcli/litecli/commit/37957e401d22f88800bbdec2c690e731f2cc13bd.patch";
      sha256 = "1x82s2h1rzflyiahyd8pfya30rzs6yx6ij4a4s16f8iix5x35zv9";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt_toolkit
    pygments
    sqlparse
  ];

  checkInputs = with python3Packages; [
    pytest
    mock
  ];

  preCheck = ''
    export XDG_CONFIG_HOME=$TMP
    # add missing file
    mkdir -p tests/data
    echo -e "t1,11\nt2,22\n" > tests/data/import_data.csv
  '';

  meta = with lib; {
    description = "Command-line interface for SQLite";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
