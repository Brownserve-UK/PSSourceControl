class GitURI
{
    [string]$URI

    GitURI([string]$str)
    {
        if ($str -match '^git@(?<host>.*):(?<owner>.*)\/(?<repo>.*).git$')
        {
            $this.URI = $str
        }
        else
        {
            throw "String does not match git URI format."
        }
    }
}