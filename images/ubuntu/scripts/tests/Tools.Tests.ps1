Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1"
Describe "azcopy" {
    It "azcopy" {
        "azcopy --version" | Should -ReturnZeroExitCode
    }

    It "azcopy10 link exists" {
        "azcopy10 --version" | Should -ReturnZeroExitCode
    }
}

Describe "Bicep" {
    It "Bicep" {
        "bicep --version" | Should -ReturnZeroExitCode
    }
}

Describe "Rust" {
    BeforeAll {
        $env:PATH = "/etc/skel/.cargo/bin:/etc/skel/.rustup/bin:$($env:PATH)"
        $env:RUSTUP_HOME = "/etc/skel/.rustup"
        $env:CARGO_HOME = "/etc/skel/.cargo"
    }

    It "Rustup is installed" {
        "rustup --version" | Should -ReturnZeroExitCode
    }

    It "Rustc is installed" {
        "rustc --version" | Should -ReturnZeroExitCode
    }

    It "Rustdoc is installed" -Skip:(Test-IsUbuntu24) {
        "rustdoc --version" | Should -ReturnZeroExitCode
    }

    It "Rustfmt is installed" -Skip:(Test-IsUbuntu24) {
        "rustfmt --version" | Should -ReturnZeroExitCode
    }

    Context "Cargo dependencies" {
        It "bindgen" -Skip:(Test-IsUbuntu24) {
            "bindgen --version" | Should -ReturnZeroExitCode
        }

        It "cbindgen" -Skip:(Test-IsUbuntu24) {
            "cbindgen --version" | Should -ReturnZeroExitCode
        }

        It "cargo" {
            "cargo --version" | Should -ReturnZeroExitCode
        }

        It "cargo-clippy" -Skip:(Test-IsUbuntu24) {
            "cargo-clippy --version" | Should -ReturnZeroExitCode
        }

        It "Cargo audit" -Skip:(Test-IsUbuntu24) {
            "cargo audit --version" | Should -ReturnZeroExitCode
        }

        It "Cargo outdated" -Skip:(Test-IsUbuntu24) {
            "cargo outdated --version" | Should -ReturnZeroExitCode
        }
    }
}

Describe "Docker" {
    It "docker client" {
        $version=(Get-ToolsetContent).docker.components | Where-Object { $_.package -eq 'docker-ce-cli' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(docker version --format '{{.Client.Version}}') | Should -BeLike "*$version*"
        }else{
            "docker version --format '{{.Client.Version}}'" | Should -ReturnZeroExitCode
        }
    }

    It "docker buildx" {
        $version=(Get-ToolsetContent).docker.plugins | Where-Object { $_.plugin -eq 'buildx' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(docker buildx version) | Should -BeLike "*$version*"
        }else{
            "docker buildx" | Should -ReturnZeroExitCode
        }
    }

    It "docker compose v2" {
        $version=(Get-ToolsetContent).docker.plugins | Where-Object { $_.plugin -eq 'compose' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(docker compose version --short) | Should -BeLike "*$version*"
        }else{
            "docker compose version --short" | Should -ReturnZeroExitCode
        }
    }

    It "docker-credential-ecr-login" {
        "docker-credential-ecr-login -v" | Should -ReturnZeroExitCode
    }
}

Describe "Docker images" -Skip:(Test-IsUbuntu24) {
    $testCases = (Get-ToolsetContent).docker.images | ForEach-Object { @{ ImageName = $_ } }

    It "<ImageName>" -TestCases $testCases {
       sudo docker images "$ImageName" --format "{{.Repository}}" | Should -Not -BeNullOrEmpty
    }
}

Describe "Docker-compose v1" -Skip:(Test-IsUbuntu24) {
    It "docker-compose" {
        "docker-compose --version"| Should -ReturnZeroExitCode
    }
}

Describe "Ansible" {
    It "Ansible" {
        "ansible --version" | Should -ReturnZeroExitCode
    }
}

Describe "Bazel" -Skip:(Test-IsUbuntu24) {
    It "<ToolName>" -TestCases @(
        @{ ToolName = "bazel" }
        @{ ToolName = "bazelisk" }
    ) {
        "$ToolName --version"| Should -ReturnZeroExitCode
    }
}

