Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1"
Describe "Firefox" -Skip:(Test-IsUbuntu24) {
    It "Firefox" {
        "firefox --version" | Should -ReturnZeroExitCode
    }

    It "Geckodriver" {
        "geckodriver --version" | Should -ReturnZeroExitCode
    }
}

Describe "Chrome" {
    It "Chrome" {
        "google-chrome --version" | Should -ReturnZeroExitCode
    }

    It "Chrome Driver" {
        "chromedriver --version" | Should -ReturnZeroExitCode
    }

    It "Chrome and Chrome Driver major versions are the same" {
        $chromeMajor = (google-chrome --version).Trim("Google Chrome ").Split(".")[0]
        $chromeDriverMajor = (chromedriver --version).Trim("ChromeDriver ").Split(".")[0]
        $chromeMajor | Should -BeExactly $chromeDriverMajor
    }
}

Describe "Edge" -Skip:(Test-IsUbuntu24) {
    It "Edge" {
        "microsoft-edge --version" | Should -ReturnZeroExitCode
    }

    It "Edge Driver" {
        "msedgedriver --version" | Should -ReturnZeroExitCode
    }
}

Describe "Chromium" {
    It "Chromium" {
        "chromium-browser --version" | Should -ReturnZeroExitCode
    }
}
