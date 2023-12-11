#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

#ANSI Escape Codes for colors to increase contrast of errors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

st=0

# check for ripgrep
if command -v rg >/dev/null 2>&1; then
	grep=rg
	pcre2_support=1
	if [ ! rg -P '' >/dev/null 2>&1 ] ; then
		pcre2_support=0
	fi
	code_files="-g *.dm"
	map_files="-g *.dmm"
	ignore_515_proc_marker='-g !__byond_version_compat.dm'
else
	pcre2_support=0
	grep=grep
	code_files="-r --include=*.dm"
	map_files="-r --include=*.dmm"
	ignore_515_proc_marker="--exclude=__byond_version_compat.dm"
fi

echo -e "${BLUE}Using grep provider at $(which $grep)${NC}"

part=0
section() {
	echo -e "${BLUE}Checking for $1${NC}..."
	part=0
}

part() {
	part=$((part+1))
	padded=$(printf "%02d" $part)
	echo -e "${GREEN} $padded- $1${NC}"
}

section "map issues"

part "TGM"
if $grep -U '^".+" = \(.+\)' $map_files;	then
	echo
    echo -e "${RED}ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!${NC}"
    st=1
fi;
part "comments"
if $grep '//' $map_files | $grep -v '//MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE' | $grep -v 'name|desc'; then
	echo
	echo -e "${RED}ERROR: Unexpected commented out line detected in this map file. Please remove it.${NC}"
	st=1
fi;
part "iconstate tags"
if $grep '^\ttag = "icon' $map_files;	then
	echo
    echo -e "${RED}ERROR: Tag vars from icon state generation detected in maps, please remove them.${NC}"
    st=1
fi;
part "invalid map procs"
if $grep '(new|newlist|icon|matrix|sound)\(.+\)' $map_files;	then
	echo
	echo -e "${RED}ERROR: Using unsupported procs in variables in a map file! Please remove all instances of this.${NC}"
	st=1
fi;

section "whitespace issues"
part "space indentation"
if $grep '(^ {2})|(^ [^ * ])|(^    +)' $code_files; then
	echo
    echo -e "${RED}ERROR: Space indentation detected, please use tab indentation.${NC}"
    st=1
fi;
part "mixed indentation"
if $grep '^\t+ [^ *]' $code_files; then
	echo
    echo -e "${RED}ERROR: Mixed <tab><space> indentation detected, please stick to tab indentation.${NC}"
    st=1
fi;

echo -e "${BLUE}Checking for common mistakes...${NC}"

if grep -P 'to_chat\((?!.*,).*\)' code/**/*.dm; then
	echo
    echo -e "${RED}ERROR: to_chat() missing arguments.${NC}"
    st=1
fi;
if grep -P 'addtimer\((?=.*TIMER_OVERRIDE)(?!.*TIMER_UNIQUE).*\)' code/**/*.dm; then
	echo
    echo -e "${RED}ERROR: TIMER_OVERRIDE used without TIMER_UNIQUE.${NC}"
    st=1
fi;

unit_test_files="code/modules/unit_tests/**/**.dm"
if grep 'allocate\(/mob/living/carbon/human[,\)]' $unit_test_files ||
	grep 'new /mob/living/carbon/human\s?\(' $unit_test_files ||
	grep 'var/mob/living/carbon/human/\w+\s?=\s?new' $unit_test_files ; then
	echo
	echo -e "${RED}ERROR: Usage of mob/living/carbon/human detected in a unit test, please use mob/living/carbon/human/consistent.${NC}"
	st=1
fi;
if grep '^/*var/' code/**/*.dm; then
	echo
    echo -e "${RED}ERROR: Unmanaged global var use detected in code, please use the helpers.${NC}"
    st=1
fi;
part "proc args with var/"
if $grep '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' $code_files; then
	echo
    echo -e "${RED}ERROR: Changed files contains a proc argument starting with 'var'.${NC}"
    st=1
fi;
part "balloon_alert sanity"
if $grep 'balloon_alert\(".+"\)' $code_files; then
	echo
	echo -e "${RED}ERROR: Found a balloon alert with improper arguments.${NC}"
	st=1
fi;
part "common spelling mistakes"
if $grep -i 'centcomm' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of CentCom detected in code, please remove the extra M(s).${NC}"
    st=1
fi;
if $grep -ni 'nanotransen' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Nanotrasen detected in code, please remove the extra N(s).${NC}"
    st=1
fi;
part "map json naming"
if ls _maps/*.json | $grep "[A-Z]"; then
	echo
    echo -e "${RED}ERROR: Uppercase in a map .JSON file detected, these must be all lowercase.${NC}"
    st=1
fi;
if $grep -ni 'nanotransen' $code_files; then
	echo
    echo -e "${RED}ERROR: Misspelling(s) of Nanotrasen detected in code, please remove the extra N(s).${NC}"
    st=1
fi;
part "map json naming"
if ls _maps/*.json | $grep "[A-Z]"; then
	echo
    echo -e "${RED}ERROR: Uppercase in a map .JSON file detected, these must be all lowercase.${NC}"
fi;

# Check for non-515 compatable .proc/ syntax
if grep -P --exclude='__byond_version_compat.dm' '\.proc/' code/**/*.dm; then
    echo
    echo -e "${RED}ERROR: Outdated proc reference use detected in code, please use proc reference helpers.${NC}"
    st=1
fi;

if [ "$pcre2_support" -eq 1 ]; then
	section "regexes requiring PCRE2"
	part "to_chat sanity"
	if $grep -P 'to_chat\((?!.*,).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: to_chat() missing arguments.${NC}"
		st=1
	fi;
	part "timer flag sanity"
	if $grep -P 'addtimer\((?=.*TIMER_OVERRIDE)(?!.*TIMER_UNIQUE).*\)' $code_files; then
		echo
		echo -e "${RED}ERROR: TIMER_OVERRIDE used without TIMER_UNIQUE.${NC}"
		st=1
	fi
	part "trailing newlines"
	if $grep -PU '[^\n]$(?!\n)' $code_files; then
		echo
		echo -e "${RED}ERROR: File(s) with no trailing newline detected, please add one.${NC}"
		st=1
	fi
else
	echo -e "${RED}pcre2 not supported, skipping checks requiring pcre2"
	echo -e "if you want to run these checks install ripgrep with pcre2 support.${NC}"
fi

if [ $st = 0 ]; then
    echo
    echo -e "${GREEN}No errors found using $grep!${NC}"
fi;

if [ $st = 1 ]; then
    echo
    echo -e "${RED}Errors found, please fix them and try again.${NC}"
fi;

exit $st