Describe "clang" {
    $testCases = (Get-ToolsetContent).clang.Versions | ForEach-Object { @{ClangVersion = $_} }

    It "clang <ClangVersion>" -TestCases $testCases {
        "clang-$ClangVersion --version" | Should -ReturnZeroExitCode
        "clang++-$ClangVersion --version" | Should -ReturnZeroExitCode
        "clang-format-$ClangVersion --version" | Should -ReturnZeroExitCode
        "clang-tidy-$ClangVersion --version" | Should -ReturnZeroExitCode
        "run-clang-tidy-$ClangVersion --help" | Should -ReturnZeroExitCode
    }
}

Describe "Cmake" {
    It "cmake" {
        "cmake --version" | Should -ReturnZeroExitCode
    }
}

Describe "erlang" -Skip:(Test-IsUbuntu22) {
    $testCases = @("erl -version", "erlc -v", "rebar3 -v") | ForEach-Object { @{ErlangCommand = $_} }

    It "erlang <ErlangCommand>" -TestCases $testCases {
        "$ErlangCommand" | Should -ReturnZeroExitCode
    }
}

Describe "gcc" {
    $testCases = (Get-ToolsetContent).gcc.Versions | ForEach-Object { @{GccVersion = $_} }

    It "gcc <GccVersion>" -TestCases $testCases {
        "$GccVersion --version" | Should -ReturnZeroExitCode
    }
}

Describe "gfortran" {
    $testCases = (Get-ToolsetContent).gfortran.Versions | ForEach-Object { @{GfortranVersion = $_} }

    It "gfortran <GfortranVersion>" -TestCases $testCases {
        "$GfortranVersion --version" | Should -ReturnZeroExitCode
    }
}

Describe "Mono" {
    It "mono" {
        "mono --version" | Should -ReturnZeroExitCode
    }

    It "msbuild" {
        "msbuild -version" | Should -ReturnZeroExitCode
    }

    It "nuget" {
        "nuget" | Should -ReturnZeroExitCode
    }
}

Describe "MSSQLCommandLineTools" -Skip:(Test-IsUbuntu24) {
    It "sqlcmd" {
        "sqlcmd -?" | Should -ReturnZeroExitCode
    }
}

Describe "SqlPackage" -Skip:(Test-IsUbuntu24) {
    It "sqlpackage" {
        "sqlpackage /version" | Should -ReturnZeroExitCode
    }
}

Describe "R" {
    It "r" {
        "R --version" | Should -ReturnZeroExitCode
    }
}

Describe "Sbt" -Skip:(Test-IsUbuntu24) {
    It "sbt" {
        "sbt --version" | Should -ReturnZeroExitCode
    }
}

Describe "Selenium" {
    It "Selenium is installed" {
        $seleniumPath = Join-Path "/usr/share/java" "selenium-server.jar"
        $seleniumPath | Should -Exist
    }
}

Describe "Terraform" -Skip:(Test-IsUbuntu24) {
    It "terraform" {
        "terraform --version" | Should -ReturnZeroExitCode
    }
}

Describe "Zstd" {
    It "zstd" {
        "zstd --version" | Should -ReturnZeroExitCode
    }

    It "pzstd" {
        "pzstd --version" | Should -ReturnZeroExitCode
    }
}

Describe "Vcpkg" {
    It "vcpkg" {
        "vcpkg version" | Should -ReturnZeroExitCode
    }
}

Describe "Git" {
    It "git" {
        "git --version" | Should -ReturnZeroExitCode
    }

    It "git-ftp" {
        "git-ftp --version" | Should -ReturnZeroExitCode
    }
}

Describe "Git-lfs" {
    It "git-lfs" {
        "git-lfs --version" | Should -ReturnZeroExitCode
    }
}

Describe "Heroku" -Skip:(Test-IsUbuntu24) {
    It "heroku" {
        "heroku --version" | Should -ReturnZeroExitCode
    }
}

Describe "HHVM" -Skip:(Test-IsUbuntu22) {
    It "hhvm" {
        "hhvm --version" | Should -ReturnZeroExitCode
    }
}

