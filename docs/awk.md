jkj# Awk


Awk splits on the input field seperator which defaults to whitespace between tokens and indexs them with `$n` to the token number starting with 1.

## Basic usage

```sh
date
```
```
Sat Nov  7 11:39:00 PST 2020
```
```sh
date | awk '{print $4}' | awk -F: 'OFS="~"{print $1,$2,$NF}'
```
```
11~45~11
```

Notes:
- $0 prints the whole line
- `$NF` prints the last token
- `OFS=~` is the sperator
- `ORS=""` sets the output record sperator defaults to `\n`


## BEGIN / END

```sh
date | awk 'BEGIN {print "TODAY"} OFS="-" {print $2,$3,$6}'
```
```
TODAY
Nov-7-2020
```

## Filter

```sh
t=`mktemp`
cat > $t << TERM
Vulnerability Management & Patch Policy
---------------------------------------


**\#{vulnerabilitySources}**

\#{maybeExternalVulnerabilityScanning}'s

-   The \#{tacticalResponsibilityVulnerabilityManagement} is responsible
    for communicating detected vulnerabilities and package updates
    needed to the appropriate engineering staff for resolution.
TERM
```


```sh
cat $t | awk '/#{/ {print $0}'
# or since print is default
cat $t | awk '/#{/'
```
```
tokens
\#{vulnerabilitySources}
\#{maybeExternalVulnerabilityScanning}
-   The \#{tacticalResponsibilityVulnerabilityManagement} is responsible
```

Filter to words that match

```sh
awk 'OFS="\n" { for (i=1; i<=NF; i++) { if ( $i ~ /#\{/ ) { print $i } } }' $t
```

## Substitution

Substitute "foo" with "bar" only on lines that do not contain "baz".

```sh
awk '!/baz/ { gsub(/foo/, "bar") }; { print }'
```

notes:
- remove the `!` to match only lines with `baz`

Change "scarlet" or "ruby" or "puce" to "red".

```sh
awk '{ gsub(/scarlet|ruby|puce/, "red"); print}'
```

Print only the tokens

```sh
awk 'BEGIN {tokens=0} /#{/ {tokens++} END {print tokens " tokens.\n"}'
```

Strip trailing characters

```sh
awk '{ for (i=1; i<=NF; i++) { if ( $i ~ /#\{/ ) {gsub(/}.+$/,"}", $i);  print $i } } }' $t
```

Strip leading characters
```sh
awk '{ for (i=1; i<=NF; i++) { if ( $i ~ /#\{/ )  {gsub(/^.+\\/, "\\", $i); print $i } } }' $t
```

Strip leading and trailing characters
```sh
awk '{ for (i=1; i<=NF; i++) { if ( $i ~ /#\{/ ) {gsub(/}.+$/,"}", $i);  gsub(/^.+\\/, "\\", $i); print $i } } }' $t
```


unique tokens in dir of MD files
```sh
for f in `ls *.md`; do 
	awk '{ for (i=1; i<=NF; i++) { if ( $i ~ /#\{/ ) {gsub(/}.+$/,"}", $i);  gsub(/^.+\\/, "\\", $i); print $i } } }' $f
done | sort | uniq
```


## Vars

```sh
cat $t | awk 'BEGIN {tokens=0} /#{/ {tokens++} END {print tokens " tokens.\n"}'
```
```
3 tokens.

```

## Scripted

```sh
a=`mktemp`
cat > $a << TERM
#!/usr/bin/awk -f

BEGIN {
  tokens=0
}
/#{/{
  tokens++
}
END {
  print tokens " tokens.\n"
}
TERM
chmod +x $a
cat $t | $a
```

