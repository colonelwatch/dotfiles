return {
    name = "mdformat",
    description = "CommonMark compliant Markdown formatter.",
    homepage = "https://github.com/executablebooks/mdformat",
    licenses = { "MIT" },
    languages = { "Markdown" },
    categories = { "Formatter" },
    source = {
        id = "pkg:pypi/mdformat@0.7.22",
        extra_packages = { "mdformat-myst==0.2.1" },
    },
    bin = {
        ["mdformat"] = "pypi:mdformat",
    },
}