Describe "Homebrew" {
    It "homebrew" {
        "/home/linuxbrew/.linuxbrew/bin/brew --version" | Should -ReturnZeroExitCode
    }
}

Describe "Julia" {
    It "julia" {
        "julia --version" | Should -ReturnZeroExitCode
    }
}

Describe "Kubernetes tools" {
    It "kind" {
        "kind version" | Should -ReturnZeroExitCode
    }

    It "kubectl" {
        "kubectl version --client=true" | Should -OutputTextMatchingRegex "Client Version: v"
    }

    It "helm" {
        "helm version --short" | Should -ReturnZeroExitCode
    }

    It "minikube" {
        "minikube version --short" | Should -ReturnZeroExitCode
    }

    It "kustomize" {
        "kustomize version" | Should -ReturnZeroExitCode
    }
}

Describe "Leiningen" -Skip:(Test-IsUbuntu24) {
    It "leiningen" {
        "lein --version" | Should -ReturnZeroExitCode
    }
}

Describe "Conda" {
    It "conda" {
        "conda --version" | Should -ReturnZeroExitCode
    }
}

Describe "Packer" -Skip:(Test-IsUbuntu24) {
    It "packer" {
        "packer --version" | Should -ReturnZeroExitCode
    }
}

Describe "Pulumi" {
    It "pulumi" {
        "pulumi version" | Should -ReturnZeroExitCode
    }
}

Describe "Phantomjs" -Skip:(Test-IsUbuntu22) {
    It "phantomjs" {
        $env:OPENSSL_CONF="/etc/ssl"
        "phantomjs --version" | Should -ReturnZeroExitCode
    }
}

Describe "Containers" -Skip:(Test-IsUbuntu24) {
    $testCases = @("podman", "buildah", "skopeo") | ForEach-Object { @{ContainerCommand = $_} }

    It "<ContainerCommand>" -TestCases $testCases {
        "$ContainerCommand -v" | Should -ReturnZeroExitCode
    }

    # https://github.com/actions/runner-images/issues/7753
    It "podman networking" -TestCases "podman CNI plugins" {
        "podman network create -d bridge test-net" | Should -ReturnZeroExitCode
        "podman network ls" | Should -Not -OutputTextMatchingRegex "Error"
        "podman network rm test-net" | Should -ReturnZeroExitCode
    }

}

Describe "nvm" -Skip:(Test-IsUbuntu24) {
    It "nvm" {
        "source /etc/skel/.nvm/nvm.sh && nvm --version" | Should -ReturnZeroExitCode
    }
}

Describe "Python" {
    $testCases = @("python", "pip", "python3", "pip3") | ForEach-Object { @{PythonCommand = $_} }

    It "<PythonCommand>" -TestCases $testCases {
        "$PythonCommand --version" | Should -ReturnZeroExitCode
    }
}

Describe "Ruby" {
    $testCases = @("ruby", "gem") | ForEach-Object { @{RubyCommand = $_} }

    It "<RubyCommand>" -TestCases $testCases {
        "$RubyCommand --version" | Should -ReturnZeroExitCode
    }

    $gemTestCases = (Get-ToolsetContent).rubygems | ForEach-Object { @{gemName = $_.name} }

    if ($gemTestCases) {
        It "Gem <gemName> is installed" -TestCases $gemTestCases {
            "gem list -i '^$gemName$'" | Should -OutputTextMatchingRegex "true"
        }
    }
}

Describe "yq" {
    It "yq" {
        "yq -V" | Should -ReturnZeroExitCode
    }
}

Describe "Kotlin" -Skip:(Test-IsUbuntu24) {
    It "kapt" {
        "kapt -version" | Should -ReturnZeroExitCode
    }

    It "kotlin" {
        "kotlin -version" | Should -ReturnZeroExitCode
    }

    It "kotlinc" {
        "kotlinc -version" | Should -ReturnZeroExitCode
    }

    It "kotlinc-jvm" {
        "kotlinc-jvm -version" | Should -ReturnZeroExitCode
    }

    It "kotlin-dce-js" {
        "kotlin-dce-js -version" | Should -ReturnZeroExitCode
    }
}
