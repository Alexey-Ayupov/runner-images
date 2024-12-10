Describe "Edge" {
    Context "WebDriver" {
        It "EdgeWebDriver environment variable and path exists" {
            $env:EdgeWebDriver | Should -Not -BeNullOrEmpty
            $env:EdgeWebDriver | Should -BeExactly "C:\SeleniumWebDrivers\EdgeDriver"
            $env:EdgeWebDriver | Should -Exist
        }

        It "msedgedriver.exe is installed" {
            "$env:EdgeWebDriver\msedgedriver.exe --version" | Should -ReturnZeroExitCode
        }

        It "versioninfo.txt exists" {
            "$env:EdgeWebDriver\versioninfo.txt" | Should -Exist
        }
    }

    Context "Browser" {
        $edgeRegPath = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe"

        It "Edge '<edgeRegPath>' registry path exists" -TestCases @{edgeRegPath = $edgeRegPath} {
            $edgeRegPath | Should -Exist
        }

        It "Edge VersionInfo registry value exists" -TestCases @{edgeRegPath = $edgeRegPath} {
            $versionInfo = (Get-Item (Get-ItemProperty $edgeRegPath).'(Default)').VersionInfo
            $versionInfo | Should -Not -BeNullOrEmpty
        }

        It "msedge.exe is installed" {
            "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe" | Should -Exist
        }
    }
}

Describe "Firefox" {
    Context "WebDriver" {
        It "GeckoWebDriver environment variable and path exists" {
            $env:GeckoWebDriver | Should -Not -BeNullOrEmpty
            $env:GeckoWebDriver | Should -BeExactly "C:\SeleniumWebDrivers\GeckoDriver"
            $env:GeckoWebDriver | Should -Exist
        }

        It "geckodriver.exe is installed" {
            "$env:GeckoWebDriver\geckodriver.exe --version" | Should -ReturnZeroExitCode
        }

        It "versioninfo.txt exists" {
            "$env:GeckoWebDriver\versioninfo.txt" | Should -Exist
        }
    }

    Context "Browser" {
        $firefoxRegPath = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe"

        It "Firefox '<firefoxRegPath>' registry path exists" -TestCases @{firefoxRegPath = $firefoxRegPath} {
            $firefoxRegPath | Should -Exist
        }

        It "Firefox VersionInfo registry value exists" -TestCases @{firefoxRegPath = $firefoxRegPath} {
            $versionInfo = (Get-Item (Get-ItemProperty $firefoxRegPath).'(Default)').VersionInfo
            $versionInfo | Should -Not -BeNullOrEmpty
        }

        It "firefox.exe is installed" {
            "$env:ProgramFiles\Mozilla Firefox\firefox.exe" | Should -Exist
        }
    }
}

Describe "Internet Explorer" {
    Context "WebDriver" {
        It "IEWebDriver environment variable and path exists" {
            $env:IEWebDriver | Should -Not -BeNullOrEmpty
            $env:IEWebDriver | Should -BeExactly "C:\SeleniumWebDrivers\IEDriver"
            $env:IEWebDriver | Should -Exist
        }

        It "iedriverserver.exe is installed" {
            "$env:IEWebDriver\IEDriverServer.exe --version" | Should -ReturnZeroExitCode
        }

        It "versioninfo.txt exists" {
            "$env:IEWebDriver\versioninfo.txt" | Should -Exist
        }
    }
}

Describe "Selenium" {
    BeforeAll {
        $seleniumBinPath = "C:\selenium\selenium-server.jar"
    }

    It "Selenium server is installed" {
        $seleniumBinPath | Should -Exist
    }

    It "SELENIUM_JAR_PATH environment variable exists" {
        Get-EnvironmentVariable "SELENIUM_JAR_PATH" | Should -BeExactly "$seleniumBinPath"
    }
}
